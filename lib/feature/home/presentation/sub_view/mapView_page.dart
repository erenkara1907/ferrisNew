// import 'dart:async';
// import 'dart:io' show Platform;

// import 'package:dio/dio.dart';
// import 'package:ferrisfwt/feature/home/data/models/job_tracking_coordinates/tracking_coordinates_response_model_item.dart';
// import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
// import 'package:ferrisfwt/product/extensions/context_extensions.dart';
// import 'package:ferrisfwt/product/state/container/product_state_items.dart';
// import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
// import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// import '../../../../product/utility/error_handler/sentry_error_handler.dart';

// class MapViewPage extends StatefulWidget {
//   const MapViewPage({super.key});

//   @override
//   _MapViewPageState createState() => _MapViewPageState();
// }

// class _MapViewPageState extends State<MapViewPage> {
//   BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;
//   List<LatLng> polyLineCoordinates = [];
//   LocationData? currentLocation;
//   final Completer<GoogleMapController> _controller = Completer();
//   TrackingCoordinatesResponseModelItem? _trackingCoordinate;
//   late ValueNotifier<TrackingCoordinatesResponseModelItem?>
//       _trackingCoordinateNotifier;
//   Dio dio = Dio();
//   String? _duration;
//   String google_api_key = Platform.isIOS
//       ? 'AIzaSyAeliVFiosa6wUWV4F_tbF2LcPf2FiFFi4'
//       : 'AIzaSyAxE2RP4vyKyE4RnFc6L4TI3wJpXIfauNw';

//   @override
//   void initState() {
//     super.initState();
//     _trackingCoordinateNotifier = ValueNotifier(null);
//     _initializeMap();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_trackingCoordinate == null && currentLocation == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Map View'),
//           leading: IconButton(
//             icon: Icon(
//               Icons.cancel_outlined,
//               color: Theme.of(context).colorScheme.primary,
//               size: 24,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         body: const Center(
//           child: LoadingProgress(),
//         ),
//       );
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Map View'),
//         leading: IconButton(
//           icon: Icon(
//             Icons.cancel_outlined,
//             color: Theme.of(context).colorScheme.primary,
//             size: 24,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: ValueListenableBuilder<TrackingCoordinatesResponseModelItem?>(
//         valueListenable: _trackingCoordinateNotifier,
//         builder: (context, value, child) {
//           if (currentLocation == null) {
//             return const Center(
//               child: LoadingProgress(),
//             );
//           } else {
//             return Stack(
//               children: [
//                 GoogleMap(
//                   initialCameraPosition: CameraPosition(
//                       target: LatLng(currentLocation!.latitude!,
//                           currentLocation!.longitude!),
//                       zoom: 14.5),
//                   onMapCreated: (mapController) {
//                     _controller.complete(mapController);
//                   },
//                   myLocationButtonEnabled: false,
//                   mapType: MapType.normal,
//                   polylines: {
//                     Polyline(
//                         width: 5,
//                         color: context.theme.colorScheme.primaryContainer,
//                         polylineId: const PolylineId("route"),
//                         points: polyLineCoordinates)
//                   },
//                   markers: {
//                     Marker(
//                         icon: sourceIcon,
//                         markerId: const MarkerId('source'),
//                         position: LatLng(currentLocation!.latitude!,
//                             currentLocation!.longitude!)),
//                     Marker(
//                         infoWindow: const InfoWindow(
//                             title: 'ajsdjasd', snippet: 'destination'),
//                         icon: destinationIcon,
//                         markerId: const MarkerId('destination'),
//                         position: LatLng(_trackingCoordinate!.latitude!,
//                             _trackingCoordinate!.longitude!)),
//                     Marker(
//                         icon: currentIcon,
//                         markerId: const MarkerId('currentLocation'),
//                         position: LatLng(currentLocation!.latitude!,
//                             currentLocation!.longitude!))
//                   },
//                 ),
//                 const MapButtons()
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }

//   void _initializeMap() async {
//     _trackingCoordinate =
//         await ProductStateItems.hiveStorageManager.getTrackingCoordinateModel();
//     _trackingCoordinateNotifier.value = _trackingCoordinate;
//     if (context.read<HomeBloc>().state.selectedTrackingCoordinate != null) {
//       LatLng selectedCoordinate = LatLng(
//         context.read<HomeBloc>().state.selectedTrackingCoordinate!.latitude ??
//             0.0,
//         context.read<HomeBloc>().state.selectedTrackingCoordinate!.longitude ??
//             0.0,
//       );
//     } else if (_trackingCoordinate != null) {
//       LatLng trackingCoordinate = LatLng(
//         _trackingCoordinate!.latitude ?? 0.0,
//         _trackingCoordinate!.longitude ?? 0.0,
//       );
//     }
//     getCurrentLocation();
//     setCustomMarker();
//     getPolyPoints();
//     fetchTravelTime();
//   }

//   void getPolyPoints() async {
//     PolylinePoints polylinePoints = PolylinePoints();

//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         googleApiKey: google_api_key,
//         request: PolylineRequest(
//             origin: PointLatLng(
//                 currentLocation!.latitude!, currentLocation!.longitude!),
//             destination: PointLatLng(_trackingCoordinate!.latitude!,
//                 _trackingCoordinate!.longitude!),
//             mode: TravelMode.driving));
// //PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!),

//     if (result.points.isNotEmpty) {
//       for (var point in result.points) {
//         polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
//       }
//       setState(() {});
//     }
//   }

//   void getCurrentLocation() async {
//     Location location = Location();

//     location.getLocation().then((location) {
//       currentLocation = location;
//     });

//     GoogleMapController googleMapController = await _controller.future;

//     location.onLocationChanged.listen((newLoc) {
//       currentLocation = newLoc;
//       setState(() {});
//     });
//   }

//   Future<void> fetchTravelTime() async {
//     try {
//       String baseUrl =
//           "https://maps.googleapis.com/maps/api/distancematrix/json";
//       String parameters =
//           "units=imperial&origins=${11.0},${22.0}&destinations=${_trackingCoordinate!.latitude},${_trackingCoordinate!.longitude}&key=$google_api_key";
//       Response response = await dio.get("$baseUrl?$parameters");
//       setState(() {
//         _duration = response.data['rows'][0]['elements'][0]['duration']['text'];
//       });
//     } catch (e, s) {
//       await SentryErrorHandler.instance.capture(e, stackTrace: s);
//     }
//   }

//   void setCustomMarker() {
//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration.empty, 'assets/images/origin.png')
//         .then((icon) {
//       sourceIcon = icon;
//     });
//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration.empty, 'assets/images/destination.png')
//         .then((icon) {
//       destinationIcon = icon;
//     });
//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration.empty, 'assets/images/current_location.png')
//         .then((icon) {
//       currentIcon = icon;
//     });
//   }
// }

// class MapButtons extends StatelessWidget {
//   const MapButtons({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//         top: context.dynamicHeight(0.05),
//         right: 0,
//         child: Padding(
//           padding: context.paddingRightLow,
//           child: Column(
//             children: [
//               CircleAvatar(
//                   radius: 24,
//                   backgroundColor: Colors.white,
//                   child: IconButton(
//                       onPressed: () {},
//                       icon: const Icon(
//                         size: 28,
//                         Icons.location_searching_outlined,
//                         color: Colors.black,
//                       ))),
//               const VerticalSpace.xSmall(),
//               CircleAvatar(
//                   radius: 24,
//                   backgroundColor: Colors.white,
//                   child: IconButton(
//                       onPressed: () {},
//                       icon: const Icon(
//                         size: 28,
//                         Icons.car_repair,
//                         color: Colors.black,
//                       ))),
//               const VerticalSpace.xSmall(),
//               CircleAvatar(
//                   radius: 24,
//                   backgroundColor: Colors.white,
//                   child: IconButton(
//                       onPressed: () {},
//                       icon: const Icon(
//                         size: 28,
//                         Icons.location_on,
//                         color: Colors.black,
//                       ))),
//             ],
//           ),
//         ));
//   }
// }
