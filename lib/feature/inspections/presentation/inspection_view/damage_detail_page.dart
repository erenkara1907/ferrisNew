import 'dart:io';

import 'package:ferrisfwt/feature/home/data/models/damages/damage_response_model.dart';
import 'package:ferrisfwt/feature/inspections/presentation/bloc/inspections_bloc.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/edit_details_page.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_post_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

class DamageDetailPage extends StatefulWidget {
  final int jobInspectionId;
  final DamageResponseModel damageResponse;
  final List<int> standarIds;
  const DamageDetailPage({
    super.key,
    required this.damageResponse,
    required this.jobInspectionId,
    required this.standarIds,
  });

  @override
  State<DamageDetailPage> createState() => _DamageDetailPageState();
}

class _DamageDetailPageState extends State<DamageDetailPage> {
  InspectionDamagePostModel? updateModel;
  bool isEditButton = false;
  String _category = "";
  String _part = "";
  String _issue = "";
  String _failure = "";
  String _repair = "";
  String? _selectedImage;
  String? _selectedContextImage;
  @override
  void initState() {
    // context
    //     .read<InspectionsBloc>()
    //     .add(GetInspectionsDamageCategories(widget.jobInspectionId));
    // context.read<InspectionsBloc>().add(const GetInspectionsDamageCategories());
    context
        .read<InspectionsBloc>()
        .add(GetInspectionsDamageAssets(standardIds: widget.standarIds));

    _category = widget.damageResponse.categoryId.name;
    _part = widget.damageResponse.partId.name;
    _issue = widget.damageResponse.issueId.name;
    _failure = widget.damageResponse.failureId.name;
    _repair = widget.damageResponse.repairId.name;

    // print('damage detail page${widget.damageResponse.damageImage}');
    getImage();

    super.initState();
  }

  Future<void> getImage() async {
    final directory = (await getApplicationDocumentsDirectory()).path;

    final pathImage = widget.damageResponse.damageImage ?? "";

    final pathContextImage = widget.damageResponse.contextImage ?? "";
    if (ProductStateItems.hiveStorageManager
            .getRecordedDamageById(
                id: widget.damageResponse.categoryId.id,
                inspectionsId: widget.damageResponse.jobInspectionId)!
            .damageImage ==
        null) {
      int documentsIndex = pathImage.indexOf("Documents/");

      String result = pathImage.substring(documentsIndex + "Documents/".length);

      final path = '$directory/$result';
      _selectedImage = path;
    } else {
      final String path = ProductStateItems.hiveStorageManager
          .getRecordedDamageById(
              id: widget.damageResponse.categoryId.id,
              inspectionsId: widget.damageResponse.jobInspectionId)!
          .damageImage!
          .path;
      int documentsIndex = path.indexOf("Documents/");

      String result = path.substring(documentsIndex + "Documents/".length);
      // print("documentsIndex: $result");
      final pathLast = '$directory/$result';
      _selectedImage = pathLast;
    }
    if (ProductStateItems.hiveStorageManager
            .getRecordedDamageById(
                id: widget.damageResponse.categoryId.id,
                inspectionsId: widget.damageResponse.jobInspectionId)!
            .contextImage ==
        null) {
      int documentsIndex = pathContextImage.indexOf("Documents/");
      String result =
          pathContextImage.substring(documentsIndex + "Documents/".length);
      final path = '$directory/$result';
      _selectedContextImage = path;
    } else {
      final String path = ProductStateItems.hiveStorageManager
          .getRecordedDamageById(
              id: widget.damageResponse.categoryId.id,
              inspectionsId: widget.damageResponse.jobInspectionId)!
          .contextImage!
          .path;
      int documentsIndex = path.indexOf("Documents/");
      String result = path.substring(documentsIndex + "Documents/".length);
      final pathLast = '$directory/$result';
      _selectedContextImage = pathLast;
    }

    setState(() {});
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

        if (_selectedContextImage == null || _selectedImage == null) {
          return const Scaffold(
            body: Center(
              child: LoadingProgress(),
            ),
          );
        }

        // print("selected image: $_selectedImage");
        // print("selected context image: $_selectedContextImage");

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
                    hintText: _category ?? '',
                    items: state.getDamageCategoriesResponse
                        .map((e) => DropdownMenuItem(
                              value: e?.name,
                              child: Text(e?.name ?? ""),
                            ))
                        .toList(),
                    text: "Category",
                    onChanged: null,
                    // onChanged: (String) {
                    //   if (_category != "") {
                    //     context.read<InspectionsBloc>().add(const CleanDamages(
                    //           isCategory: true,
                    //         ));
                    //     setState(() {
                    //       _part = "";
                    //       _issue = "";
                    //       _failure = "";
                    //       _repair = "";
                    //     });
                    //   }
                    //   setState(() {
                    //     _category = String ?? "";
                    //   });
                    //   final int id = state.getDamageCategoriesResponse
                    //       .firstWhere((element) => element?.name == String)!
                    //       .id;
                    //   context
                    //       .read<InspectionsBloc>()
                    //       .add(GetInspectionsDamagesPart(id));
                    // },
                    textSpanEnable: true,
                  ),
                  const VerticalSpace.small(),
                  DropdownButtonWidget(
                    hintText: _part ?? '',
                    items: state.getDamagePartsResponse
                        .map((e) => DropdownMenuItem(
                              value: e.name,
                              child: Text(e.name ?? ""),
                            ))
                        .toList(),
                    text: "Part",
                    onChanged: null,
                    // onChanged: (String) {
                    //   if (_part != "") {
                    //     context.read<InspectionsBloc>().add(const CleanDamages(
                    //           isPart: true,
                    //         ));
                    //     setState(() {
                    //       _issue = "";
                    //       _failure = "";
                    //       _repair = "";
                    //     });
                    //   }
                    //   setState(() {
                    //     _part = String ?? "";
                    //   });
                    //   final int id = state.getDamagePartsResponse
                    //       .firstWhere((element) => element.name == String)
                    //       .id;

                    //   context
                    //       .read<InspectionsBloc>()
                    //       .add(GetInspectionsDamagesIssue(id));
                    // },
                    textSpanEnable: true,
                  ),
                  const VerticalSpace.small(),
                  DropdownButtonWidget(
                    hintText: _issue ?? '',
                    items: state.getDamageIssuesResponse
                        .map((e) => DropdownMenuItem(
                              value: e.name,
                              child: Text(e.name ?? ""),
                            ))
                        .toList(),
                    text: "Issue",
                    onChanged: null,
                    // onChanged: (String) {
                    //   if (_issue != "") {
                    //     context.read<InspectionsBloc>().add(const CleanDamages(
                    //           isIssue: true,
                    //         ));
                    //     setState(() {
                    //       _failure = "";
                    //       _repair = "";
                    //     });
                    //   }
                    //   setState(() {
                    //     _issue = String ?? "";
                    //   });
                    //   final int id = state.getDamageIssuesResponse
                    //       .firstWhere((element) => element.name == String)
                    //       .id;

                    //   context
                    //       .read<InspectionsBloc>()
                    //       .add(GetInspectionsDamagesFailure(id));
                    // },
                    textSpanEnable: true,
                  ),
                  const VerticalSpace.small(),
                  DropdownButtonWidget(
                    hintText: _failure,
                    items: state.getDamageFailuresResponse
                        .map((e) => DropdownMenuItem(
                              value: e.name,
                              child: Text(e.name ?? ""),
                            ))
                        .toList(),
                    text: "Failure",
                    onChanged: null,
                    // onChanged: (String) {
                    //   if (_failure != "") {
                    //     context.read<InspectionsBloc>().add(const CleanDamages(
                    //           isFailure: true,
                    //         ));
                    //     setState(() {
                    //       _repair = "";
                    //     });
                    //   }
                    //   setState(() {
                    //     _failure = String ?? "";
                    //   });
                    //   final int id = state.getDamageFailuresResponse
                    //       .firstWhere((element) => element.name == String)
                    //       .id;

                    //   context
                    //       .read<InspectionsBloc>()
                    //       .add(GetInspectionsDamagesRepair(id));
                    // },
                    textSpanEnable: true,
                  ),
                  const VerticalSpace.small(),
                  DropdownButtonWidget(
                    hintText: _repair,
                    items: state.getDamageRepairsResponse
                        .map((e) => DropdownMenuItem(
                              value: e.name,
                              child: Text(e.name ?? ""),
                            ))
                        .toList(),
                    text: "Repair",
                    onChanged: null,
                    // onChanged: (String) {
                    //   setState(() {
                    //     _repair = String ?? "";
                    //   });
                    // },
                    textSpanEnable: true,
                  ),
                  const VerticalSpace.small(),
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
                      // InkWell(
                      //   child: SvgPicture.asset(
                      //     width: context.width,
                      //     "assets/images/Dropzone.svg",
                      //   ),
                      //   onTap: () {
                      //     _showImagePickerDialog(context, false);
                      //   },
                      // ),
                    ],
                  ),
                  const VerticalSpace.xSmall(),
                  if (_selectedImage != null)
                    Stack(
                      children: [
                        SizedBox(
                            height: context.dynamicHeight(0.15),
                            width: context.dynamicWidth(0.35),
                            child: Image.file(
                              File(_selectedImage!),
                              fit: BoxFit.cover,
                            )),
                        // Positioned(
                        //   top: 0,
                        //   right: 0,
                        //   child: IconButton(
                        //     icon: Icon(
                        //       Icons.cancel_outlined,
                        //       color: context.theme.colorScheme.error,
                        //     ),
                        //     onPressed: () {
                        //       setState(() {
                        //         _selectedImage = null;
                        //       });
                        //     },
                        //   ),
                        // ),
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
                      // InkWell(
                      //   child: SvgPicture.asset(
                      //     width: context.width,
                      //     "assets/images/Dropzone.svg",
                      //   ),
                      //   onTap: () {
                      //     _showImagePickerDialog(context, true);
                      //   },
                      // ),
                    ],
                  ),
                  const VerticalSpace.xSmall(),
                  if (_selectedContextImage != null)
                    Stack(
                      children: [
                        SizedBox(
                            height: context.dynamicHeight(0.15),
                            width: context.dynamicWidth(0.35),
                            child: Image.file(
                              File(_selectedContextImage!),
                              fit: BoxFit.cover,
                            )),
                        // Positioned(
                        //   top: 0,
                        //   right: 0,
                        //   child: IconButton(
                        //     icon: Icon(
                        //       Icons.cancel_outlined,
                        //       color: context.theme.colorScheme.error,
                        //     ),
                        //     onPressed: () {
                        //       setState(() {
                        //         _selectedContextImage = null;
                        //       });
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  const VerticalSpace.large(),
                ]),
          )),
        );
      },
    );
  }
}
