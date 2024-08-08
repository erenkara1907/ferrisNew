import 'dart:async';
import 'dart:io' show Platform;

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/home/data/models/job_tracking_coordinates/tracking_coordinates_response_model_item.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart' as lot;
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'package:permission_handler/permission_handler.dart';

class MapViewPage extends StatefulWidget {
  @override
  _MapViewPageState createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  final ValueNotifier<BitmapDescriptor> sourceIcon =
      ValueNotifier<BitmapDescriptor>(BitmapDescriptor.defaultMarker);
  final ValueNotifier<BitmapDescriptor> destinationIcon =
      ValueNotifier<BitmapDescriptor>(BitmapDescriptor.defaultMarker);
  final ValueNotifier<BitmapDescriptor> currentIcon =
      ValueNotifier<BitmapDescriptor>(BitmapDescriptor.defaultMarker);
  final ValueNotifier<List<LatLng>> polyLineCoordinates =
      ValueNotifier<List<LatLng>>([]);
  final ValueNotifier<LocationData?> currentLocation =
      ValueNotifier<LocationData?>(null);
  final Completer<GoogleMapController> _controller = Completer();
  final ValueNotifier<TrackingCoordinatesResponseModelItem?>
      _trackingCoordinateNotifier =
      ValueNotifier<TrackingCoordinatesResponseModelItem?>(null);
  final Dio dio = Dio();
  final ValueNotifier<String?> _duration = ValueNotifier<String?>(null);
  GoogleMapController? _mapController;
  StreamSubscription<LocationData>? _locationSubscription;
  final ValueNotifier<bool> _isTracking = ValueNotifier<bool>(false);
  LatLng? initialPosition; // Sabit başlangıç konumu

  String googleApiKey = Platform.isIOS
      ? 'AIzaSyAeliVFiosa6wUWV4F_tbF2LcPf2FiFFi4'
      : 'AIzaSyAxE2RP4vyKyE4RnFc6wJpXIfauNw';

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void didChangeDependencies() {
    if (_trackingCoordinateNotifier.value != null) fetchTravelTime();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> checkPermission(
      Permission permission, BuildContext context) async {
    final permission_handler.PermissionStatus status =
        await permission.request();
    if (status.isGranted) {
      BotToast.showText(text: 'Permission is Granted');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
                textAlign: TextAlign.center,
                'To use this feature, please enable location permissions in settings.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Go to Settings'),
                onPressed: () {
                  Navigator.of(context).pop();
                  openAppSettings();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View', style: context.textTheme.titleSmall),
        leading: IconButton(
          icon: Icon(
            Icons.cancel_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ValueListenableBuilder<TrackingCoordinatesResponseModelItem?>(
        valueListenable: _trackingCoordinateNotifier,
        builder: (context, value, child) {
          if (currentLocation.value == null ||
              _trackingCoordinateNotifier.value == null) {
            return FutureBuilder<permission_handler.PermissionStatus>(
              future: permission_handler.Permission.location.status,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isGranted) {
                  return const Center(
                    child: LoadingProgress(),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        lot.Lottie.asset('assets/lottie/fr_pin2.json',
                            height: 150, width: 150),
                        SizedBox(
                          height: context.lowValue,
                        ),
                        Padding(
                          padding: context.paddingHorizontalHigh +
                              context.paddingVerticalDefault,
                          child: const Text(
                              textAlign: TextAlign.center,
                              'To see your location, turn on location permission in settings.'),
                        ),
                        SizedBox(
                          height: context.defaultValue,
                        ),
                        TextButton(
                            onPressed: () {
                              checkPermission(Permission.location, context);
                            },
                            child: const Text(
                              'Check Permission',
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            )),
                      ],
                    ),
                  );
                }
              },
            );
          } else {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(currentLocation.value!.latitude!,
                        currentLocation.value!.longitude!),
                    zoom: 14.5,
                  ),
                  onMapCreated: (mapController) {
                    _controller.complete(mapController);
                    _mapController = mapController;
                    _showInfoWindow();
                  },
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  polylines: {
                    Polyline(
                      width: 5,
                      color: context.theme.colorScheme.primaryContainer,
                      polylineId: const PolylineId("route"),
                      points: polyLineCoordinates.value,
                    )
                  },
                  markers: {
                    Marker(
                      icon: sourceIcon.value,
                      markerId: const MarkerId('source'),
                      position: initialPosition ??
                          LatLng(currentLocation.value!.latitude!,
                              currentLocation.value!.longitude!),
                    ),
                    Marker(
                      infoWindow: InfoWindow(
                        title: _duration.value,
                        snippet: 'Destination',
                      ),
                      icon: destinationIcon.value,
                      markerId: const MarkerId('destination'),
                      position: LatLng(
                        _trackingCoordinateNotifier.value!.latitude!,
                        _trackingCoordinateNotifier.value!.longitude!,
                      ),
                    ),
                    Marker(
                      icon: currentIcon.value,
                      markerId: const MarkerId('currentLocation'),
                      position: LatLng(currentLocation.value!.latitude!,
                          currentLocation.value!.longitude!),
                    ),
                  },
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      _isTracking.value = !_isTracking.value;
                    },
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isTracking,
                      builder: (context, isTracking, child) {
                        return Icon(isTracking
                            ? Icons.location_searching
                            : Icons.location_disabled);
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _showInfoWindow() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mapController?.showMarkerInfoWindow(const MarkerId('destination'));
  }

  void _initializeMap() async {
    _trackingCoordinateNotifier.value =
        await ProductStateItems.hiveStorageManager.getTrackingCoordinateModel();

    if (context.read<HomeBloc>().state.selectedTrackingCoordinate != null) {
      LatLng selectedCoordinate = LatLng(
        context.read<HomeBloc>().state.selectedTrackingCoordinate!.latitude ??
            0.0,
        context.read<HomeBloc>().state.selectedTrackingCoordinate!.longitude ??
            0.0,
      );
    }

    await getCurrentLocation();
    setCustomMarker();
    await getPolyPoints();
  }

  Future<void> getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleApiKey,
        request: PolylineRequest(
            origin: PointLatLng(currentLocation.value!.latitude!,
                currentLocation.value!.longitude!),
            destination: PointLatLng(
              _trackingCoordinateNotifier.value!.latitude!,
              _trackingCoordinateNotifier.value!.longitude!,
            ),
            mode: TravelMode.driving),
      );

      if (result.points.isNotEmpty) {
        List<LatLng> points = [];
        result.points.forEach((PointLatLng point) {
          points.add(LatLng(point.latitude, point.longitude));
        });
        polyLineCoordinates.value = points;
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> getCurrentLocation() async {
    Location location = Location();

    try {
      currentLocation.value = await location.getLocation();

      initialPosition ??= LatLng(
          currentLocation.value!.latitude!,
          currentLocation.value!.longitude!,
        );

      _locationSubscription =
          location.onLocationChanged.listen((LocationData newLoc) {
        if (!mounted) return;
        currentLocation.value = newLoc;
        _updateCurrentLocationMarker();
        setState(() {});
      });
    } catch (e) {
      print(e);
    }
  }

  void _updateCurrentLocationMarker() {
    if (_isTracking.value) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(currentLocation.value!.latitude!,
              currentLocation.value!.longitude!),
        ),
      );
    }

    setState(() {
      _mapController?.showMarkerInfoWindow(const MarkerId('destination'));
    });
  }

  Future<void> fetchTravelTime() async {
    try {
      String baseUrl =
          "https://maps.googleapis.com/maps/api/distancematrix/json";
      String parameters =
          "units=imperial&origins=${currentLocation.value!.latitude},${currentLocation.value!.longitude}&destinations=${_trackingCoordinateNotifier.value!.latitude},${_trackingCoordinateNotifier.value!.longitude}&key=$googleApiKey";
      Response response = await dio.get("$baseUrl?$parameters");
      _duration.value =
          response.data['rows'][0]['elements'][0]['duration']['text'];
      setState(() {
        if (_mapController != null) {
          _mapController?.showMarkerInfoWindow(const MarkerId('destination'));
        }
      });
    } catch (e) {
      print("Travel time fetch error: $e");
    }
  }

  void setCustomMarker() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'assets/images/origin.png',
    ).then((icon) {
      sourceIcon.value = icon;
    });
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'assets/images/destination.png',
    ).then((icon) {
      destinationIcon.value = icon;
    });
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'assets/images/current_location.png',
    ).then((icon) {
      currentIcon.value = icon;
    });
  }
}
