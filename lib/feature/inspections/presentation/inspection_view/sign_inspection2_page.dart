import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ferrisfwt/feature/home/presentation/sub_view/view_expense_detail.dart';
import 'package:ferrisfwt/feature/inspections/presentation/bloc/inspections_bloc.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_customer_sign_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_inspector_sign_post_model.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_horizontal_spacer.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';

class SignInspection2Page extends StatefulWidget {
  final int inspectionId;
  const SignInspection2Page({super.key, required this.inspectionId});

  @override
  State<SignInspection2Page> createState() => _SignInspection2PageState();
}

class _SignInspection2PageState extends State<SignInspection2Page> with WidgetsBindingObserver {
  final TextEditingController _inspectorNameController = TextEditingController();
  Position? position;

  Uint8List? exportedImage;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    exportPenColor: Colors.black,
  );

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _inspectorNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    getCurrentLocation();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getCurrentLocation();
    }
  }

  Future<void> checkPermission(Permission permission, BuildContext context) async {
    final PermissionStatus status = await permission.request();
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
              'To use this feature, please enable location permissions in settings.',
            ),
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

  Future<void> getCurrentLocation() async {
    try {
      bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        BotToast.showText(text: 'Please enable location services');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          BotToast.showText(text: 'Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        checkPermission(Permission.location, context);
        BotToast.showText(
          text: 'Location permissions are permanently denied, we cannot request permissions.',
        );
        return;
      }

      final result = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      setState(() {
        position = result;
      });
    } catch (e) {
      BotToast.showText(text: 'An error occurred while getting location: $e');
    }
  }

  void _onStateChanged(BuildContext context, InspectionsState state) async {
    if (state.status == ViewStatus.success && state.isSigned) {
      context.go("/inspection_page", extra: {
        "isAsync": false,
        "isSigned": true,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InspectionsBloc, InspectionsState>(
      listener: _onStateChanged,
      builder: (context, state) {
        if (position == null || state.status == ViewStatus.loading) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Inspector Signature',
                style: context.textTheme.titleSmall,
              ),
              backgroundColor: context.theme.colorScheme.surface,
            ),
            body: const Center(
              child: LoadingProgress(),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: context.theme.colorScheme.primary,
                size: 24,
              ),
              onPressed: () {
                context.pop();
              },
            ),
            backgroundColor: context.theme.colorScheme.surface,
            title: Text(
              'Inspector Signature',
              style: context.textTheme.titleSmall,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: context.paddingAllLow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: context.theme.colorScheme.surfaceContainerHighest,
                      ),
                      child: Padding(
                        padding: context.paddingAllLow,
                        child: CustomJobTextfield(
                          text: "Inspector Full Name",
                          hintText: "Enter the name",
                          controller: _inspectorNameController,
                        ),
                      ),
                    ),
                  ),
                  const VerticalSpace.xSmall(),
                  Card(
                    elevation: 8,
                    child: Container(
                      width: context.width,
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: context.paddingAllLow,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Location',
                                style: context.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Divider(color: Colors.white),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Address: ',
                                    style: context.textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: state.address == "" ? 'Find Adress' : state.address,
                                    style: context.textTheme.bodyLarge?.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(color: Colors.white, thickness: 0.3),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'latitude: ',
                                    style: context.textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${state.lat == "" ? position?.latitude : state.lat} ',
                                    style: context.textTheme.bodyLarge?.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(color: Colors.white, thickness: 0.3),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'longitude: ',
                                    style: context.textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${state.long == "" ? position?.longitude : state.long} ',
                                    style: context.textTheme.bodyLarge?.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(color: Colors.white, thickness: 0.3),
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text(
                                    'Location is fetched from GPS',
                                    style: context.textTheme.bodyMedium?.copyWith(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  SizedBox(
                                    width: context.width / 2.3,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 10,
                                        minimumSize: Size(
                                          context.dynamicWidth(0.05),
                                          context.dynamicHeight(0.045),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(color: Colors.black),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () async {
                                        context.push('/sign_map_view_page');
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(Icons.location_on),
                                          HorizontalSpace.xxSmall(),
                                          Text('Find Address'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.dynamicHeight(0.02)),
                  Text(
                    'Sign',
                    style: context.textTheme.titleMedium,
                  ),
                  const Divider(color: Colors.black, thickness: 0.5),
                  SizedBox(height: context.dynamicHeight(0.005)),
                  Card(
                    elevation: 8,
                    child: Container(
                      height: 195,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: context.theme.colorScheme.primaryContainer),
                      ),
                      child: Signature(
                        key: const Key('signature'),
                        controller: _controller,
                        height: 180,
                        width: context.width - 30,
                        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
                      ),
                    ),
                  ),
                  const VerticalSpace.small(),
                  Padding(
                    padding: context.paddingBottomDefault,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomAppButton(
                          text: 'Clear Signature',
                          ontap: () {
                            _controller.clear();
                            setState(() {});
                          },
                        ),
                        SizedBox(height: context.dynamicHeight(0.01)),
                        CustomAppButton(
                          text: 'Save',
                          ontap: () async {
                            if (position == null) {
                              BotToast.showText(text: 'Please enable location permission');
                              return;
                            }
                            if (_inspectorNameController.text.isEmpty) {
                              BotToast.showText(text: 'Please enter the inspector name');
                              return;
                            }
                            final signature = await _controller.toPngBytes();
                            setState(() {
                              exportedImage = signature;
                            });

                            if (exportedImage == null) {
                              BotToast.showText(text: 'Please sign the signature');
                              return;
                            }

                            final Uint8List? image = await _controller.toPngBytes();

                            final dir = await getApplicationDocumentsDirectory();

                            final file = File('${dir.path}/${Random().nextInt(10000)}.png');
                            if (image == null) {
                              BotToast.showText(text: 'Please sign the signature');
                              return;
                            }

                            await file.writeAsBytes(image);

                            final now = DateTime.now();
                            context.read<InspectionsBloc>().add(
                                  PostJobInspectionsCustomerSign(
                                    jobInspectionId: widget.inspectionId,
                                    data: InspectionCustomerSignPostModel(
                                      customerSignerName: state.imageCustamerName ?? '',
                                      customerSignatureImg: state.imageCustamerFile ?? File(''),
                                      customerSignLatitude: position!.latitude.toString(),
                                      customerSignLongitude: position!.longitude.toString(),
                                      date: DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
                                    ),
                                    isAsync: false,
                                    signData: InspectionInspectorSignPostModel(
                                      inspectorSignLatitude: position!.latitude.toString(),
                                      inspectorSignLongitude: position!.longitude.toString(),
                                      inspectorSignerName: _inspectorNameController.text,
                                      inspectorSignatureImg: file,
                                      date: DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
                                    ),
                                  ),
                                );
                            // print("state.isPostedCustomerSign: ${state.isPostedCustomerSign}");
                            // if (state.isPostedCustomerSign) {
                            //   context.read<InspectionsBloc>().add(
                            //         PostInspectionSign(
                            //           jobInspectionId: widget.inspectionId,
                            //           data: InspectionInspectorSignPostModel(
                            //             inspectorSignLatitude: position!.latitude.toString(),
                            //             inspectorSignLongitude: position!.longitude.toString(),
                            //             inspectorSignerName: _inspectorNameController.text,
                            //             inspectorSignatureImg: file,
                            //             date: DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
                            //           ),
                            //           isAsync: false,
                            //         ),
                            //       );
                            // }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SignMapView extends StatefulWidget {
  const SignMapView({super.key});

  @override
  State<SignMapView> createState() => _SignMapViewState();
}

class _SignMapViewState extends State<SignMapView> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  late LatLng _defaultLatLang;
  late LatLng _draggedLatlang;
  late String _draggedAddress;

  @override
  void initState() {
    _init();
    super.initState();
    _gotoUserCurrentPosition(); // Anlık konumu almak için çağrıldı
  }

  _init() {
    _defaultLatLang = const LatLng(11, 104);
    _draggedLatlang = _defaultLatLang;
    _draggedAddress = 'Your address was not found (check your internet and try again)';
    _cameraPosition = CameraPosition(target: _defaultLatLang, zoom: 17.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(90)),
        backgroundColor: context.theme.colorScheme.surface,
        onPressed: () {
          _gotoUserCurrentPosition();
        },
        child: Icon(
          size: 30,
          Icons.location_on,
          color: context.theme.colorScheme.primaryContainer,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [_getMap(), _getCustomPin(), _showDraggedLatlang()],
    );
  }

  Widget _showDraggedLatlang() {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.onSurfaceVariant,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            offset: const Offset(0, 2),
            spreadRadius: 5,
            blurRadius: 5,
          ),
        ],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
      width: context.width,
      height: 120,
      child: Padding(
        padding: context.paddingAllLow,
        child: Center(
          child: Padding(
            padding: context.paddingTopHigh,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    textAlign: TextAlign.center,
                    _draggedAddress,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.theme.colorScheme.primaryContainer,
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getMap() {
    return GoogleMap(
      myLocationButtonEnabled: false,
      initialCameraPosition: _cameraPosition!,
      mapType: MapType.normal,
      onCameraIdle: () {
        _updateCameraPosition(_cameraPosition!);
      },
      onCameraMove: (cameraPosition) {
        _draggedLatlang = cameraPosition.target;
        context.read<InspectionsBloc>().add(SetLatLong(
              _draggedLatlang.latitude.toString(),
              _draggedLatlang.longitude.toString(),
            ));
        _cameraPosition = cameraPosition;
      },
      onMapCreated: (GoogleMapController controller) {
        if (!_googleMapController.isCompleted) {
          _googleMapController.complete(controller);
        }
      },
    );
  }

  Timer? _debounce;

  void _updateCameraPosition(CameraPosition position) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        getAddress(position.target);
      }
    });
  }

  Future<void> getAddress(LatLng position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark address = placemarks[0];
    String addressStr = "${address.street}, ${address.locality}, ${address.administrativeArea}, ${address.country}";
    setState(() {
      _draggedAddress = addressStr;
      context.read<InspectionsBloc>().add(SetAddress(_draggedAddress));
    });
  }

  Widget _getCustomPin() {
    return Center(
      child: SizedBox(
        width: 40,
        child: Lottie.asset('assets/lottie/fr_pin2.json'),
      ),
    );
  }

  Future _gotoUserCurrentPosition() async {
    Position currentPosition = await _determineUserCurrentPosition();
    LatLng userPosition = LatLng(currentPosition.latitude, currentPosition.longitude);
    _gotoSpecificPosition(userPosition);
    if (mounted) {
      getAddress(userPosition);
    } // Anlık konum için adres güncellemesi
  }

  Future _gotoSpecificPosition(LatLng position) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: position, zoom: 17.5),
    ));
    if (mounted) {
      await getAddress(position);
    }
  }

  Future<Position> _determineUserCurrentPosition() async {
    LocationPermission locationPermission;
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {}

    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {}
    }

    if (locationPermission == LocationPermission.deniedForever) {}

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }
}
