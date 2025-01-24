import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart' as permissionhandler;

import '../../../../product/state/container/product_state_items.dart';
import '../../../../product/utility/error_handler/sentry_error_handler.dart';

class MapViewPage2 extends StatefulWidget {
  const MapViewPage2({super.key});

  @override
  State<MapViewPage2> createState() => _MapViewPage2State();
}

class _MapViewPage2State extends State<MapViewPage2> {
  JobsResponseModelItem? job;
  google.LatLng? toCoordinates;
  google.LatLng? fromCoordinates;
  google.LatLng? checkpoint1Coordinates;
  google.LatLng? checkpoint2Coordinates;
  google.LatLng? checkpoint3Coordinates;
  google.LatLng? currentLocation;
  List<Polyline> polylines = [];
  String googleApiKey = 'AIzaSyAeliVFiosa6wUWV4F_tbF2LcPf2FiFFi4';
  // String googleApiKey = Platform.isIOS
  //     ? 'AIzaSyAeliVFiosa6wUWV4F_tbF2LcPf2FiFFi4'
  //     : 'AIzaSyAxE2RP4vyKyE4RnFc6wJpXIfauNw';
  late Location location;
  google.Marker? currentLocationMarker;
  google.GoogleMapController? _mapController;
  final ValueNotifier<String> _duration = ValueNotifier<String>("");

  ValueNotifier<BitmapDescriptor> sourceIcon = ValueNotifier<BitmapDescriptor>(BitmapDescriptor.defaultMarker);
  ValueNotifier<BitmapDescriptor> destinationIcon = ValueNotifier<BitmapDescriptor>(BitmapDescriptor.defaultMarker);
  ValueNotifier<BitmapDescriptor> currentIcon = ValueNotifier<BitmapDescriptor>(BitmapDescriptor.defaultMarker);

  StreamSubscription<LocationData>? _locationSubscription;

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

  void getPolyPointsWithCheckpoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> points = [];

    if (job != null) {
      if (job!.startAddressCordinates != null && job!.startAddress != null) {
        points.add(PointLatLng(
          job!.startAddressCordinates!.latitude,
          job!.startAddressCordinates!.longitude,
        ));
      } else {
        BotToast.showText(text: "Address Not Found");
        ProductStateItems.appRouter.router.routerDelegate.navigatorKey.currentContext?.go('/job_detail_page');
      }
    }

    if (checkpoint1Coordinates != null) {
      points.add(PointLatLng(
        checkpoint1Coordinates!.latitude,
        checkpoint1Coordinates!.longitude,
      ));
    }

    if (checkpoint2Coordinates != null) {
      points.add(PointLatLng(
        checkpoint2Coordinates!.latitude,
        checkpoint2Coordinates!.longitude,
      ));
    }

    if (checkpoint3Coordinates != null) {
      points.add(PointLatLng(
        checkpoint3Coordinates!.latitude,
        checkpoint3Coordinates!.longitude,
      ));
    }

    if (job != null) {
      if (job!.endAddress != null && job!.endAddressCordinates != null) {
        points.add(PointLatLng(
          job!.endAddressCordinates!.latitude,
          job!.endAddressCordinates!.longitude,
        ));
      } else {
        BotToast.showText(text: "Address Not Found");
        ProductStateItems.appRouter.router.routerDelegate.navigatorKey.currentContext?.go('/job_detail_page');
      }
    }

    for (int i = 0; i < points.length - 1; i++) {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(origin: points[i], destination: points[i + 1], mode: TravelMode.driving),
        googleApiKey: googleApiKey,
      );

      if (result.points.isNotEmpty) {
        List<google.LatLng> segmentPoints = [];
        for (var point in result.points) {
          segmentPoints.add(
            google.LatLng(point.latitude, point.longitude),
          );
        }
        Color polylineColor;
        if (i == 0) {
          polylineColor = Colors.blue;
        } else if (i == 1 && checkpoint1Coordinates != null) {
          polylineColor = Colors.green;
        } else if (i == 2 && checkpoint2Coordinates != null) {
          polylineColor = Colors.red;
        } else {
          polylineColor = Colors.deepPurple;
        }
        polylines.add(Polyline(
          polylineId: PolylineId('route_segment_$i'),
          points: segmentPoints,
          color: polylineColor,
          width: 4,
        ));
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    location = Location();
    job = context.read<HomeBloc>().state.showJob;
    if (job != null) {
      _initializeMap();
      getPolyPointsWithCheckpoints();
      _initCurrentLocation();
      setCustomMarker();
    }
  }

  @override
  void didChangeDependencies() {
    fetchTravelTime();
    super.didChangeDependencies();
  }

  Future<void> fetchTravelTime() async {
    try {
      String baseUrl = "https://maps.googleapis.com/maps/api/distancematrix/json";
      if (job != null) {
        if (job!.startAddress != null &&
            job!.startAddressCordinates != null &&
            job!.endAddressCordinates != null &&
            job!.endAddress != null) {
          String parameters =
              "units=imperial&origins=${job!.startAddressCordinates!.latitude},${job!.startAddressCordinates!.longitude}&destinations=${job!.endAddressCordinates!.latitude},${job!.endAddressCordinates!.longitude}&key=$googleApiKey";
          Response response = await Dio().get("$baseUrl?$parameters");
          _duration.value = response.data['rows'][0]['elements'][0]['duration']['text'];
        } else {
          BotToast.showText(text: "Address Not Found");
          ProductStateItems.appRouter.router.routerDelegate.navigatorKey.currentContext?.go('/job_detail_page');
        }
      }

      setState(() {
        if (_mapController != null) {
          _mapController?.showMarkerInfoWindow(const MarkerId('destination'));
        }
      });
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
    }
  }

  void _initializeMap() {
    if (job != null) {
      if (job!.endAddress != null && job!.endAddressCordinates != null) {
        toCoordinates = google.LatLng(
          job!.endAddressCordinates!.latitude,
          job!.endAddressCordinates!.longitude,
        );
      } else {
        BotToast.showText(text: "Address Not Found");
        ProductStateItems.appRouter.router.routerDelegate.navigatorKey.currentContext?.go('/job_detail_page');
      }

      if (job!.startAddress != null && job!.startAddressCordinates != null) {
        fromCoordinates = google.LatLng(
          job!.startAddressCordinates!.latitude,
          job!.startAddressCordinates!.longitude,
        );
      } else {
        BotToast.showText(text: "Address Not Found");
        ProductStateItems.appRouter.router.routerDelegate.navigatorKey.currentContext?.go('/job_detail_page');
      }
    }

    checkpoint1Coordinates = job!.checkpoint1AddressCordinates != null
        ? google.LatLng(
            job!.checkpoint1AddressCordinates!.latitude,
            job!.checkpoint1AddressCordinates!.longitude,
          )
        : null;
    checkpoint2Coordinates = job!.checkpoint2AddressCordinates != null
        ? google.LatLng(
            job!.checkpoint2AddressCordinates!.latitude,
            job!.checkpoint2AddressCordinates!.longitude,
          )
        : null;
    checkpoint3Coordinates = job!.checkpoint3AddressCordinates != null
        ? google.LatLng(
            job!.checkpoint3AddressCordinates!.latitude,
            job!.checkpoint3AddressCordinates!.longitude,
          )
        : null;
  }

  void _initCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        context.push('/check_location_page', extra: {'location': location});
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        context.push('/check_location_page', extra: {'location': location});
        return;
      }
    }

    final locationData = await location.getLocation();
    _updateCurrentLocation(locationData);

    _locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
      _updateCurrentLocation(currentLocation);
    });
  }

  void _updateCurrentLocation(LocationData locationData) {
    if (!mounted) return;
    setState(() {
      currentLocation = google.LatLng(locationData.latitude!, locationData.longitude!);
      currentLocationMarker = google.Marker(
        markerId: const google.MarkerId('current_location'),
        position: currentLocation!,
        icon: currentIcon.value,
      );
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  void _goToLocation(google.LatLng target) {
    _mapController?.animateCamera(
      google.CameraUpdate.newCameraPosition(
        google.CameraPosition(target: target, zoom: 14.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (job == null) {
      if (fromCoordinates == null ||
          toCoordinates == null ||
          job!.startAddress == null ||
          job!.endAddress == null ||
          job!.startAddressCordinates == null ||
          job!.endAddressCordinates == null) {
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
          body: Padding(
            padding: context.paddingHorizontalHigh + context.paddingHorizontalHigh,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/no_location.png',
                  height: context.dynamicHeight(0.18),
                  width: context.dynamicWidth(2),
                ),
                const VerticalSpace.small(),
                Text(
                  textAlign: TextAlign.center,
                  'The address and location cannot be found',
                  style: context.textTheme.bodyLarge,
                )
              ],
            ),
          ),
        );
      }
    }
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
      body: Stack(
        children: [
          google.GoogleMap(
            initialCameraPosition: google.CameraPosition(
              target: fromCoordinates!,
              zoom: 14.0,
            ),
            markers: {
              google.Marker(
                markerId: const google.MarkerId('source'),
                position: fromCoordinates!,
                icon: sourceIcon.value,
                infoWindow: InfoWindow(
                  title: 'From: ${job!.startAddress}',
                ),
              ),
              if (checkpoint1Coordinates != null)
                google.Marker(
                  markerId: const google.MarkerId('checkpoint1'),
                  position: checkpoint1Coordinates!,
                  infoWindow: InfoWindow(
                    title: 'Checkpoint 1',
                    snippet: 'Address: ${job!.checkpoint1Address}',
                  ),
                  icon: google.BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                ),
              if (checkpoint2Coordinates != null)
                google.Marker(
                  markerId: const google.MarkerId('checkpoint2'),
                  position: checkpoint2Coordinates!,
                  infoWindow: InfoWindow(
                    title: 'Checkpoint 2',
                    snippet: 'Address: ${job!.checkpoint2Address}',
                  ),
                  icon: google.BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                ),
              if (checkpoint3Coordinates != null)
                google.Marker(
                  markerId: const google.MarkerId('checkpoint3'),
                  position: checkpoint3Coordinates!,
                  infoWindow: InfoWindow(
                    title: 'Checkpoint 3',
                    snippet: 'Address: ${job!.checkpoint3Address}',
                  ),
                  icon: google.BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                ),
              google.Marker(
                markerId: const google.MarkerId('destination'),
                position: toCoordinates!,
                infoWindow: InfoWindow(
                  title: 'Time: ${_duration.value}',
                  snippet: 'To: ${job!.endAddress}',
                ),
                icon: destinationIcon.value,
              ),
              if (currentLocationMarker != null) currentLocationMarker!,
            },
            polylines: Set<Polyline>.of(polylines),
            onMapCreated: (controller) {
              _mapController = controller;
              _mapController?.showMarkerInfoWindow(const MarkerId('destination'));
            },
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: context.paddingRightLow + context.paddingTopHigh,
              child: Column(
                children: [
                  Container(
                    height: context.dynamicHeight(0.07),
                    width: context.dynamicWidth(0.13),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.onSurfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (currentLocation != null) {
                          _goToLocation(currentLocation!);
                        }
                      },
                      icon: Icon(
                        Icons.location_searching,
                        color: context.theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Container(
                    height: context.dynamicHeight(0.07),
                    width: context.dynamicWidth(0.13),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.onSurfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (fromCoordinates != null) {
                          _goToLocation(fromCoordinates!);
                        }
                      },
                      icon: Icon(
                        Icons.car_repair,
                        color: context.theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Container(
                    height: context.dynamicHeight(0.07),
                    width: context.dynamicWidth(0.13),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.onSurfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (toCoordinates != null) {
                          _goToLocation(toCoordinates!);
                        }
                      },
                      icon: Icon(
                        Icons.location_pin,
                        color: context.theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationSettingsPage extends StatefulWidget {
  final Location location;

  const LocationSettingsPage({super.key, required this.location});

  @override
  _LocationSettingsPageState createState() => _LocationSettingsPageState();
}

class _LocationSettingsPageState extends State<LocationSettingsPage> {
  late Stream<LocationData> _locationStream;
  late StreamSubscription<LocationData> _locationSubscription;

  @override
  void initState() {
    super.initState();
    _locationStream = widget.location.onLocationChanged;
    _locationSubscription = _locationStream.listen((locationData) async {
      bool serviceEnabled = await widget.location.serviceEnabled();
      PermissionStatus permissionGranted = await widget.location.hasPermission();

      if (serviceEnabled && permissionGranted == PermissionStatus.granted) {
        if (mounted) {
          context.pop();
        }
      }
    });
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie/fr_pin2.json', height: 150, width: 150),
            SizedBox(
              height: context.lowValue,
            ),
            Padding(
              padding: context.paddingHorizontalHigh + context.paddingVerticalDefault,
              child: const Text(
                textAlign: TextAlign.center,
                'To see your location, turn on location permission in settings.',
              ),
            ),
            SizedBox(
              height: context.defaultValue,
            ),
            TextButton(
              onPressed: () {
                permissionhandler.openAppSettings();
              },
              child: const Text(
                'Check Permission',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
