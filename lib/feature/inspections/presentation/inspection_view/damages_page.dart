import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:bot_toast/bot_toast.dart';
import 'package:camera/camera.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/job_damage/job_damage_bloc.dart';
import 'package:ferrisfwt/feature/inspections/presentation/bloc/inspections_bloc.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/edit_details_page.dart';
import 'package:ferrisfwt/feature/profile/presantation/cubit/permissions_cubit.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_post_model.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/button/custom_grey_app_button.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/popup/question_popup.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_horizontal_spacer.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

import '../../../../product/utility/error_handler/sentry_error_handler.dart';
import '../../data/models/condition_image/condition_image_response_model.dart';

class DamagesPage extends StatefulWidget {
  final int jobInspectionId;
  final List<int> standarIds;
  const DamagesPage({
    super.key,
    required this.jobInspectionId,
    required this.standarIds,
  });

  @override
  State<DamagesPage> createState() => _DamagesPageState();
}

class _DamagesPageState extends State<DamagesPage> {
  // late final HiveStorageManager _hiveStorageManager;
  InspectionDamagePostModel? updateModel;
  String _category = "";
  String _part = "";
  String _issue = "";
  String _failure = "";
  String _repair = "";
  File? _selectedImage;
  File? _selectedContextImage;

  void _submitDamageToAPI(InspectionsState state) {
    if (_category.isEmpty) {
      BotToast.showText(text: "Please select Category");
      context
          .read<InspectionsBloc>()
          .add(const PostJobInspectionsDamagesControl());

      return;
    }
    if (_part.isEmpty) {
      BotToast.showText(text: "Please select Part");
      context
          .read<InspectionsBloc>()
          .add(const PostJobInspectionsDamagesControl());
      return;
    }
    if (_issue.isEmpty) {
      BotToast.showText(text: "Please select Issue");
      context
          .read<InspectionsBloc>()
          .add(const PostJobInspectionsDamagesControl());
      return;
    }
    if (_failure.isEmpty) {
      BotToast.showText(text: "Please select Failure");
      context
          .read<InspectionsBloc>()
          .add(const PostJobInspectionsDamagesControl());
      return;
    }
    if (_repair.isEmpty) {
      BotToast.showText(text: "Please select Repair");
      context
          .read<InspectionsBloc>()
          .add(const PostJobInspectionsDamagesControl());
      return;
    }

    if (_selectedImage == null || _selectedContextImage == null) {
      BotToast.showText(text: "Please upload an image");
      context
          .read<InspectionsBloc>()
          .add(const PostJobInspectionsDamagesControl());
      return;
    }

    context.read<InspectionsBloc>().add(
          PostJobInspectionsDamages(
            isAsync: false,
            jobInspectionId: widget.jobInspectionId,
            data: InspectionDamagePostModel(
              damageId: Random().nextInt(10000),
              damageImage: _selectedImage,
              contextImage: _selectedContextImage,
              jobInspectionId: widget.jobInspectionId,
              categoryId: state.getDamageCategoriesResponse
                      .firstWhere((element) => element?.name == _category)!
                      .id ??
                  1,
              partId: state.getDamagePartsResponse
                      .firstWhere((element) => element.name == _part)
                      .id ??
                  1,
              issueId: state.getDamageIssuesResponse
                  .firstWhere((element) => element.name == _issue)
                  .id!,
              failureId: state.getDamageFailuresResponse
                      .firstWhere((element) => element.name == _failure)
                      .id ??
                  1,
              repairId: state.getDamageRepairsResponse
                      .firstWhere((element) => element.name == _repair)
                      .id ??
                  1,
            ),
          ),
        );

    // state.getDamageCategoriesResponse.clear();
    // state.getDamagePartsResponse.clear();
    // state.getDamageIssuesResponse.clear();
    // state.getDamageFailuresResponse.clear();
    // state.getDamageRepairsResponse.clear();

    showTopSnackBarFr(
      context,
      message: "Damage added successfully",
    );
    context.pop();
  }

  List<File> _imageFiles = [];
  static const int maxImages = 2;
  final List<ConditionImageResponseModel> _deletedImages = [];

  Future<void> compressImage(File image) async {
    final documentPath = (await getApplicationDocumentsDirectory()).path;
    final newFile =
        await image.copy('$documentPath/${path.basename(image.path)}');
    File compressedImage = await _resizeImage(newFile);
    setState(() {
      _imageFiles.add(compressedImage);
    });
  }

  Future<void> _getImageFromCamera(InspectionsState state) async {
    PermissionStatus permissionStatus = await Permission.camera.status;
    if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
      final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Camera Permission'),
            content: const Text(
                'This app needs camera access to take pictures. Please allow camera access in settings.'),
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
                  if (permissionStatus.isDenied ||
                      permissionStatus.isPermanentlyDenied) {
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

    final currentUploadedImages = _imageFiles.length +
        state.conditionImageResponse.length -
        _deletedImages.length;
    final remainingImages = maxImages - currentUploadedImages;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraPageDamage(
          submitDamageToAPI: () async {
            // Implement the logic to submit damage to API
            _submitDamageToAPI(state);
          },
          limit: remainingImages,
          onCapture: (File image) async {
            if (_imageFiles.length < 2) {
              await compressImage(image);
            } else {
              BotToast.showText(text: 'You can only select 2 images in total');
            }
          },
          capturedImages: _imageFiles,
        ),
      ),
    );

    if (result != null && result is List<File>) {
      setState(() {
        _imageFiles = result;

        _selectedContextImage = _imageFiles[0];
        _selectedImage = _imageFiles[1];
      });
    }

    permissionStatus = await Permission.camera.status;
    if (!permissionStatus.isGranted) {
      BotToast.showText(text: 'Camera access denied');
      return;
    }
  }

  Future<void> captureImages(InspectionsState state) async {
    // Context Image için kamera açılıyor

    final contextImage =
        await _getImage(ImageSource.camera, state, isDamage: 0);

    if (contextImage != null) {
      setState(() {
        _selectedContextImage = contextImage;
      });
    } else {
      return; // Eğer iptal edildiyse veya başarısız olduysa devam etme.
    }

    // Context Image'ı çektikten sonra kullanıcıya bir onay mesajı gösterip devam etmek isteyip istemediğini sorabilirsiniz
    // Eğer kullanıcı devam etmek istiyorsa, kamerayı yeniden açarak Damage Image'ı çekin.

    // Örneğin, kullanıcıya bir diyalog ile "Devam etmek ister misiniz?" diye sorabilirsiniz
    final shouldContinue = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("You also need to include the Damage Image."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );

    if (shouldContinue == true) {
      // Damage Image için kamera açılıyor

      final damageImage =
          await _getImage(ImageSource.camera, state, isDamage: 1);

      if (damageImage != null) {
        setState(() {
          _selectedImage = damageImage;
        });
      } else {}
    } else {}
  }

  Future<File?> _getImage(ImageSource source, InspectionsState state,
      {required int isDamage}) async {
    if (source == ImageSource.camera) {
      PermissionStatus permissionStatus = await Permission.camera.status;
      if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
        final result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Camera Permission'),
              content: const Text(
                  'This app needs camera access to take pictures. Please allow camera access in settings.'),
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
                    if (permissionStatus.isDenied ||
                        permissionStatus.isPermanentlyDenied) {
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
          return null;
        }
      }

      permissionStatus = await Permission.camera.status;
      if (!permissionStatus.isGranted) {
        BotToast.showText(text: 'Camera access denied');
        return null;
      }
    }

    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      File file = File(pickedImage.path);

      final documentPath = (await getApplicationDocumentsDirectory()).path;
      file = await file.copy('$documentPath/${path.basename(file.path)}');

      File compressedImage = await _resizeImage(file);

      // Eğer isDamage true ise ve fotoğraf çekme işlemi bittiyse
      if (isDamage == 1) {
        Future.delayed(
          const Duration(seconds: 1),
          () {
            _submitDamageToAPI(state);
          },
        );
      }

      return compressedImage;
    } else {
      return null;
    }
  }

  // Future<File?> _getImage(ImageSource source, InspectionsState state,
  //     {required int isDamage}) async {
  //   if (source == ImageSource.camera) {
  //     PermissionStatus permissionStatus = await Permission.camera.status;
  //     if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
  //       final result = await showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text('Camera Permission'),
  //             content: const Text(
  //                 'This app needs camera access to take pictures. Please allow camera access in settings.'),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop(false);
  //                 },
  //                 child: const Text('Cancel'),
  //               ),
  //               TextButton(
  //                 onPressed: () async {
  //                   context.read<CubitPermissions>().requestCamera();
  //                   final permissionStatus = await Permission.camera.status;
  //                   if (permissionStatus.isDenied ||
  //                       permissionStatus.isPermanentlyDenied) {
  //                     await openAppSettings();
  //                   }
  //                   context.pop();
  //                 },
  //                 child: const Text('Open Settings'),
  //               ),
  //             ],
  //           );
  //         },
  //       );

  //       if (result != true) {
  //         return null;
  //       }
  //     }

  //     permissionStatus = await Permission.camera.status;
  //     if (!permissionStatus.isGranted) {
  //       BotToast.showText(text: 'Camera access denied');
  //       return null;
  //     }
  //   }

  //   final picker = ImagePicker();
  //   final pickedImage = await picker.pickImage(source: source);

  //   if (pickedImage != null) {
  //     File file = File(pickedImage.path);

  //     final documentPath = (await getApplicationDocumentsDirectory()).path;
  //     file = await file.copy('$documentPath/${path.basename(file.path)}');

  //     // Fotoğrafı sıkıştırıyoruz
  //     File compressedImage = await _resizeImage(file);

  //     // Eğer isDamage 1 ise ve fotoğraf çekme işlemi bittiyse
  //     if (isDamage == 1) {
  //       Future.delayed(
  //         const Duration(seconds: 1),
  //         () {
  //           _submitDamageToAPI(state);
  //         },
  //       );
  //     }

  //     return compressedImage;
  //   } else {
  //     return null;
  //   }
  // }

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
    super.initState();
    context
        .read<InspectionsBloc>()
        .add(GetInspectionsDamageAssets(standardIds: widget.standarIds));
    // context
    //     .read<JobDamageBloc>()
    //     .add(GetDamageCategories(widget.jobInspectionId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InspectionsBloc, InspectionsState>(
      builder: (context, state) {
        if (state.status == ViewStatus.loading ||
            state.getDamageCategoriesResponse.isEmpty) {
          return const Scaffold(
            body: Center(
              child: LoadingProgress(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.cancel_outlined,
                color: context.theme.colorScheme.primary,
                size: 24,
              ),
              onPressed: () {
                context.pop();
                state.getDamageCategoriesResponse.clear();
                state.getDamagePartsResponse.clear();
                state.getDamageIssuesResponse.clear();
                state.getDamageFailuresResponse.clear();
                state.getDamageRepairsResponse.clear();
              },
            ),
            backgroundColor: context.theme.colorScheme.surface,
            title: Text('Add Damage', style: context.textTheme.titleSmall),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: context.paddingAllDefault,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonWidget(
                    value: _category == "" ? null : _category,
                    hintText: "Select Level at Category",
                    items: state.getDamageCategoriesResponse
                        .map((e) => DropdownMenuItem(
                              value: e?.name,
                              child: Text(e?.name ?? ""),
                            ))
                        .toList(),
                    text: "Category",
                    onChanged: (String) {
                      if (_category != String) {
                        setState(() {
                          _category = String ?? '';
                          _part = "";
                          _issue = "";
                          _failure = "";
                          _repair = "";
                        });
                        final int id = state.getDamageCategoriesResponse
                                .firstWhere(
                                    (element) => element?.name == String)!
                                .id ??
                            1;

                        // if (state.getDamagePartsResponse.isNotEmpty &&
                        //     state.getDamageIssuesResponse.isNotEmpty &&
                        //     state.getDamageFailuresResponse.isNotEmpty &&
                        //     state.getDamageRepairsResponse.isNotEmpty) {
                        //   state.getDamagePartsResponse.clear();
                        //   state.getDamageIssuesResponse.clear();
                        //   state.getDamageFailuresResponse.clear();
                        //   state.getDamageRepairsResponse.clear();
                        // }

                        context.read<InspectionsBloc>().add(
                            GetInspectionsDamagesPart(id, widget.standarIds));
                      }
                    },
                    textSpanEnable: true,
                  ),
                  const VerticalSpace.small(),
                  DropdownButtonWidget(
                    value: _part == "" ? null : _part,
                    hintText: "Select Level at Part",
                    items: state.getDamagePartsResponse
                        .map((e) => DropdownMenuItem(
                              value: e.name,
                              child: Text(e.name ?? ""),
                            ))
                        .toList(),
                    text: "Part",
                    onChanged: (String) {
                      if (_part != String) {
                        _part = String ?? '';
                        _issue = "";
                        _failure = "";
                        _repair = "";

                        final int id = state.getDamagePartsResponse
                                .firstWhere((element) => element.name == String)
                                .id ??
                            1;

                        // if (state.getDamageIssuesResponse.isNotEmpty &&
                        //     state.getDamageFailuresResponse.isNotEmpty &&
                        //     state.getDamageRepairsResponse.isNotEmpty) {
                        //   state.getDamageIssuesResponse.clear();
                        //   state.getDamageFailuresResponse.clear();
                        //   state.getDamageRepairsResponse.clear();
                        // }

                        context.read<InspectionsBloc>().add(
                              GetInspectionsDamagesIssue(
                                id,
                                damageCategoryId: state.damageCategoryId,
                                standarIds: widget.standarIds,
                              ),
                            );
                      }
                    },
                    textSpanEnable: true,
                  ),
                  const VerticalSpace.small(),
                  DropdownButtonWidget(
                    value: _issue == "" ? null : _issue,
                    hintText: "Select Level at Issue",
                    items: state.getDamageIssuesResponse
                        .map((e) => DropdownMenuItem(
                              value: e.name,
                              child: Text(e.name ?? ""),
                            ))
                        .toList(),
                    text: "Issue",
                    onChanged: (String) {
                      if (_issue != String) {
                        setState(() {
                          _issue = String ?? '';
                          _failure = "";
                          _repair = "";
                        });
                        final int id = state.getDamageIssuesResponse
                            .firstWhere((element) => element.name == String)
                            .id!;

                        // if (state.getDamageFailuresResponse.isNotEmpty &&
                        //     state.getDamageRepairsResponse.isNotEmpty) {
                        //   state.getDamageFailuresResponse.clear();
                        //   state.getDamageRepairsResponse.clear();
                        // }

                        context.read<InspectionsBloc>().add(
                              GetInspectionsDamagesFailure(
                                id,
                                damageCategoryId: state.damageCategoryId,
                                damagePartId: state.damagePartId,
                                standarIds: widget.standarIds,
                              ),
                            );
                      }
                    },
                    textSpanEnable: true,
                  ),
                  const VerticalSpace.small(),
                  DropdownButtonWidget(
                    value: _failure == "" ? null : _failure,
                    hintText: "Select Level at Failure",
                    items: state.getDamageFailuresResponse
                        .map((e) => DropdownMenuItem(
                              value: e.name,
                              child: Text(e.name ?? ""),
                            ))
                        .toList(),
                    text: "Failure",
                    onChanged: (String) {
                      if (_failure != String) {
                        setState(() {
                          _failure = String ?? '';
                          _repair = "";
                        });
                        final int id = state.getDamageFailuresResponse
                            .firstWhere((element) => element.name == String)
                            .id!;
                        // if (state.getDamageRepairsResponse.isNotEmpty) {
                        //   state.getDamageRepairsResponse.clear();
                        // }

                        // if (state.getDamageRepairsResponse.isNotEmpty) {
                        //   state.getDamageRepairsResponse.clear();
                        // }
                        context.read<InspectionsBloc>().add(
                              GetInspectionsDamagesRepair(
                                id,
                                damageCategoryId: state.damageCategoryId,
                                damagePartId: state.damagePartId,
                                standarIds: widget.standarIds,
                                damageIssueId: state.damageIssueId,
                              ),
                            );
                      }
                    },
                    textSpanEnable: true,
                  ),
                  const VerticalSpace.small(),
                  DropdownButtonWidget(
                    value: _repair == "" ? null : _repair,
                    hintText: "Select Level at Repair",
                    items: state.getDamageRepairsResponse
                        .map((e) => DropdownMenuItem(
                              value: e.name,
                              child: Text(e.name ?? ""),
                            ))
                        .toList(),
                    text: "Repair",
                    onChanged: (String) {
                      setState(() {
                        _repair = String ?? '';
                      });
                    },
                    textSpanEnable: true,
                  ),
                  const VerticalSpace.small(),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       "Context Image",
                  //       style: context.textTheme.bodyLarge?.copyWith(
                  //           color: context.theme.colorScheme.primary,
                  //           fontWeight: FontWeight.w600),
                  //     ),
                  //     const VerticalSpace.small(),
                  //     InkWell(
                  //       child: Image.asset(
                  //         width: context.width,
                  //         "assets/images/fr_upload_image1.png",
                  //       ),
                  //       onTap: () async {
                  //         // _showImagePickerDialog(context, true);
                  //         // _getImage(ImageSource.gallery, state, isDamage: 0)
                  //         //     .then((value) {
                  //         //   if (value != null) {
                  //         //     setState(() {
                  //         //       _selectedContextImage = value;
                  //         //     });
                  //         //   }
                  //         // });

                  //         await captureImages(state);
                  //       },
                  //     ),
                  //   ],
                  // ),
                  InkWell(
                    child: Image.asset(
                      width: context.width,
                      "assets/images/fr_upload_image1.png",
                    ),
                    onTap: () async {
                      // _showImagePickerDialog(context, true);
                      // _getImage(ImageSource.gallery, state, isDamage: 0)
                      //     .then((value) {
                      //   if (value != null) {
                      //     setState(() {
                      //       _selectedContextImage = value;
                      //     });
                      //   }
                      // });

                      // await captureImages(state);
                      await _getImageFromCamera(state);
                    },
                  ),
                  const VerticalSpace.xSmall(),
                  if (_imageFiles.isNotEmpty)
                    SizedBox(
                      height: context.dynamicHeight(0.25),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (BuildContext context, int index) =>
                            const HorizontalSpace.xSmall(),
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _imageFiles.length - 1,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                index == 0 ? "Context Image" : "Damage Image",
                                style: context.textTheme.bodyLarge?.copyWith(
                                    color: context.theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600),
                              ),
                              const VerticalSpace.xSmall(),
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      _imageFiles[index],
                                      fit: BoxFit.cover,
                                      height: context.dynamicHeight(0.20),
                                      width: context.dynamicWidth(0.40),
                                    ),
                                  ),
                                  Positioned(
                                    top: -5,
                                    right: -5,
                                    child: IconButton(
                                      icon: Icon(Icons.cancel_outlined,
                                          color:
                                              context.theme.colorScheme.error),
                                      onPressed: () {
                                        setState(() {
                                          _imageFiles.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     if (_selectedContextImage != null)
                  //       Expanded(
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               "Context Image",
                  //               style: context.textTheme.bodyLarge?.copyWith(
                  //                   color: context.theme.colorScheme.primary,
                  //                   fontWeight: FontWeight.w600),
                  //             ),
                  //             const VerticalSpace.xSmall(),
                  //             Stack(
                  //               children: [
                  //                 Container(
                  //                   height: context.dynamicHeight(0.25),
                  //                   width: context.dynamicWidth(0.45),
                  //                   decoration: BoxDecoration(
                  //                     color: context
                  //                         .theme.colorScheme.primaryContainer,
                  //                     borderRadius: BorderRadius.circular(10),
                  //                     image: DecorationImage(
                  //                       image: FileImage(_imageFiles[0]),
                  //                       fit: BoxFit.cover,
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Positioned(
                  //                   top: 0,
                  //                   right: 0,
                  //                   child: IconButton(
                  //                     icon: Icon(
                  //                       Icons.cancel_outlined,
                  //                       color: context.theme.colorScheme.error,
                  //                     ),
                  //                     onPressed: () {
                  //                       setState(() {
                  //                         _selectedContextImage = null;
                  //                         _imageFiles.clear();
                  //                       });
                  //                     },
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     const HorizontalSpace.xSmall(),
                  //     if (_selectedImage != null)
                  //       Expanded(
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               "Damage Image",
                  //               style: context.textTheme.bodyLarge?.copyWith(
                  //                   color: context.theme.colorScheme.primary,
                  //                   fontWeight: FontWeight.w600),
                  //             ),
                  //             const VerticalSpace.xSmall(),
                  //             Stack(
                  //               children: [
                  //                 Container(
                  //                   height: context.dynamicHeight(0.25),
                  //                   width: context.dynamicWidth(0.45),
                  //                   decoration: BoxDecoration(
                  //                     color: context
                  //                         .theme.colorScheme.primaryContainer,
                  //                     borderRadius: BorderRadius.circular(10),
                  //                     image: DecorationImage(
                  //                       image: FileImage(_imageFiles[1]),
                  //                       fit: BoxFit.cover,
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Positioned(
                  //                   top: 0,
                  //                   right: 0,
                  //                   child: IconButton(
                  //                     icon: Icon(
                  //                       Icons.cancel_outlined,
                  //                       color: context.theme.colorScheme.error,
                  //                     ),
                  //                     onPressed: () {
                  //                       setState(() {
                  //                         _selectedImage = null;
                  //                         _imageFiles.clear();
                  //                       });
                  //                     },
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //   ],
                  // ),

                  // const VerticalSpace.xSmall(),
                  // Divider(
                  //   color: context.theme.colorScheme.primary,
                  //   thickness: 0.5,
                  // ),
                  // const VerticalSpace.xSmall(),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       "Damage Image ",
                  //       style: context.textTheme.bodyLarge?.copyWith(
                  //           color: context.theme.colorScheme.primary,
                  //           fontWeight: FontWeight.w600),
                  //     ),
                  //     const VerticalSpace.small(),
                  //     InkWell(
                  //       child: Image.asset(
                  //         width: context.width,
                  //         "assets/images/fr_upload_image1.png",
                  //       ),
                  //       onTap: () {
                  //         // _showImagePickerDialog(context, false);
                  //         _getImage(ImageSource.gallery, state, isDamage: 1)
                  //             .then((value) {
                  //           if (value != null) {
                  //             setState(() {
                  //               _selectedImage = value;
                  //             });
                  //           }
                  //         });

                  //         // Future.delayed(
                  //         //   const Duration(seconds: 2),
                  //         //   () {
                  //         //     _submitDamageToAPI(state);
                  //         //   },
                  //         // );
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // const VerticalSpace.xSmall(),
                  // if (_selectedImage != null)
                  //   Stack(
                  //     children: [
                  //       Container(
                  //         height: context.dynamicHeight(0.15),
                  //         width: context.dynamicWidth(0.35),
                  //         decoration: BoxDecoration(
                  //           color: context.theme.colorScheme.primaryContainer,
                  //           borderRadius: BorderRadius.circular(10),
                  //           image: DecorationImage(
                  //             image: FileImage(_selectedImage!),
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //       ),
                  //       Positioned(
                  //         top: 0,
                  //         right: 0,
                  //         child: IconButton(
                  //           icon: Icon(
                  //             Icons.cancel_outlined,
                  //             color: context.theme.colorScheme.error,
                  //           ),
                  //           onPressed: () {
                  //             setState(() {
                  //               _selectedImage = null;
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  const VerticalSpace.large(),
                  if (state.isError)
                    CustomAppButton(
                      text: "Save",
                      ontap: () {
                        if (_category.isEmpty) {
                          BotToast.showText(text: "Please select Category");
                          context
                              .read<InspectionsBloc>()
                              .add(const PostJobInspectionsDamagesControl());
                          return;
                        }
                        if (_part.isEmpty) {
                          BotToast.showText(text: "Please select Part");
                          context
                              .read<InspectionsBloc>()
                              .add(const PostJobInspectionsDamagesControl());
                          return;
                        }
                        if (_issue.isEmpty) {
                          BotToast.showText(text: "Please select Issue");
                          context
                              .read<InspectionsBloc>()
                              .add(const PostJobInspectionsDamagesControl());
                          return;
                        }
                        if (_failure.isEmpty) {
                          BotToast.showText(text: "Please select Failure");
                          context
                              .read<InspectionsBloc>()
                              .add(const PostJobInspectionsDamagesControl());
                          return;
                        }
                        if (_repair.isEmpty) {
                          BotToast.showText(text: "Please select Repair");
                          context
                              .read<InspectionsBloc>()
                              .add(const PostJobInspectionsDamagesControl());
                          return;
                        }

                        if (_selectedImage == null ||
                            _selectedContextImage == null) {
                          BotToast.showText(text: "Please upload an image");
                          context
                              .read<InspectionsBloc>()
                              .add(const PostJobInspectionsDamagesControl());
                          return;
                        }

                        context.read<InspectionsBloc>().add(
                              PostJobInspectionsDamages(
                                isAsync: false,
                                jobInspectionId: widget.jobInspectionId,
                                data: InspectionDamagePostModel(
                                  damageId: Random().nextInt(10000),
                                  damageImage: _selectedImage,
                                  contextImage: _selectedContextImage,
                                  jobInspectionId: widget.jobInspectionId,
                                  categoryId: state.getDamageCategoriesResponse
                                          .firstWhere((element) =>
                                              element?.name == _category)!
                                          .id ??
                                      1,
                                  partId: state.getDamagePartsResponse
                                          .firstWhere((element) =>
                                              element.name == _part)
                                          .id ??
                                      1,
                                  issueId: state.getDamageIssuesResponse
                                      .firstWhere(
                                          (element) => element.name == _issue)
                                      .id!,
                                  failureId: state.getDamageFailuresResponse
                                          .firstWhere((element) =>
                                              element.name == _failure)
                                          .id ??
                                      1,
                                  repairId: state.getDamageRepairsResponse
                                          .firstWhere((element) =>
                                              element.name == _repair)
                                          .id ??
                                      1,
                                ),
                              ),
                            );

                        // state.getDamageCategoriesResponse.clear();
                        // state.getDamagePartsResponse.clear();
                        // state.getDamageIssuesResponse.clear();
                        // state.getDamageFailuresResponse.clear();
                        // state.getDamageRepairsResponse.clear();

                        showTopSnackBarFr(
                          context,
                          message: "Damage added successfully",
                        );
                        context.pop();
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Future<void> _showImagePickerDialog(
  //     @override
  // BuildContext context, bool isContextImage) async {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         contentPadding: EdgeInsets.zero,
  //         content: Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10),
  //             color: context.theme.colorScheme.surface,
  //           ),
  //           width: context.dynamicWidth(0.98),
  //           height: context.dynamicHeight(0.38),
  //           child: Padding(
  //             padding: context.paddingAllDefault,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //               children: [
  //                 Text(
  //                   'Select an image picker method',
  //                   style: context.textTheme.headlineMedium?.copyWith(
  //                       color: context.theme.colorScheme.primary, fontSize: 20),
  //                 ),
  //                 Column(
  //                   children: [
  //                     CustomGreyAppButton(
  //                       textColor: context.theme.colorScheme.primary,
  //                       text: "Open Camera",
  //                       containerColor: context.theme.colorScheme.surface,
  //                       ontap: () async {
  //                         _getImage(ImageSource.camera).then((value) {
  //                           if (value != null) {
  //                             if (isContextImage) {
  //                               setState(() {
  //                                 _selectedContextImage = value;
  //                               });
  //                             } else {
  //                               setState(() {
  //                                 _selectedImage = value;
  //                               });
  //                             }
  //                           }
  //                         });
  //                         Navigator.of(context).pop();
  //                       },
  //                     ),
  //                     const VerticalSpace.xxSmall(),
  //                     CustomGreyAppButton(
  //                       textColor: context.theme.colorScheme.primary,
  //                       text: " Pick From Gallery",
  //                       containerColor: context.theme.colorScheme.surface,
  //                       ontap: () {
  //                         _getImage(ImageSource.gallery).then((value) {
  //                           if (value != null) {
  //                             if (isContextImage) {
  //                               setState(() {
  //                                 _selectedContextImage = value;
  //                               });
  //                             } else {
  //                               setState(() {
  //                                 _selectedImage = value;
  //                               });
  //                             }
  //                           }
  //                         });
  //                         Navigator.of(context).pop();
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //                 TextButton(
  //                   onPressed: () {
  //                     context.pop();
  //                   },
  //                   child: Text(
  //                     'Cancel',
  //                     style: context.textTheme.bodyLarge?.copyWith(
  //                       color: Colors.red,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

class CameraPageDamage extends StatefulWidget {
  final Function(File) onCapture;
  final int limit;
  final List<File> capturedImages;
  final Future<void> Function() submitDamageToAPI;

  const CameraPageDamage({
    Key? key,
    required this.onCapture,
    required this.limit,
    required this.capturedImages,
    required this.submitDamageToAPI,
  }) : super(key: key);

  @override
  _CameraPageDamageState createState() => _CameraPageDamageState();
}

class _CameraPageDamageState extends State<CameraPageDamage> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  late List<File> _capturedImages;

  bool isDamage = false;

  Future<void> initializeCamera() async {
    setState(() {
      isDamage = false;
    });
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
    _capturedImages = List.from(widget.capturedImages);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  // Future<void> _captureImage() async {
  //   try {
  //     await _initializeControllerFuture;
  //     final XFile image = await _cameraController.takePicture();
  //     final File file = File(image.path);
  //     widget.onCapture(file);
  //     setState(() {
  //       _capturedImages.add(file);
  //     });
  //   } catch (e) {
  //     BotToast.showText(text: 'Error capturing image: $e');
  //   }
  // }

  bool _isTakingPicture = false;

  Future<void> _captureImage() async {
    if (_isTakingPicture) {
      return; // Eğer bir fotoğraf çekme işlemi devam ediyorsa çıkış yap
    }
    setState(() {
      _isTakingPicture = true; // Fotoğraf çekme işlemi başladı
    });

    try {
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          setState(() {
            isDamage = true;
          });
        },
      );
      await _initializeControllerFuture;
      final XFile image = await _cameraController.takePicture();
      final File file = File(image.path);
      widget.onCapture(file);

      if (_capturedImages.length < 2) {
        setState(() {
          _capturedImages.add(file);
        });
      }

      if (_capturedImages.length == 2) {
        Navigator.pop(context, _capturedImages);
        Future.delayed(
          const Duration(seconds: 1),
          () async {
            await widget.submitDamageToAPI();
          },
        );
      }
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
        title: Text(isDamage ? "Damage Image" : "Context Image"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, _capturedImages);
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
                        onTap: _captureImage,
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
                            color: context.theme.colorScheme.primaryContainer
                                .withOpacity(0.2),
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: context.dynamicWidth(0.020)),
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
                                                  _capturedImages
                                                      .removeAt(index);
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
