import 'dart:io';
import 'dart:typed_data';
import 'package:bot_toast/bot_toast.dart';
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
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

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

  Future<File?> _getImage(ImageSource source) async {
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

      return compressedImage;
    } else {
      return null;
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
        // print("CATEGORY RESPONSE 1 : ${state.getDamageCategoriesResponse}");
        // print(
        //     "CATEGORY RESPONSE 2 : ${state.getDamageCategoriesResponse[1]!.name}");
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

                        // if (state.getDamagePartsResponse.isNotEmpty ||
                        //     state.getDamageIssuesResponse.isNotEmpty ||
                        //     state.getDamageFailuresResponse.isNotEmpty ||
                        //     state.getDamageRepairsResponse.isNotEmpty) {
                        //   state.getDamagePartsResponse.clear();
                        //   state.getDamageIssuesResponse.clear();
                        //   state.getDamageFailuresResponse.clear();
                        //   state.getDamageRepairsResponse.clear();
                        // }

                        // print("SELECT CATEGORY : $id");
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

                        // if (state.getDamageIssuesResponse.isNotEmpty ||
                        //     state.getDamageFailuresResponse.isNotEmpty ||
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
                        // if (state.getDamageFailuresResponse.isNotEmpty ||
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
                  //   mainAxisSize: MainAxisSize.min,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     SizedBox(
                  //       width: context.dynamicWidth(1.0),
                  //       child: ElevatedButton(
                  //         style: ElevatedButton.styleFrom(
                  //           padding: EdgeInsets.zero,
                  //           backgroundColor:
                  //               context.theme.colorScheme.primaryContainer,
                  //           elevation: 0,
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(8.0),
                  //           ),
                  //         ),
                  //         onPressed: () {
                  //           context
                  //               .read<InspectionsBloc>()
                  //               .add(ToggleButtonsEvent());
                  //         },
                  //         child: Text(
                  //           'Add Image',
                  //           style: context.theme.textTheme.bodyMedium?.copyWith(
                  //             color: context.theme.colorScheme.onSecondary,
                  //             fontWeight: FontWeight.w600,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(height: 10.0),
                  //     AnimatedSize(
                  //       alignment: Alignment.center,
                  //       duration: const Duration(milliseconds: 300),
                  //       curve: Curves.easeInOut,
                  //       child: Column(
                  //         children: state.areButtonsVisible
                  //             ? [
                  //                 Padding(
                  //                   padding: const EdgeInsets.symmetric(
                  //                       horizontal: 16.0),
                  //                   child: CustomGreyAppButton(
                  //                     width: context.dynamicWidth(1.0),
                  //                     textColor:
                  //                         context.theme.colorScheme.primary,
                  //                     text: "Damage",
                  //                     containerColor:
                  //                         context.theme.colorScheme.surface,
                  //                     ontap: () {},
                  //                   ),
                  //                 ),
                  //                 const SizedBox(height: 8.0),
                  //                 Padding(
                  //                   padding: const EdgeInsets.symmetric(
                  //                       horizontal: 16.0),
                  //                   child: CustomGreyAppButton(
                  //                     width: context.dynamicWidth(1.0),
                  //                     textColor:
                  //                         context.theme.colorScheme.primary,
                  //                     text: "Context",
                  //                     containerColor:
                  //                         context.theme.colorScheme.surface,
                  //                     ontap: () {},
                  //                   ),
                  //                 ),
                  //               ]
                  //             : [],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const VerticalSpace.small(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Damage Image ",
                        style: context.textTheme.bodyLarge?.copyWith(
                            color: context.theme.colorScheme.primary,
                            fontWeight: FontWeight.w600),
                      ),
                      const VerticalSpace.small(),
                      InkWell(
                        child: Image.asset(
                          width: context.width,
                          "assets/images/fr_upload_image1.png",
                        ),
                        onTap: () {
                          _showImagePickerDialog(context, false);
                        },
                      ),
                    ],
                  ),
                  const VerticalSpace.xSmall(),
                  if (_selectedImage != null)
                    Stack(
                      children: [
                        Container(
                          height: context.dynamicHeight(0.15),
                          width: context.dynamicWidth(0.35),
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
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
                                _selectedImage = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  const VerticalSpace.xSmall(),
                  Divider(
                    color: context.theme.colorScheme.primary,
                    thickness: 0.5,
                  ),
                  const VerticalSpace.xSmall(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Context Image",
                        style: context.textTheme.bodyLarge?.copyWith(
                            color: context.theme.colorScheme.primary,
                            fontWeight: FontWeight.w600),
                      ),
                      const VerticalSpace.small(),
                      InkWell(
                        child: Image.asset(
                          width: context.width,
                          "assets/images/fr_upload_image1.png",
                        ),
                        onTap: () {
                          _showImagePickerDialog(context, true);
                        },
                      ),
                    ],
                  ),
                  const VerticalSpace.xSmall(),
                  if (_selectedContextImage != null)
                    Stack(
                      children: [
                        Container(
                          height: context.dynamicHeight(0.15),
                          width: context.dynamicWidth(0.35),
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: FileImage(_selectedContextImage!),
                              fit: BoxFit.cover,
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
                                _selectedContextImage = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  const VerticalSpace.large(),
                  CustomAppButton(
                    text: "Save",
                    ontap: () {
                      if (_category.isEmpty) {
                        BotToast.showText(text: "Please select Category");
                        return;
                      }
                      if (_part.isEmpty) {
                        BotToast.showText(text: "Please select Part");
                        return;
                      }
                      if (_issue.isEmpty) {
                        BotToast.showText(text: "Please select Issue");
                        return;
                      }
                      if (_failure.isEmpty) {
                        BotToast.showText(text: "Please select Failure");
                        return;
                      }
                      if (_repair.isEmpty) {
                        BotToast.showText(text: "Please select Repair");
                        return;
                      }

                      if (_selectedImage == null ||
                          _selectedContextImage == null) {
                        BotToast.showText(text: "Please upload an image");
                        return;
                      }

                      context.read<InspectionsBloc>().add(
                            PostJobInspectionsDamages(
                              isAsync: false,
                              data: InspectionDamagePostModel(
                                damageImage: _selectedImage,
                                contextImage: _selectedContextImage,
                                jobInspectionId: widget.jobInspectionId,
                                categoryId: state.getDamageCategoriesResponse
                                        .firstWhere((element) =>
                                            element?.name == _category)!
                                        .id ??
                                    1,
                                partId: state.getDamagePartsResponse
                                        .firstWhere(
                                            (element) => element.name == _part)
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

                      state.getDamageCategoriesResponse.clear();
                      state.getDamagePartsResponse.clear();
                      state.getDamageIssuesResponse.clear();
                      state.getDamageFailuresResponse.clear();
                      state.getDamageRepairsResponse.clear();

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

  Future<void> _showImagePickerDialog(
      BuildContext context, bool isContextImage) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: context.theme.colorScheme.surface,
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
                    style: context.textTheme.headlineMedium?.copyWith(
                        color: context.theme.colorScheme.primary, fontSize: 20),
                  ),
                  Column(
                    children: [
                      CustomGreyAppButton(
                        textColor: context.theme.colorScheme.primary,
                        text: "Open Camera",
                        containerColor: context.theme.colorScheme.surface,
                        ontap: () async {
                          _getImage(ImageSource.camera).then((value) {
                            if (value != null) {
                              if (isContextImage) {
                                setState(() {
                                  _selectedContextImage = value;
                                });
                              } else {
                                setState(() {
                                  _selectedImage = value;
                                });
                              }
                            }
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      const VerticalSpace.xxSmall(),
                      CustomGreyAppButton(
                        textColor: context.theme.colorScheme.primary,
                        text: " Pick From Gallery",
                        containerColor: context.theme.colorScheme.surface,
                        ontap: () {
                          _getImage(ImageSource.gallery).then((value) {
                            if (value != null) {
                              if (isContextImage) {
                                setState(() {
                                  _selectedContextImage = value;
                                });
                              } else {
                                setState(() {
                                  _selectedImage = value;
                                });
                              }
                            }
                          });
                          Navigator.of(context).pop();
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
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: Colors.red,
                      ),
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
