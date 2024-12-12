import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:camera/camera.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/edit_details_page.dart';
import 'package:ferrisfwt/feature/profile/presantation/cubit/permissions_cubit.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/button/add_file_button.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/popup/question_popup.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_horizontal_spacer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart' as path;
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/stop_job/stop_job_bloc.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/stops/stop_post_model.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/button/custom_grey_app_button.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../product/utility/error_handler/sentry_error_handler.dart';

class AddStop extends StatefulWidget {
  const AddStop({Key? key}) : super(key: key);

  @override
  State<AddStop> createState() => _AddStopState();
}

class _AddStopState extends State<AddStop> {
  String? _selectedLevelAtHub;
  List<File> _evidences = [];
  final TextEditingController _reasonController = TextEditingController();
  int limit = 12;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> compressImage(File image) async {
    final documentPath = (await getApplicationDocumentsDirectory()).path;
    final newFile = await image.copy('$documentPath/${path.basename(image.path)}');
    File compressedImage = await _resizeImage(newFile);
    setState(() {
      _evidences.add(compressedImage);
    });
  }

  Future<void> _getImages(ImageSource source, StopJobState state) async {
    final picker = ImagePicker();

    if (source == ImageSource.camera) {
      // PermissionStatus permissionStatus = await Permission.camera.status;
      // if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
      //   final result = await showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: const Text('Camera Permission'),
      //         content: const Text(
      //             'This app needs camera access to take pictures. Please allow camera access in settings.'),
      //         actions: [
      //           TextButton(
      //             onPressed: () {
      //               Navigator.of(context).pop(false);
      //             },
      //             child: const Text('Cancel'),
      //           ),
      //           TextButton(
      //             onPressed: () async {
      //               context.read<CubitPermissions>().requestCamera();
      //               final permissionStatus = await Permission.camera.status;
      //               if (permissionStatus.isDenied ||
      //                   permissionStatus.isPermanentlyDenied) {
      //                 await openAppSettings();
      //               }
      //               context.pop();
      //             },
      //             child: const Text('Open Settings'),
      //           ),
      //         ],
      //       );
      //     },
      //   );

      //   if (result == true) {
      //     await openAppSettings();
      //     permissionStatus = await Permission.camera.status;
      //   } else {
      //     return;
      //   }
      // }

      // if (permissionStatus.isGranted) {
      //   final result = await Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => CameraPage(
      //         evidences: _evidences,
      //         limit: limit,
      //         onCapture: (File image) async {
      //           if (_evidences.length < 12) {
      //             await compressImage(image);
      //           } else {
      //             BotToast.showText(
      //                 text: 'You can only select 12 images in total');
      //           }
      //         },
      //       ),
      //     ),
      //   );

      //   if (result != null && result is List<File>) {
      //     setState(() {
      //       _evidences = result;
      //     });
      //   }
      // } else {
      //   BotToast.showText(text: 'Camera access denied');
      // }
      PermissionStatus permissionStatus = await Permission.camera.status;
      if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
        final result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Camera Permission'),
              content:
                  const Text('This app needs camera access to take pictures. Please allow camera access in settings.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    context.read<CubitPermissions>().requestCamera();
                    final permissionStatus = await Permission.camera.status;
                    if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
                      await openAppSettings();
                    }
                    context.pop();
                  },
                  child: const Text('Open Settings'),
                ),
              ],
            );
          },
        );

        if (result == true) {
          await openAppSettings();
          permissionStatus = await Permission.camera.status;
        } else {
          return;
        }
      }

      if (permissionStatus.isGranted) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraPage(
              evidences: _evidences,
              limit: 1, // Sadece bir resim çekmek için limit 1 olmalı
              onCapture: (File image) async {
                if (_evidences.isEmpty) {
                  await compressImage(image);
                  // setState(() {
                  //   _evidences.add(image);
                  // });
                  // Resim çekildikten sonra işlemleri başlat
                  await handleImageSelectionAndSubmit(context, state);
                  context.pop();
                } else {
                  BotToast.showText(text: 'You can only select 1 images in total');
                }
              },
            ),
          ),
        );

        if (result != null && result is List<File>) {
          setState(() {
            _evidences = result;
          });
        }
      } else {
        BotToast.showText(text: 'Camera access denied');
      }
    } else {
      final pickedImage = await picker.pickImage(imageQuality: 90, source: source);

      if (pickedImage != null) {
        if (_evidences.isNotEmpty) {
          BotToast.showText(text: 'You can only select 1 images in total');
          return;
        }

        File file = File(pickedImage.path);

        final documentPath = (await getApplicationDocumentsDirectory()).path;
        final newFile = await file.copy('$documentPath/${path.basename(file.path)}');
        File compressedImage = await _resizeImage(newFile);

        setState(() {
          _evidences.add(compressedImage);
        });

        await handleImageSelectionAndSubmit(context, state);
      } else {
        BotToast.showText(text: 'No image selected');
      }
    }
  }

  Future<void> handleImageSelectionAndSubmit(BuildContext context, StopJobState state) async {
    if (_evidences.isEmpty) {
      BotToast.showText(text: "Please upload image of locked vehicle");
      context.read<StopJobBloc>().add(const PostJobStopsControl());
      return;
    }
    if (_selectedLevelAtHub == null) {
      BotToast.showText(text: "Please enter the reason for stop category");
      context.read<StopJobBloc>().add(const PostJobStopsControl());
      return;
    }

    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      position = null;
      await _showLocationPermissionDialog(context);
    }

    if (position != null) {
      // BotToast.showLoading();
      context.read<StopJobBloc>().add(PostJobStops(
          isAsync: false,
          jobId: context.read<HomeBloc>().state.showJob!.id,
          data: StopPostModel(
            categoryId: state.getStopCategoriesResponse.firstWhere((element) => element.name == _selectedLevelAtHub).id,
            // reason: _reasonController.text,
            jobId: context.read<HomeBloc>().state.showJob!.id,
            latitude: position.latitude,
            longitude: position.longitude,
            evidences: _evidences.map((file) => file).toList(),
          )));
      // BotToast.closeAllLoading();
    } else {
      BotToast.showText(text: "Failed to get location");
    }
  }

  Future<File> _resizeImage(File imageFile) async {
    Uint8List? imageBytes = await FlutterImageCompress.compressWithFile(
      imageFile.path,
      minWidth: 800,
      minHeight: 600,
      quality: 90,
    );

    if (imageBytes == null) {
      throw Exception("Compression failed");
    }

    String fName = path.basenameWithoutExtension(imageFile.path);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String compressedImagePath = '$appDocPath/$fName.jpg';
    await File(compressedImagePath).writeAsBytes(imageBytes);
    return File(compressedImagePath);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StopJobBloc, StopJobState>(
      listener: (context, state) {
        if (state.status == ViewStatus.success && state.isError == false) {
          showTopSnackBarFr(context, message: 'Stop added successfully');
          context.pop();
        }
        if (state.status == ViewStatus.failure) {
          BotToast.showText(text: "Please enter the reason for stop category");
        }
      },
      builder: (context, state) {
        if (state.status == ViewStatus.loading) {
          _selectedLevelAtHub = null;

          _evidences.clear();
          _reasonController.clear();
          return Scaffold(
            body: Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: context.theme.colorScheme.outlineVariant,
                child: const LoadingProgress(),
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: context.theme.colorScheme.surface,
            leading: IconButton(
              icon: Icon(
                Icons.cancel_outlined,
                color: context.theme.colorScheme.primary,
                size: 24,
              ),
              onPressed: () {
                context.pop();
              },
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: context.paddingHorizontalDefault,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VerticalSpace.standard(),
                    Row(
                      children: [
                        Text(
                          'Add Stop',
                          style: context.textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    const VerticalSpace.small(),
                    DropdownButtonWidget(
                      value: _selectedLevelAtHub,
                      hintText: "Choose the reason for stop",
                      items: state.getStopCategoriesResponse
                          .map((e) => DropdownMenuItem(
                                value: e.name,
                                child: Text(e.name),
                              ))
                          .toList(),
                      text: "Reason for stop category",
                      onChanged: (String) {
                        setState(() {
                          _selectedLevelAtHub = String;
                        });
                      },
                      textSpanEnable: true,
                    ),
                    const VerticalSpace.small(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Upload Evidence",
                          style: context.textTheme.bodyLarge
                              ?.copyWith(color: context.theme.colorScheme.primary, fontWeight: FontWeight.w600),
                        ),
                        const VerticalSpace.small(),
                        InkWell(
                          child: const AddFileButton(fileCount: 1),
                          onTap: () {
                            _showImagePickerDialog(context, state);
                          },
                        ),
                      ],
                    ),
                    if (_evidences.isNotEmpty)
                      SizedBox(
                        height: context.dynamicHeight(0.17),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const HorizontalSpace.xSmall(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: _evidences.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: context.paddingVerticalLow,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          height: context.dynamicHeight(0.15),
                                          width: context.dynamicWidth(0.30),
                                          decoration: BoxDecoration(
                                            color: context.theme.colorScheme.primaryContainer,
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: FileImage(_evidences[index]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.cancel_outlined,
                                            color: context.theme.colorScheme.error,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _evidences.removeAt(index);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    const VerticalSpace.small(),
                    if (state.isError)
                      CustomAppButton(
                        text: "Save",
                        ontap: () async {
                          // if (_reasonController.text.isEmpty) {
                          //   BotToast.showText(
                          //       text: "Please enter the reason for stop");
                          //   return;
                          // }
                          if (_evidences.isEmpty) {
                            BotToast.showText(text: "Please upload image of locked vehicle");
                            return;
                          }
                          if (_selectedLevelAtHub == null) {
                            BotToast.showText(text: "Please enter the reason for stop category");
                            return;
                          }
                          Position? position;
                          try {
                            position = await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high,
                            );
                          } catch (e, s) {
                            await SentryErrorHandler.instance.capture(e, stackTrace: s);
                            position = null;
                            await _showLocationPermissionDialog(context);
                          }
                          if (position != null) {
                            BotToast.showLoading();
                            context.read<StopJobBloc>().add(PostJobStops(
                                isAsync: false,
                                jobId: context.read<HomeBloc>().state.showJob!.id,
                                data: StopPostModel(
                                  categoryId: state.getStopCategoriesResponse
                                      .firstWhere((element) => element.name == _selectedLevelAtHub)
                                      .id,
                                  // reason: _reasonController.text,
                                  jobId: context.read<HomeBloc>().state.showJob!.id,
                                  latitude: position.latitude,
                                  longitude: position.longitude,
                                  evidences: _evidences.map((file) => file).toList(),
                                )));
                            BotToast.closeAllLoading();
                          } else {
                            BotToast.showText(text: "Failed to get location");
                          }
                        },
                      ),
                    const VerticalSpace.small(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showImagePickerDialog(BuildContext context, StopJobState state) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: context.theme.colorScheme.onSurfaceVariant,
            ),
            width: context.dynamicWidth(0.98),
            height: context.dynamicHeight(0.38),
            child: Padding(
              padding: context.paddingAllDefault,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Select an image picker method',
                    style: context.textTheme.headlineMedium
                        ?.copyWith(color: context.theme.colorScheme.primary, fontSize: 20),
                  ),
                  Column(
                    children: [
                      CustomGreyAppButton(
                          textColor: context.theme.colorScheme.primary,
                          text: "Open Camera",
                          containerColor: context.theme.colorScheme.onSurfaceVariant,
                          ontap: () {
                            if (_evidences.isNotEmpty) {
                              BotToast.showText(text: 'You can only select 1 images in total');
                              context.pop();
                            } else {
                              Navigator.of(context).pop();

                              _getImages(ImageSource.camera, state);
                            }
                          }),
                      const VerticalSpace.xxSmall(),
                      CustomGreyAppButton(
                          textColor: context.theme.colorScheme.primary,
                          text: "Pick From Gallery",
                          containerColor: context.theme.colorScheme.onSurfaceVariant,
                          ontap: () {
                            Navigator.of(context).pop();

                            _getImages(ImageSource.gallery, state);
                          }),
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text(
                        'Cancel',
                        style: context.textTheme.bodyLarge?.copyWith(color: Colors.red),
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showLocationPermissionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission'),
          content: const Text(
              'This app needs location access to get your current position. Please allow location access in settings.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await openAppSettings();
                Navigator.of(context).pop();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }
}

class CustomJobTextfield extends StatelessWidget {
  final String text;
  final String hintText;
  final Function(String)? onChanged;
  final IconButton? suffixIcon;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(dynamic value)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final double? height;
  final bool? expands;
  final List<TextInputFormatter>? inputFormatters;

  CustomJobTextfield({
    this.keyboardType,
    this.textInputAction,
    super.key,
    this.onChanged,
    this.suffixIcon,
    this.obscureText = false,
    required this.text,
    required this.hintText,
    required this.controller,
    this.validator,
    this.height,
    this.inputFormatters,
    this.expands,
  }) {
    controller.addListener(_upperTextFirst);
  }

  void _upperTextFirst() {
    String text = controller.text;
    if (text.isNotEmpty && text[0] != text[0].toUpperCase()) {
      controller.value = controller.value.copyWith(
        text: text[0].toUpperCase() + text.substring(1),
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  text,
                  style: TextStyle(fontSize: 14, color: context.theme.colorScheme.primary),
                ),
                const Text("*",
                    style: TextStyle(
                      color: Color(0xFFDA0002),
                    ))
              ],
            ),
            SizedBox(height: context.dynamicHeight(0.01)),
            SizedBox(
              height: height ?? context.dynamicHeight(0.08),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                inputFormatters: inputFormatters,
                textInputAction: textInputAction,
                textAlignVertical: TextAlignVertical.top,
                textAlign: TextAlign.left,
                maxLines: null,
                expands: expands ?? false,
                keyboardType: keyboardType,
                controller: controller,
                onChanged: onChanged,
                obscureText: obscureText,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: context.theme.colorScheme.onSurfaceVariant,
                  hintText: hintText,
                  isDense: true,
                  suffixIcon: suffixIcon,
                  hintStyle: context.textTheme.bodyLarge?.copyWith(
                    color: context.theme.colorScheme.onPrimary,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: context.theme.colorScheme.onPrimary,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: context.theme.colorScheme.outline,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: context.theme.colorScheme.outline,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CameraPage extends StatefulWidget {
  final Function(File) onCapture;
  final int limit;
  List<File> evidences = [];

  CameraPage({Key? key, required this.onCapture, required this.limit, required this.evidences}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  final List<File> _capturedImages = [];

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController.initialize();
  }

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = initializeCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    try {
      await _initializeControllerFuture;
      final XFile image = await _cameraController.takePicture();
      final File file = File(image.path);
      setState(() {
        _capturedImages.add(file);
      });
      widget.onCapture(file); // Fotoğrafı onCapture ile gönder
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      BotToast.showText(
          text:
              "The camera hasn't finished saving the previous picture yet. Please wait for the current process to complete before taking another photo.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, [_capturedImages + widget.evidences]);
          },
        ),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                SizedBox(
                  height: context.height,
                  child: CameraPreview(_cameraController),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _capturedImages.isNotEmpty ? null : _captureImage,
                        child: const CircleAvatar(
                          radius: 30,
                          child: Icon(
                            Icons.camera_alt,
                            size: 30,
                          ),
                        ),
                      ),
                      // const VerticalSpace.xSmall(),
                      // if (_capturedImages.isNotEmpty)
                      //   Container(
                      //     decoration: BoxDecoration(
                      //       color: context.theme.colorScheme.primaryContainer
                      //           .withOpacity(0.2),
                      //       borderRadius: const BorderRadius.vertical(
                      //         top: Radius.circular(10),
                      //       ),
                      //     ),
                      //     width: context.width,
                      //     height: 140,
                      //     child: Padding(
                      //       padding: EdgeInsets.symmetric(
                      //         horizontal: context.dynamicWidth(0.05),
                      //         vertical: context.dynamicHeight(0.02),
                      //       ),
                      //       child: ListView.builder(
                      //         scrollDirection: Axis.horizontal,
                      //         itemCount: _capturedImages.length,
                      //         itemBuilder: (context, index) {
                      //           return Padding(
                      //             padding: EdgeInsets.symmetric(
                      //                 horizontal: context.dynamicWidth(0.020)),
                      //             child: Stack(
                      //               children: [
                      //                 ClipRRect(
                      //                   borderRadius: BorderRadius.circular(10),
                      //                   child: Image.file(
                      //                     _capturedImages[index],
                      //                   ),
                      //                 ),
                      //                 Positioned(
                      //                   top: -12,
                      //                   right: -10,
                      //                   child: IconButton(
                      //                     onPressed: () {
                      //                       setState(() {
                      //                         _capturedImages.removeAt(index);
                      //                       });
                      //                     },
                      //                     icon: const Icon(
                      //                       Icons.cancel_outlined,
                      //                       color: Colors.red,
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           );
                      //         },
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
