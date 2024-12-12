// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:exif/exif.dart';
import 'package:ferrisfwt/feature/inspections/data/models/condition_image/condition_image_response_model.dart';
import 'package:ferrisfwt/feature/inspections/presentation/bloc/inspections_bloc.dart';
import 'package:ferrisfwt/feature/profile/presantation/cubit/permissions_cubit.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/mixin/network_mixin.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/condition_image/inspection_condition_image_post_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/button/add_file_button.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/button/custom_grey_app_button.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/popup/question_popup.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_horizontal_spacer.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import 'package:sensors_plus/sensors_plus.dart';

import '../../../../product/utility/error_handler/sentry_error_handler.dart';

class ConditionImagePage extends StatefulWidget {
  final int jobInspectionId;
  const ConditionImagePage({super.key, required this.jobInspectionId});

  @override
  State<ConditionImagePage> createState() => _ConditionImagePageState();
}

class _ConditionImagePageState extends State<ConditionImagePage> {
  HiveStorageManager? _hiveStorageManager;
  List<File> _imageFiles = [];
  final List<ConditionImageResponseModel> _deletedImages = [];
  static const int maxImages = 75;
  String? filePath;
  bool _isLoading = false;

  Future<void> compressImage(File image) async {
    await getImageDimensions(image);
    final documentPath = (await getApplicationDocumentsDirectory()).path;
    final newFile = await image.copy('$documentPath/${path.basename(image.path)}');

    File compressedImage = await _resizeImage(newFile);

    setState(() {
      _imageFiles.add(compressedImage);
    });
  }

  Future<void> getImageDimensions(File imageFile) async {
    // Resmin baytlarını oku
    final bytes = await imageFile.readAsBytes();

    // Görüntüyü decode et
    img.Image? decodedImage = img.decodeImage(bytes);

    if (decodedImage != null) {
      // Genişlik ve yükseklik değerlerini al
      final width = decodedImage.width;
      final height = decodedImage.height;

      print("Width: $width, Height: $height");
    } else {
      print("Görüntü decode edilemedi.");
    }
  }

  Future<File> _rotateImage(File image) async {
    // Load the image file
    final bytes = await image.readAsBytes();
    final originalImage = img.decodeImage(bytes)!;

    final Map<String, IfdTag> data = await readExifFromBytes(bytes);
    final orientation = data['Image Orientation']?.values.firstAsInt();

    // Determine rotation based on EXIF orientation
    img.Image rotatedImage = originalImage;
    switch (orientation) {
      case 1:
        // Normal
        break;
      case 3:
        // Rotate 180 degrees
        rotatedImage = img.copyRotate(originalImage, angle: 180);
        break;
      case 6:
        // Rotate 90 degrees clockwise
        rotatedImage = img.copyRotate(originalImage, angle: 90);
        break;
      case 8:
        // Rotate 90 degrees counterclockwise
        rotatedImage = img.copyRotate(originalImage, angle: 270);
        break;
      default:
        // If not defined, keep the original
        break;
    }

    // Create a new file to save the rotated image
    final documentPath = (await getApplicationDocumentsDirectory()).path;
    final newFilePath = '$documentPath/rotated_${path.basename(image.path)}';

    // Save the rotated image
    final File newFile = File(newFilePath)..writeAsBytesSync(img.encodeJpg(rotatedImage));

    return newFile;
  }

  Future<void> _getImageFromCamera(InspectionsState state) async {
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

      if (result != true) {
        return;
      }
    }

    try {
      final currentUploadedImages = _imageFiles.length + state.conditionImageResponse.length - _deletedImages.length;
      final remainingImages = maxImages - currentUploadedImages;

      // // Kamera kullanımında cihazı yatay moda zorla
      // await SystemChrome.setPreferredOrientations([
      //   DeviceOrientation.landscapeLeft,
      //   DeviceOrientation.landscapeRight,
      // ]);

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPageCondition(
            limit: remainingImages,
            onCapture: (File image) async {
              if (_imageFiles.length < 75) {
                File rotatedImage = await _rotateImage(image);
                await compressImage(rotatedImage);
              } else {
                BotToast.showText(text: 'You can only select 75 images in total');
              }
            },
            capturedImages: _imageFiles,
          ),
        ),
      );
      // final ImagePicker picker = ImagePicker();
      // final XFile? image = await picker.pickImage(source: ImageSource.camera);

      // setState(() {
      //   _imageFiles.add(File(image!.path));
      // });

      if (result != null && result is List<File>) {
        setState(() {
          _imageFiles = result;
        });
      }

      // // Kamera kullanımı sonrasında cihaz yönünü eski haline döndür
      // await SystemChrome.setPreferredOrientations([
      //   DeviceOrientation.portraitUp,
      //   DeviceOrientation.portraitDown,
      // ]);

      permissionStatus = await Permission.camera.status;
      if (!permissionStatus.isGranted) {
        BotToast.showText(text: 'Camera access denied');
        return;
      }
      if (remainingImages <= 0) {
        BotToast.showText(text: 'You cannot add more than $maxImages images');
        return;
      }
    } catch (e, s) {
      SentryErrorHandler.instance.capture(e, stackTrace: s);
    }
  }

  Future<void> _getImagesFromGallery(InspectionsState state) async {
    final picker = ImagePicker();
    setState(() {
      _isLoading = true;
    });
    try {
      final pickedFiles = await picker.pickMultiImage();
      for (var pickedFile in pickedFiles) {
        File file = File(pickedFile.path);
        if (_imageFiles.length < 75) {
          await compressImage(file);
        } else {
          BotToast.showText(text: 'You can only select 75 images in total');
          break;
        }
      }
    } catch (e, s) {
      SentryErrorHandler.instance.capture(e, stackTrace: s);
      BotToast.showText(text: 'Failed to pick images: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildLoadingIndicator() {
    if (_isLoading) {
      return const Stack(
        children: [
          // Arka planı karartan yarı saydam Container
          Opacity(
            opacity: 0.5,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
          Center(
            child: LoadingProgress(),
          ),
        ],
      );
    } else {
      return const SizedBox(); // Boş bir alan, gösterilecek bir şey yok.
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
  void initState() {
    context.read<InspectionsBloc>().add(SetGetConditionImages(widget.jobInspectionId));
    _hiveStorageManager = ProductStateItems.hiveStorageManager;
    setFilePath();
    super.initState();
  }

  Future<void> setFilePath() async {
    final documentPath = (await getApplicationDocumentsDirectory()).path;

    setState(() {
      filePath = documentPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.cancel_outlined, color: context.theme.colorScheme.primary, size: 24),
          onPressed: () => context.pop(),
        ),
        backgroundColor: context.theme.colorScheme.surface,
        title: Text('Condition Images', style: context.textTheme.titleSmall),
      ),
      body: Stack(
        children: [
          BlocConsumer<InspectionsBloc, InspectionsState>(
            listener: (context, state) {
              if (state.status == ViewStatus.failure) {
                // BotToast.showText(text: state.failure.toString());
              }
              if (state.status == ViewStatus.success) {
                context.read<InspectionsBloc>().add(SetGetConditionImages(widget.jobInspectionId));
              }
            },
            builder: (context, state) {
              if (state.status == ViewStatus.loading || filePath == null) {
                return const Center(child: LoadingProgress());
              }
              final bool isSigned = ProductStateItems.hiveDatabaseManager.getUserModel()!.inspectionsSign != null &&
                  ProductStateItems.hiveDatabaseManager
                      .getUserModel()!
                      .inspectionsSign!
                      .contains(widget.jobInspectionId);
              return SingleChildScrollView(
                child: Padding(
                  padding: context.paddingAllDefault,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isSigned)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Add Images",
                                  style: context.textTheme.bodyLarge
                                      ?.copyWith(color: context.theme.colorScheme.primary, fontWeight: FontWeight.w600),
                                ),
                                const VerticalSpace.small(),
                                InkWell(
                                  child: const AddFileButton(fileCount: 75),
                                  onTap: () {
                                    _showImagePickerDialog(context, state);
                                  },
                                ),
                                const VerticalSpace.xSmall(),
                              ],
                            ),
                          if (_imageFiles.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "New Images",
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(color: context.theme.colorScheme.primary, fontWeight: FontWeight.w600),
                                ),
                                const VerticalSpace.xSmall(),
                                SizedBox(
                                  height: context.dynamicHeight(0.15),
                                  child: ListView.separated(
                                    padding: EdgeInsets.zero,
                                    separatorBuilder: (BuildContext context, int index) =>
                                        const HorizontalSpace.xSmall(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _imageFiles.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.file(
                                              _imageFiles[index],
                                              fit: BoxFit.cover,
                                              // height: context.dynamicHeight(0.15),
                                              // width: context.dynamicWidth(0.35),
                                            ),
                                          ),
                                          Positioned(
                                            top: -5,
                                            right: -5,
                                            child: IconButton(
                                              icon: Icon(Icons.cancel_outlined, color: context.theme.colorScheme.error),
                                              onPressed: () {
                                                setState(() {
                                                  _imageFiles.removeAt(index);
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          if (!isSigned)
                            SizedBox(
                              height: context.defaultValue,
                            ),
                          if (_hiveStorageManager!.getConditionImages(widget.jobInspectionId).isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Recently Added Images",
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(color: context.theme.colorScheme.primary, fontWeight: FontWeight.w600),
                                ),
                                const VerticalSpace.xSmall(),
                                SizedBox(
                                  height: context.dynamicHeight(0.15),
                                  child: ListView.separated(
                                    padding: EdgeInsets.zero,
                                    separatorBuilder: (BuildContext context, int index) =>
                                        const HorizontalSpace.xSmall(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _hiveStorageManager!.getConditionImages(widget.jobInspectionId).length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final pathImage = _hiveStorageManager!
                                          .getConditionImages(widget.jobInspectionId)[index]
                                          .imageFile!
                                          .path;
                                      int documentsIndex = pathImage.indexOf("Documents/");
                                      String result = pathImage.substring(documentsIndex + "Documents/".length);
                                      final path = '$filePath/$result';
                                      return Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.file(
                                              File(path),
                                              fit: BoxFit.cover,
                                              // height: context.dynamicHeight(0.15),
                                              // width: context.dynamicWidth(0.35),
                                            ),
                                          ),
                                          isSigned
                                              ? const SizedBox()
                                              : Positioned(
                                                  top: -5,
                                                  right: -5,
                                                  child: IconButton(
                                                    icon: Icon(Icons.cancel_outlined,
                                                        color: context.theme.colorScheme.error),
                                                    onPressed: () async {
                                                      var conditionImage = await _hiveStorageManager!
                                                          .getInspectionConditionImages(widget.jobInspectionId);

                                                      print("CONDIT LIST : ${conditionImage.length}");
                                                      // final deletedImage = state
                                                      //         .conditionImageResponse[
                                                      //     index];
                                                      // setState(() {
                                                      //   _deletedImages
                                                      //       .add(deletedImage);
                                                      // });

                                                      print("CONDIT ID : ${conditionImage[index].id}");

                                                      context.read<InspectionsBloc>().add(
                                                            DeleteConditionImage(conditionImage[index].id ?? 0,
                                                                widget.jobInspectionId, index, conditionImage[index]),
                                                          );
                                                    },
                                                  ),
                                                ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const VerticalSpace.large(),
                      if (!isSigned)
                        CustomAppButton(
                          text: "Save",
                          ontap: () {
                            final totalImagesCount =
                                _imageFiles.length + state.conditionImageResponse.length - _deletedImages.length;
                            if (totalImagesCount > maxImages) {
                              BotToast.showText(text: "Please select up to $maxImages images");
                              return;
                            }

                            int generateUniqueId() {
                              final timestamp = DateTime.now().millisecondsSinceEpoch;
                              final random = Random();
                              final randomNumber = random.nextInt(10000); // 0 ile 9999 arasında rastgele bir sayı
                              return int.parse('$timestamp$randomNumber'); // Benzersiz id
                            }

                            final int uniqueId = generateUniqueId();

                            print("image files : ${_imageFiles.length}");

                            context.read<InspectionsBloc>().add(PostConditionImages(
                                  isAsync: false,
                                  jobInspectionId: widget.jobInspectionId,
                                  imageFiles: _imageFiles,
                                  dataList: _imageFiles.map((imageFile) {
                                    return ConditionImageResponseModel(
                                      id: uniqueId,
                                      jobInspectionId: widget.jobInspectionId,
                                      imageFile: imageFile,
                                    );
                                  }).toList(),
                                ));
                            setState(() {
                              _deletedImages.clear();
                              _imageFiles.clear();
                            });
                            context.pop();
                            showTopSnackBarFr(context, message: 'Condition images added successfully');
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          _buildLoadingIndicator(),
        ],
      ),
    );
  }

  Future<void> _showImagePickerDialog(BuildContext context, InspectionsState state) async {
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
                        ontap: () async {
                          Navigator.of(context).pop();

                          await _getImageFromCamera(state);
                        },
                      ),
                      const VerticalSpace.xxSmall(),
                      CustomGreyAppButton(
                        textColor: context.theme.colorScheme.primary,
                        text: "Pick From Gallery",
                        containerColor: context.theme.colorScheme.onSurfaceVariant,
                        ontap: () async {
                          Navigator.of(context).pop();

                          await _getImagesFromGallery(state);
                        },
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(
                      'Cancel',
                      style: context.textTheme.bodyLarge?.copyWith(color: Colors.red),
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

class CameraPageCondition extends StatefulWidget {
  final Function(File) onCapture;
  final int limit;
  final List<File> capturedImages;

  const CameraPageCondition({
    Key? key,
    required this.onCapture,
    required this.limit,
    required this.capturedImages,
  }) : super(key: key);

  @override
  _CameraPageConditionState createState() => _CameraPageConditionState();
}

class _CameraPageConditionState extends State<CameraPageCondition> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  late List<File> _capturedImages;
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  String rotation = "portrait";

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController.initialize();

    _cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);
  }

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = initializeCamera();
    _capturedImages = List.from(widget.capturedImages);

    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      _evaluateDeviceOrientation(event);
    });
  }

  void _evaluateDeviceOrientation(AccelerometerEvent event) {
    final double x = event.x;

    const double threshold = 0.5;

    if (x > threshold) {
      rotation = "right";
    } else if (x < -threshold) {
      rotation = "left";
    } else {
      rotation = "portrait";
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _accelerometerSubscription.cancel();

    super.dispose();
  }

  Future<File> rotateToLandscape(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final originalImage = img.decodeImage(bytes);

    final rotatedImage = img.copyRotate(originalImage!, angle: rotation == "right" ? 270 : -270);
    final outputFile = File(imageFile.path);
    await outputFile.writeAsBytes(img.encodeJpg(rotatedImage));
    return outputFile;
  }

  bool _isTakingPicture = false;

  Future<void> _captureImage() async {
    if (_isTakingPicture) {
      return; // Eğer bir fotoğraf çekme işlemi devam ediyorsa çıkış yap
    }
    setState(() {
      _isTakingPicture = true; // Fotoğraf çekme işlemi başladı
    });

    try {
      await _initializeControllerFuture;
      final XFile image = await _cameraController.takePicture();
      final landscapeFile = await rotateToLandscape(File(image.path));
      // final File file = File(image.path);
      widget.onCapture(landscapeFile);

      setState(() {
        _capturedImages.add(landscapeFile);
      });
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);

      BotToast.showText(text: 'Error capturing image: $e');
    } finally {
      setState(() {
        _isTakingPicture = false; // Fotoğraf çekme işlemi tamamlandı
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            Navigator.pop(context, _capturedImages);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              Navigator.pop(context, _capturedImages);
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                SizedBox(
                  height: context.height,
                  width: context.width,
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
                        onTap: () {
                          if (rotation == "portrait") {
                            BotToast.showText(text: 'Please rotate the device to landscape mode');
                          } else {
                            _captureImage();
                          }
                        },
                        child: const CircleAvatar(
                          radius: 30,
                          child: Icon(
                            Icons.camera_alt,
                            size: 30,
                          ),
                        ),
                      ),
                      const VerticalSpace.xSmall(),
                      if (_capturedImages.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.primaryContainer.withOpacity(0.2),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                          ),
                          width: context.width,
                          height: 140,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.dynamicWidth(0.05),
                              vertical: context.dynamicHeight(0.02),
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _capturedImages.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.020)),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          _capturedImages[index],
                                        ),
                                      ),
                                      Positioned(
                                          top: -12,
                                          right: -10,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _capturedImages.removeAt(index);
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.red,
                                              )))
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
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
