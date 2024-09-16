// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:ferrisfwt/feature/home/data/models/damages/damage_response_model.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/presentation/bloc/inspections_bloc.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/mixin/network_mixin.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';

class InspectionCustomInfoCard extends StatelessWidget {
  final JobInspectionResponseModelItem inspection;
  final DamageResponseModel? damageResponse;
  final InspectionsState inspectionState;

  const InspectionCustomInfoCard({
    Key? key,
    required this.inspection,
    this.damageResponse,
    required this.inspectionState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = _formatDate(inspection.date!);
    // final gradeText = (damageResponse != null &&
    //         damageResponse!.gradeId != null &&
    //         damageResponse!.gradeId!.isNotEmpty)
    //     ? damageResponse!.gradeId
    //     : (inspection.gradleItem != null ? inspection.gradleItem!.name : "-");

    final gradeText = inspection.gradleItem != null
        ? inspection.gradleItem!.name != "0"
            ? inspection.gradleItem!.name
            : "-"
        : "-";

    final bool isSigned = ProductStateItems.hiveDatabaseManager.getUserModel()!.inspectionsSign != null &&
        ProductStateItems.hiveDatabaseManager.getUserModel()!.inspectionsSign!.contains(inspection.id);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.status == ViewStatus.loading) {
          return const Center(
            child: LoadingProgress(),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            var connectivityResult = await hasNetwork();
            if (connectivityResult) {
              context.read<InspectionsBloc>().add(GetJobInspections(
                    jobId: context.read<HomeBloc>().state.showJob!.id,
                  ));
            }
          },
          child: InkWell(
            onTap: () {
              context.push(
                '/inspection_detail_page',
                extra: {
                  'inspection': inspection,
                  'damageResponse': damageResponse,
                },
              );

              if (inspectionState.damageResponse.isNotEmpty) {
                inspectionState.damageResponse.clear();
              }
            },
            child: Padding(
              padding: context.paddingAllDefault,
              child: Container(
                decoration: BoxDecoration(
                  color: isSigned || inspection.reportSigned == true
                      ? const Color.fromARGB(255, 71, 214, 66)
                      : context.theme.colorScheme.onSurfaceVariant,
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
                              ))
                        ],
                      ),
                      const VerticalSpace.xxSmall(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate,
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
                            gradeText ?? "-",
                            style: context.textTheme.bodySmall,
                          ),
                          // if (damageResponse != null)
                          //   if (damageResponse!.gradeId != null &&
                          //       damageResponse!.gradeId!.isNotEmpty)
                          //     Text(
                          //       damageResponse!.gradeId ?? "-",
                          //       style: context.textTheme.bodySmall,
                          //     ),
                          // if (damageResponse == null)
                          //   Text(
                          //     inspection.gradleItem == null
                          //         ? "-"
                          //         : inspection.gradleItem!.name ?? "",
                          //     style: context.textTheme.bodySmall,
                          //   ),
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
                            // odoText,
                            inspection.odoReading != null && inspection.odoReading != 0
                                ? "${inspection.odoReading!.toInt()} Miles"
                                : "-",
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
                            inspection.fuelLevel != null && inspection.fuelLevel != 0
                                ? '${inspection.fuelLevel}%'
                                : "-",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sign',
                            style: context.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            inspection.reportSigned == true || isSigned ? 'Signed' : 'Unsigned',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: inspection.reportSigned == true || isSigned ? Colors.purple : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    return dateFormat.format(dateTime);
  }
}

// Card for inspection success UI
class InspectionSucsessCustomInfoCard extends StatelessWidget {
  const InspectionSucsessCustomInfoCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/inspection_detail_page');
      },
      child: Padding(
        padding: context.paddingAllDefault,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: context.paddingAllDefault,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Collect From Customer",
                      style: context.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600, color: context.theme.colorScheme.onSurfaceVariant),
                    )
                  ],
                ),
                const VerticalSpace.xxSmall(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '15th Apr 2024',
                      style: context.textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600, color: context.theme.colorScheme.onSurfaceVariant),
                    ),
                    Text(
                      '10:15',
                      style: context.textTheme.bodySmall?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
                    )
                  ],
                ),
                const VerticalSpace.small(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ODO',
                      style: context.textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600, color: context.theme.colorScheme.onSurfaceVariant),
                    ),
                    Text(
                      '11 Miles',
                      style: context.textTheme.bodySmall?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                const VerticalSpace.xxSmall(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Fuel Level',
                      style: context.textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600, color: context.theme.colorScheme.onSurfaceVariant),
                    ),
                    Text(
                      '%20',
                      style: context.textTheme.bodySmall?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                const VerticalSpace.xxSmall(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Abort Type',
                      style: context.textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600, color: context.theme.colorScheme.onSurfaceVariant),
                    ),
                    Text(
                      '-',
                      style: context.textTheme.bodySmall?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                const VerticalSpace.small(),
                Container(
                  width: context.dynamicWidth(0.2),
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: context.paddingAllDefault,
                    child: Center(
                      child: Text(
                        'Sign',
                        style: context.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600, color: context.theme.colorScheme.primaryContainer),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
