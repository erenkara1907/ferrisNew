// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/presentation/bloc/inspections_bloc.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/widget/button/custom_grey_app_button.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_horizontal_spacer.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';

import '../../../home/data/models/damages/damage_response_model.dart';

class InspectionDetailPage extends StatefulWidget {
  final JobInspectionResponseModelItem inspection;
  final DamageResponseModel? damageResponse;
  const InspectionDetailPage({
    Key? key,
    required this.inspection,
    this.damageResponse,
  }) : super(key: key);

  @override
  State<InspectionDetailPage> createState() => _InspectionDetailPageState();
}

class _InspectionDetailPageState extends State<InspectionDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<InspectionsBloc>().add(SetEditDetails(
        fuelLevel: widget.inspection.fuelLevel ?? 0,
        odo: widget.inspection.odoReading != null ? double.parse(widget.inspection.odoReading.toString()) : 0));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InspectionsBloc, InspectionsState>(
      builder: (context, state) {
        final bool isSigned = ProductStateItems.hiveDatabaseManager.getUserModel()!.inspectionsSign != null &&
            ProductStateItems.hiveDatabaseManager.getUserModel()!.inspectionsSign!.contains(widget.inspection.id);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: context.theme.colorScheme.surface,
            title: Text('Inspection Detail', style: context.textTheme.titleSmall),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const VerticalSpace.medium(),
              JobInspectionDetailWidget(
                inspection: widget.inspection,
                state: state,
                damageResponse: widget.damageResponse,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomGreyAppButton(
                      width: context.dynamicWidth(0.44),
                      textColor: context.theme.colorScheme.primary,
                      text: "Edit Details",
                      containerColor: context.theme.colorScheme.onSurfaceVariant,
                      ontap: () {
                        context.push("/edit_details_page", extra: {
                          "jobInspectionId": widget.inspection.id,
                          "inspection": widget.inspection,
                          "odo": widget.inspection.odoReading == null
                              ? state.odo == 0
                                  ? ''
                                  : "${state.odo.toInt()}"
                              : "${state.odo == 0 ? widget.inspection.odoReading!.toInt() : state.odo.toInt()}",
                          "fuelLevel": widget.inspection.fuelLevel == null
                              ? state.fuelLevel == 0
                                  ? 0
                                  : state.fuelLevel
                              : state.fuelLevel == 0
                                  ? widget.inspection.fuelLevel
                                  : state.fuelLevel,
                        });
                      }),
                  const HorizontalSpace.xSmall(),
                  CustomGreyAppButton(
                      width: context.dynamicWidth(0.44),
                      textColor: context.theme.colorScheme.primary,
                      text: "Condition Images",
                      containerColor: context.theme.colorScheme.onSurfaceVariant,
                      ontap: () {
                        context.push("/condition_image_page", extra: {
                          "jobInspectionId": widget.inspection.id,
                        });
                      }),
                ],
              ),
              const VerticalSpace.xxSmall(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomGreyAppButton(
                      width: context.dynamicWidth(0.44),
                      textColor: context.theme.colorScheme.primary,
                      text: "Item Checklist",
                      containerColor: context.theme.colorScheme.onSurfaceVariant,
                      ontap: () {
                        context.push("/item_checklist_page", extra: {
                          "inspectionId": widget.inspection.id,
                        });
                      }),
                  const HorizontalSpace.xSmall(),
                  CustomGreyAppButton(
                      width: context.dynamicWidth(0.44),
                      textColor: context.theme.colorScheme.primary,
                      text: "Damages",
                      containerColor: context.theme.colorScheme.onSurfaceVariant,
                      ontap: () {
                        context.push("/recorded_damages_page", extra: {
                          "jobInspectionId": widget.inspection.id,
                          "standardIds": widget.inspection.damageStandards ?? [],
                        });
                      }),
                ],
              ),
              const VerticalSpace.xxSmall(),
              if (!isSigned)
                CustomGreyAppButton(
                    width: context.dynamicWidth(0.91),
                    textColor: context.theme.colorScheme.primary,
                    text: "Sign Inspection",
                    containerColor: context.theme.colorScheme.onSurfaceVariant,
                    ontap: () {
                      context.push("/sign_inspection_page", extra: {
                        "inspection": widget.inspection,
                      });
                    }),
            ],
          ),
        );
      },
    );
  }
}

class JobInspectionDetailWidget extends StatelessWidget {
  final JobInspectionResponseModelItem inspection;
  final InspectionsState state;
  final DamageResponseModel? damageResponse;
  const JobInspectionDetailWidget({
    Key? key,
    required this.inspection,
    required this.state,
    this.damageResponse,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final gradeText = (inspection.gradleItem != null && state.damageResponse.isNotEmpty

    //     ? inspection.gradleItem!.name
    //     : state.damageResponse.isNotEmpty
    //         ? state.damageResponse[state.damageResponse.length - 1].gradeId ??
    //             "-"
    //         : "-");

    final gradeText = state.gradeId != "" && state.gradeId != "0"
        ? state.gradeId
        : inspection.gradleItem != null
            ? inspection.gradleItem!.name != "0"
                ? inspection.gradleItem!.name
                : "-"
            : "-";

    late String formattedDate = formatDate(inspection.date!);
    final bool isSigned = ProductStateItems.hiveDatabaseManager.getUserModel()!.inspectionsSign != null &&
        ProductStateItems.hiveDatabaseManager.getUserModel()!.inspectionsSign!.contains(inspection.id);
    return Padding(
      padding: context.paddingAllDefault,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.theme.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: context.paddingAllDefault,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(inspection.typeId?.name ?? '',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  const VerticalSpace.xxSmall(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedDate ?? '',
                        style: context.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        inspection.time ?? '',
                        style: context.textTheme.bodySmall?.copyWith(),
                      )
                    ],
                  ),
                  const VerticalSpace.small(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Grade',
                        style: context.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        // inspection.gradleItem != null
                        //     ? inspection.gradleItem!.name ?? "-"
                        //     : "-",
                        gradeText ?? "-",
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const VerticalSpace.xxSmall(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ODO',
                        style: context.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        inspection.odoReading == null || inspection.odoReading == 0
                            ? state.odo == 0
                                ? '-'
                                : "${state.odo.toInt()} Miles"
                            : "${state.odo == 0 ? inspection.odoReading!.toInt() : state.odo.toInt()} Miles",
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const VerticalSpace.xxSmall(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Fuel Level',
                        style: context.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        inspection.fuelLevel == null || inspection.fuelLevel == 0
                            ? state.fuelLevel == 0
                                ? '-'
                                : "${state.fuelLevel.toString()}%"
                            : '${state.fuelLevel == 0 ? inspection.fuelLevel : state.fuelLevel}%',
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const VerticalSpace.xxSmall(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Abort Type',
                        style: context.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(inspection.abortType != null ? inspection.abortType!.name ?? '-' : '-',
                          style: context.textTheme.bodySmall),
                    ],
                  ),
                  const VerticalSpace.xxSmall(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      inspection.reportSigned == 1 || isSigned ? 'Signed' : 'Unsigned',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: inspection.reportSigned == 1 || isSigned ? Colors.purple : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalSpace.xSmall(),
        ],
      ),
    );
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    return dateFormat.format(dateTime);
  }
}
