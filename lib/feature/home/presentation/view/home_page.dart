// ignore_for_file: unused_local_variable

import 'package:bot_toast/bot_toast.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/view/tab_view/today_jobs_view.dart';
import 'package:ferrisfwt/feature/home/presentation/view/tab_view/tomorrow_jobs_view.dart';
import 'package:ferrisfwt/product/database/hive/core/hive_database_manager.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/mixin/network_mixin.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_horizontal_spacer.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/data/models/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.status == ViewStatus.loading) {
          return const Center(
            child: LoadingProgress(),
          );
        }
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            body: Padding(
              padding: context.paddingAllDefault,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const VerticalSpace.medium(),
                  HomeTextfieldSearchWidget(),
                  const VerticalSpace.xSmall(),
                  Text("Jobs list",
                      style: context.textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const VerticalSpace.xSmall(),
                  Container(
                    height: 41,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      indicatorColor: const Color.fromARGB(0, 156, 115, 115),
                      controller: _tabController,
                      labelStyle: context.textTheme.bodySmall?.copyWith(
                        color: context.theme.colorScheme.surface,
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: context.theme.colorScheme.primaryContainer,
                      ),
                      tabs: const [
                        Tab(text: 'Today'),
                        Tab(text: 'Tomorrow'),
                      ],
                    ),
                  ),
                  const VerticalSpace.small(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        TodayJobsView(
                          homeState: state,
                        ),
                        TomorrowJobsView(
                          homeState: state,
                        )
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

class HomeTextfieldSearchWidget extends StatelessWidget {
  TextEditingController? controller;

  HomeTextfieldSearchWidget({
    this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          context.push('/search_page');
        },
        child: Container(
            height: 41,
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: context.theme.colorScheme.outline,
                ),
                Text(
                  "Search a Job",
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.theme.colorScheme.outline,
                  ),
                ),
              ],
            )));
  }
}

class HomeSearchTextfieldSearchWidget extends StatelessWidget {
  TextEditingController? controller;

  HomeSearchTextfieldSearchWidget({
    this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search a Job',
          hintStyle: context.textTheme.bodyLarge?.copyWith(
            color: context.theme.colorScheme.outline,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: context.theme.colorScheme.outline,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

Color determineColor(
  BuildContext context,
  JobsResponseModelItem jobModel,
) {
  final result =
      ProductStateItems.hiveDatabaseManager.getUserModel()?.isStarted;
  if (jobModel.status == 2) {
    return context.theme.colorScheme.surface;
  } else {
    return context.theme.colorScheme.onPrimary;
  }
}

Color determineContainerColor(
  BuildContext context,
  JobsResponseModelItem jobModel,
) {
  final result =
      ProductStateItems.hiveDatabaseManager.getUserModel()?.currentJobId ==
          jobModel.id.toString();
  if (jobModel.status == 1 || result == true) {
    return const Color.fromARGB(255, 71, 214, 66);
  } else if (jobModel.status == 2) {
    return context.theme.colorScheme.primaryContainer;
  } else {
    return context.theme.colorScheme.surface;
  }
}

Color determineReplaceColor(
  BuildContext context,
  JobsResponseModelItem jobModel,
) {
  if (jobModel.status == 0 || jobModel.status == 2) {
    return context.theme.colorScheme.primaryContainer;
  } else {
    return const Color.fromARGB(255, 71, 214, 66);
  }
}

Color determineTextColor(
  BuildContext context,
  JobsResponseModelItem jobModel,
) {
  final result =
      ProductStateItems.hiveDatabaseManager.getUserModel()?.currentJobId ==
          jobModel.id.toString();
  if (jobModel.status == 2) {
    return context.theme.colorScheme.onSecondary;
  } else if (jobModel.status == 0 && result != true) {
    return context.theme.colorScheme.primary;
  } else {
    return context.theme.colorScheme.onSecondary;
  }
}

class CustomCard extends StatelessWidget {
  final JobsResponseModelItem jobModel;
  final void Function(bool?)? onChanged;
  final bool isToday;
  final bool isDetail;

  const CustomCard({
    super.key,
    required this.jobModel,
    this.isToday = true,
    this.isDetail = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isToday
          ? () async {
              BotToast.showLoading();
              final result = await hasNetwork();
              if (context.mounted) {
                if (jobModel.status == 1) {
                  print("GİRİRİR");
                  // ignore: no_leading_underscores_for_local_identifiers
                  final HiveDatabaseManager _hiveDatabaseManager =
                      HiveDatabaseManager();
                  final HiveStorageManager hiveStorageManager =
                      HiveStorageManager();
                  _hiveDatabaseManager.saveJob(
                      jobModel.id.toString(), jobModel.regNumber!);
                  hiveStorageManager.setJobWorkingOn(jobModel);
                }
                context.push('/job_detail_page', extra: {
                  'jobId': jobModel.id.toString(),
                  'asyncJob': !result,
                  'isCameHomePage': true,
                });
              }
              BotToast.closeAllLoading();
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: isDetail
              ? context.theme.colorScheme.surface
              : determineContainerColor(
                  context,
                  jobModel,
                ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: context.paddingAllDefault,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    jobModel.vehicleId!.name.toString(),
                    style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: isDetail
                            ? context.theme.colorScheme.onSurface
                            : determineTextColor(
                                context,
                                jobModel,
                              )),
                  ),
                  const Spacer(),
                  Text(
                    jobModel.regNumber.toString(),
                    style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDetail
                            ? context.theme.colorScheme.onSurface
                            : determineTextColor(
                                context,
                                jobModel,
                              )),
                  ),
                ],
              ),
              const VerticalSpace.xxSmall(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(jobModel.movementTypeId?.name ?? "",
                      style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDetail
                              ? context.theme.colorScheme.onSurface
                              : determineTextColor(
                                  context,
                                  jobModel,
                                ))),
                  if (isToday && jobModel.isDriverConfirm == true)
                    Icon(Icons.check_circle,
                        color: isDetail
                            ? context.theme.colorScheme.onSurface
                            : determineTextColor(
                                context,
                                jobModel,
                              ))
                  else
                    const SizedBox(),
                ],
              ),
              const VerticalSpace.small(),
              if (jobModel.isVisibleStartAddress == true &&
                  jobModel.startAddress != null)
                buildAddressRow(
                  context,
                  jobModel.startAddress!,
                  jobModel.startAddressPostalCode!,
                  isLast: !jobModel.isVisibleCheckpoint1Address! &&
                      !jobModel.isVisibleCheckpoint2Address! &&
                      !jobModel.isVisibleCheckpoint3Address! &&
                      !jobModel.isVisibleEndAddress!,
                ),
              if (jobModel.isVisibleCheckpoint1Address == true &&
                  jobModel.checkpoint1Address != null)
                buildAddressRow(
                  context,
                  jobModel.checkpoint1Address!,
                  jobModel.checkpoint1AddressPostalCode!,
                  isLast: !jobModel.isVisibleCheckpoint2Address! &&
                      !jobModel.isVisibleCheckpoint3Address! &&
                      !jobModel.isVisibleEndAddress!,
                ),
              if (jobModel.isVisibleCheckpoint2Address == true &&
                  jobModel.checkpoint2Address != null)
                buildAddressRow(
                  context,
                  jobModel.checkpoint2Address!,
                  jobModel.checkpoint2AddressPostalCode!,
                  isLast: !jobModel.isVisibleCheckpoint3Address! &&
                      !jobModel.isVisibleEndAddress!,
                ),
              if (jobModel.isVisibleCheckpoint3Address == true &&
                  jobModel.checkpoint3Address != null)
                buildAddressRow(
                  context,
                  jobModel.checkpoint3Address!,
                  jobModel.checkpoint3AddressPostalCode!,
                  isLast: !jobModel.isVisibleEndAddress!,
                ),
              if (jobModel.isVisibleEndAddress == true &&
                  jobModel.endAddress != null)
                buildAddressRow(
                  context,
                  jobModel.endAddress!,
                  jobModel.endAddressPostalCode!,
                  isLast: true,
                ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Row(
              //       children: [
              //         Column(
              //           children: [
              //             // TODO POINTS
              //             Container(
              //               height: context.dynamicHeight(0.013),
              //               width: context.dynamicWidth(0.022),
              //               decoration: BoxDecoration(
              //                 color: isDetail
              //                     ? context.theme.colorScheme.onSurface
              //                     : determineTextColor(
              //                         context,
              //                         jobModel,
              //                       ),
              //                 borderRadius: BorderRadius.circular(4),
              //                 border: Border.all(
              //                   color: isDetail
              //                       ? context.theme.colorScheme.onSurface
              //                       : determineTextColor(
              //                           context,
              //                           jobModel,
              //                         ),
              //                 ),
              //               ),
              //             ),

              //             //CheckPoint 1
              //             if (jobModel.isVisibleCheckpoint1Address == true) ...[
              //               Container(
              //                 height: context.dynamicHeight(0.05),
              //                 width: 2,
              //                 color: isDetail
              //                     ? context.theme.colorScheme.onSurface
              //                     : determineTextColor(
              //                         context,
              //                         jobModel,
              //                       ),
              //               ),
              //               Container(
              //                 height: context.dynamicHeight(0.013),
              //                 width: context.dynamicWidth(0.022),
              //                 decoration: BoxDecoration(
              //                   color: isDetail
              //                       ? context.theme.colorScheme.onSurface
              //                       : determineTextColor(
              //                           context,
              //                           jobModel,
              //                         ),
              //                   borderRadius: BorderRadius.circular(4),
              //                   border: Border.all(
              //                     color: isDetail
              //                         ? context.theme.colorScheme.onSurface
              //                         : determineTextColor(
              //                             context,
              //                             jobModel,
              //                           ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //             //CheckPoint 2
              //             if (jobModel.isVisibleCheckpoint2Address == true) ...[
              //               Container(
              //                 height: context.dynamicHeight(0.05),
              //                 width: 2,
              //                 color: isDetail
              //                     ? context.theme.colorScheme.onSurface
              //                     : determineTextColor(
              //                         context,
              //                         jobModel,
              //                       ),
              //               ),
              //               Container(
              //                 height: context.dynamicHeight(0.013),
              //                 width: context.dynamicWidth(0.022),
              //                 decoration: BoxDecoration(
              //                   color: isDetail
              //                       ? context.theme.colorScheme.onSurface
              //                       : determineTextColor(
              //                           context,
              //                           jobModel,
              //                         ),
              //                   borderRadius: BorderRadius.circular(4),
              //                   border: Border.all(
              //                     color: isDetail
              //                         ? context.theme.colorScheme.onSurface
              //                         : determineTextColor(
              //                             context,
              //                             jobModel,
              //                           ),
              //                   ),
              //                 ),
              //               ),
              //             ],

              //             //CheckPoint 3
              //             if (jobModel.isVisibleCheckpoint3Address == true) ...[
              //               Container(
              //                 height: context.dynamicHeight(0.05),
              //                 width: 2,
              //                 color: isDetail
              //                     ? context.theme.colorScheme.onSurface
              //                     : determineTextColor(
              //                         context,
              //                         jobModel,
              //                       ),
              //               ),
              //               Container(
              //                 height: context.dynamicHeight(0.013),
              //                 width: context.dynamicWidth(0.022),
              //                 decoration: BoxDecoration(
              //                   color: isDetail
              //                       ? context.theme.colorScheme.onSurface
              //                       : determineTextColor(
              //                           context,
              //                           jobModel,
              //                         ),
              //                   borderRadius: BorderRadius.circular(4),
              //                   border: Border.all(
              //                     color: isDetail
              //                         ? context.theme.colorScheme.onSurface
              //                         : determineTextColor(
              //                             context,
              //                             jobModel,
              //                           ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //             Container(
              //               height: context.dynamicHeight(jobModel.isVisibleCheckpoint1Address == false &&
              //                       jobModel.isVisibleCheckpoint2Address ==
              //                           false &&
              //                       jobModel.isVisibleCheckpoint3Address ==
              //                           false
              //                   ? 0.04
              //                   : jobModel.isVisibleCheckpoint1Address == false &&
              //                           jobModel.isVisibleCheckpoint2Address ==
              //                               false &&
              //                           jobModel.isVisibleCheckpoint3Address ==
              //                               true
              //                       ? 0.065
              //                       : jobModel.isVisibleCheckpoint1Address == false &&
              //                               jobModel.isVisibleCheckpoint2Address ==
              //                                   true &&
              //                               jobModel.isVisibleCheckpoint3Address ==
              //                                   true
              //                           ? 0.05
              //                           : jobModel.isVisibleCheckpoint1Address == true &&
              //                                   jobModel.isVisibleCheckpoint2Address ==
              //                                       false &&
              //                                   jobModel.isVisibleCheckpoint3Address ==
              //                                       true
              //                               ? 0.06
              //                               : jobModel.isVisibleCheckpoint1Address == true &&
              //                                       jobModel.isVisibleCheckpoint2Address ==
              //                                           false &&
              //                                       jobModel.isVisibleCheckpoint3Address ==
              //                                           false
              //                                   ? 0.06
              //                                   : jobModel.isVisibleCheckpoint1Address == true &&
              //                                           jobModel.isVisibleCheckpoint2Address ==
              //                                               true &&
              //                                           jobModel.isVisibleCheckpoint3Address ==
              //                                               false
              //                                       ? 0.16
              //                                       : jobModel.isVisibleCheckpoint1Address == false &&
              //                                               jobModel.isVisibleCheckpoint2Address == true &&
              //                                               jobModel.isVisibleCheckpoint3Address == false
              //                                           ? 0.06
              //                                           : jobModel.isVisibleCheckpoint1Address == true && jobModel.isVisibleCheckpoint2Address == true && jobModel.isVisibleCheckpoint3Address == true
              //                                               ? 0.07
              //                                               : 0.1),
              //               width: 2,
              //               color: isDetail
              //                   ? context.theme.colorScheme.onSurface
              //                   : determineTextColor(
              //                       context,
              //                       jobModel,
              //                     ),
              //             ),
              //             Container(
              //               height: context.dynamicHeight(0.013),
              //               width: context.dynamicWidth(0.022),
              //               decoration: BoxDecoration(
              //                 color: isDetail
              //                     ? context.theme.colorScheme.onSurface
              //                     : determineTextColor(
              //                         context,
              //                         jobModel,
              //                       ),
              //                 borderRadius: BorderRadius.circular(4),
              //                 border: Border.all(
              //                   color: isDetail
              //                       ? context.theme.colorScheme.onSurface
              //                       : determineTextColor(
              //                           context,
              //                           jobModel,
              //                         ),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //         const HorizontalSpace.xSmall(),
              //         SizedBox(
              //           width: context.dynamicWidth(0.75),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   jobModel.isVisibleStartAddress != null &&
              //                           jobModel.isVisibleStartAddress == true
              //                       ? Flexible(
              //                           child: Text(
              //                               jobModel.startAddress.toString(),
              //                               maxLines: 2,
              //                               style: context.textTheme.bodySmall
              //                                   ?.copyWith(
              //                                       color: isDetail
              //                                           ? context
              //                                               .theme
              //                                               .colorScheme
              //                                               .onSurface
              //                                           : determineTextColor(
              //                                               context,
              //                                               jobModel,
              //                                             ))),
              //                         )
              //                       : const SizedBox(),
              //                   jobModel.isVisibleStartAddress != null &&
              //                           jobModel.isVisibleStartAddress == true
              //                       ? Flexible(
              //                           child: Text(
              //                               jobModel.startAddressPostalCode
              //                                   .toString(),
              //                               style: context.textTheme.bodySmall
              //                                   ?.copyWith(
              //                                       color: isDetail
              //                                           ? context
              //                                               .theme
              //                                               .colorScheme
              //                                               .onSurface
              //                                           : determineTextColor(
              //                                               context,
              //                                               jobModel,
              //                                             ))),
              //                         )
              //                       : const SizedBox(),
              //                 ],
              //               ),
              //               jobModel.isVisibleCheckpoint1Address == true
              //                   ? const VerticalSpace.medium()
              //                   : jobModel.isVisibleCheckpoint1Address == false
              //                       ? const VerticalSpace.small()
              //                       : const SizedBox(),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   jobModel.isVisibleCheckpoint1Address != null &&
              //                           jobModel.isVisibleCheckpoint1Address ==
              //                               true
              //                       ? Flexible(
              //                           child: Text(
              //                               jobModel.checkpoint1Address
              //                                   .toString(),
              //                               maxLines: 2,
              //                               style: context.textTheme.bodySmall
              //                                   ?.copyWith(
              //                                       color: isDetail
              //                                           ? context
              //                                               .theme
              //                                               .colorScheme
              //                                               .onSurface
              //                                           : determineTextColor(
              //                                               context,
              //                                               jobModel,
              //                                             ))),
              //                         )
              //                       : const SizedBox(),
              //                   jobModel.isVisibleCheckpoint1Address != null &&
              //                           jobModel.isVisibleCheckpoint1Address ==
              //                               true
              //                       ? Flexible(
              //                           child: Text(
              //                               jobModel.checkpoint1AddressPostalCode !=
              //                                       null
              //                                   ? jobModel
              //                                       .checkpoint1AddressPostalCode
              //                                       .toString()
              //                                   : '',
              //                               style: context.textTheme.bodySmall
              //                                   ?.copyWith(
              //                                       color: isDetail
              //                                           ? context
              //                                               .theme
              //                                               .colorScheme
              //                                               .onSurface
              //                                           : determineTextColor(
              //                                               context,
              //                                               jobModel,
              //                                             ))),
              //                         )
              //                       : const SizedBox(),
              //                 ],
              //               ),
              //               jobModel.isVisibleCheckpoint2Address == true
              //                   ? const VerticalSpace.small()
              //                   : const SizedBox(),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   jobModel.isVisibleCheckpoint2Address != null &&
              //                           jobModel.isVisibleCheckpoint2Address ==
              //                               true
              //                       ? Flexible(
              //                           child: Text(
              //                               jobModel.checkpoint2Address
              //                                   .toString(),
              //                               maxLines: 2,
              //                               style: context.textTheme.bodySmall
              //                                   ?.copyWith(
              //                                       color: isDetail
              //                                           ? context
              //                                               .theme
              //                                               .colorScheme
              //                                               .onSurface
              //                                           : determineTextColor(
              //                                               context,
              //                                               jobModel,
              //                                             ))),
              //                         )
              //                       : const SizedBox(),
              //                   jobModel.isVisibleCheckpoint2Address != null &&
              //                           jobModel.isVisibleCheckpoint2Address ==
              //                               true
              //                       ? Flexible(
              //                           child: Text(
              //                               jobModel.checkpoint2AddressPostalCode !=
              //                                       null
              //                                   ? jobModel
              //                                       .checkpoint2AddressPostalCode
              //                                       .toString()
              //                                   : '',
              //                               style: context.textTheme.bodySmall
              //                                   ?.copyWith(
              //                                       color: isDetail
              //                                           ? context
              //                                               .theme
              //                                               .colorScheme
              //                                               .onSurface
              //                                           : determineTextColor(
              //                                               context,
              //                                               jobModel,
              //                                             ))),
              //                         )
              //                       : const SizedBox(),
              //                 ],
              //               ),
              //               jobModel.isVisibleCheckpoint2Address == true
              //                   ? const VerticalSpace.medium()
              //                   : jobModel.isVisibleCheckpoint3Address ==
              //                               true &&
              //                           jobModel.isVisibleCheckpoint2Address ==
              //                               false &&
              //                           jobModel.isVisibleCheckpoint1Address ==
              //                               false
              //                       ? const VerticalSpace.small()
              //                       : const SizedBox(),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   jobModel.isVisibleCheckpoint3Address != null &&
              //                           jobModel.isVisibleCheckpoint3Address ==
              //                               true
              //                       ? Flexible(
              //                           child: Text(
              //                               jobModel.checkpoint3Address
              //                                   .toString(),
              //                               maxLines: 2,
              // style: context.textTheme.bodySmall
              //     ?.copyWith(
              //         color: isDetail
              //             ? context
              //                 .theme
              //                 .colorScheme
              //                 .onSurface
              //             : determineTextColor(
              //                 context,
              //                 jobModel,
              //               ))),
              //                         )
              //                       : const SizedBox(),
              //                   jobModel.isVisibleCheckpoint3Address != null &&
              //                           jobModel.isVisibleCheckpoint3Address ==
              //                               true
              //                       ? Flexible(
              //                           child: Text(
              //                               jobModel.checkpoint3AddressPostalCode !=
              //                                       null
              //                                   ? jobModel
              //                                       .checkpoint3AddressPostalCode
              //                                       .toString()
              //                                   : '',
              //                               style: context.textTheme.bodySmall
              //                                   ?.copyWith(
              //                                       color: isDetail
              //                                           ? context
              //                                               .theme
              //                                               .colorScheme
              //                                               .onSurface
              //                                           : determineTextColor(
              //                                               context,
              //                                               jobModel,
              //                                             ))),
              //                         )
              //                       : const SizedBox(),
              //                 ],
              //               ),
              //               jobModel.isVisibleCheckpoint3Address == true
              //                   ? const VerticalSpace.medium()
              //                   : const SizedBox(),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Flexible(
              //                     child: Text(
              //                       jobModel.endAddress.toString(),
              //                       maxLines: 2,
              //                       style:
              //                           context.textTheme.bodySmall?.copyWith(
              //                         color: isDetail
              //                             ? context.theme.colorScheme.onSurface
              //                             : determineTextColor(
              //                                 context,
              //                                 jobModel,
              //                               ),
              //                       ),
              //                     ),
              //                   ),
              //                   Flexible(
              //                     child: Text(
              //                         jobModel.endAddressPostalCode ?? "",
              //                         style: context.textTheme.bodySmall
              //                             ?.copyWith(
              //                                 color: isDetail
              //                                     ? context.theme.colorScheme
              //                                         .onSurface
              //                                     : determineTextColor(
              //                                         context,
              //                                         jobModel,
              //                                       ))),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         )
              //       ],
              //     ),
              //     // Column(
              //     //   crossAxisAlignment: CrossAxisAlignment.end,
              //     //   children: [
              //     //     jobModel.isVisibleStartAddress != null &&
              //     //             jobModel.isVisibleStartAddress == true
              //     //         ? Text(jobModel.startAddressPostalCode.toString(),
              //     //             style: context.textTheme.bodySmall?.copyWith(
              //     //                 color: isDetail
              //     //                     ? context.theme.colorScheme.onSurface
              //     //                     : determineTextColor(
              //     //                         context,
              //     //                         jobModel,
              //     //                       )))
              //     //         : const SizedBox(),
              //     //     jobModel.isVisibleCheckpoint1Address == false &&
              //     //             jobModel.isVisibleCheckpoint2Address == false &&
              //     //             jobModel.isVisibleCheckpoint3Address == false
              //     //         ? const SizedBox()
              //     //         : jobModel.isVisibleCheckpoint1Address == true
              //     //             ? const VerticalSpace.medium()
              //     //             : const SizedBox(),
              //     //     jobModel.isVisibleCheckpoint1Address != null &&
              //     //             jobModel.isVisibleCheckpoint1Address == true
              //     //         ? Text(
              //     //             jobModel.checkpoint1AddressPostalCode != null
              //     //                 ? jobModel.checkpoint1AddressPostalCode
              //     //                     .toString()
              //     //                 : '',
              //     //             style: context.textTheme.bodySmall?.copyWith(
              //     //                 color: isDetail
              //     //                     ? context.theme.colorScheme.onSurface
              //     //                     : determineTextColor(
              //     //                         context,
              //     //                         jobModel,
              //     //                       )))
              //     //         : const SizedBox(),
              //     //     jobModel.isVisibleCheckpoint2Address == true
              //     //         ? const VerticalSpace.medium()
              //     //         : const VerticalSpace.xSmall(),
              //     //     jobModel.isVisibleCheckpoint2Address != null &&
              //     //             jobModel.isVisibleCheckpoint2Address == true
              //     //         ? Text(
              //     //             jobModel.checkpoint2AddressPostalCode != null
              //     //                 ? jobModel.checkpoint2AddressPostalCode
              //     //                     .toString()
              //     //                 : '',
              //     //             style: context.textTheme.bodySmall?.copyWith(
              //     //                 color: isDetail
              //     //                     ? context.theme.colorScheme.onSurface
              //     //                     : determineTextColor(
              //     //                         context,
              //     //                         jobModel,
              //     //                       )))
              //     //         : const SizedBox(),
              //     //     jobModel.isVisibleCheckpoint3Address == true
              //     //         ? const VerticalSpace.medium()
              //     //         : const VerticalSpace.xSmall(),
              //     //     jobModel.isVisibleCheckpoint3Address != null &&
              //     //             jobModel.isVisibleCheckpoint3Address == true
              //     //         ? Text(
              //     //             jobModel.checkpoint3AddressPostalCode != null
              //     //                 ? jobModel.checkpoint3AddressPostalCode
              //     //                     .toString()
              //     //                 : '',
              //     //             style: context.textTheme.bodySmall?.copyWith(
              //     //                 color: isDetail
              //     //                     ? context.theme.colorScheme.onSurface
              //     //                     : determineTextColor(
              //     //                         context,
              //     //                         jobModel,
              //     //                       )))
              //     //         : const SizedBox(),
              //     //     jobModel.isVisibleCheckpoint1Address == false &&
              //     //             jobModel.isVisibleCheckpoint2Address == false &&
              //     //             jobModel.isVisibleCheckpoint3Address == false
              //     //         ? const SizedBox()
              //     //         : const VerticalSpace.medium(),
              //     //     Text(jobModel.endAddressPostalCode ?? "",
              //     //         style: context.textTheme.bodySmall?.copyWith(
              //     //             color: isDetail
              //     //                 ? context.theme.colorScheme.onSurface
              //     //                 : determineTextColor(
              //     //                     context,
              //     //                     jobModel,
              //     //                   ))),
              //     //   ],
              //     // )
              //   ],
              // ),
              context.height > 900
                  ? const VerticalSpace.medium()
                  : const VerticalSpace.small(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  if (!isDetail)
                    BadgeStatusUpcomingWidget(
                      titleColor: jobModel.status == 0 &&
                              ProductStateItems.hiveDatabaseManager
                                      .getUserModel()
                                      ?.currentJobId !=
                                  jobModel.id
                          ? const Color(0xFFFFFBD2)
                          : Colors.white,
                      backgroundColor: jobModel.status == 0
                          ? const Color(0xFFC0A100)
                          : Colors.black,
                      status: jobModel.status == 1 ||
                              ProductStateItems.hiveDatabaseManager
                                      .getUserModel()
                                      ?.currentJobId ==
                                  jobModel.id.toString()
                          ? "Started"
                          : jobModel.status == 0
                              ? "Upcoming"
                              : "Completed",
                    ),
                ],
              ),
              const VerticalSpace.xSmall(),
              if (isToday &&
                  jobModel.status != 2 &&
                  jobModel.isDriverConfirm == false &&
                  ProductStateItems.hiveDatabaseManager
                          .getUserModel()
                          ?.currentJobId !=
                      jobModel.id.toString())
                SizedBox(
                  child: CustomAppButton(
                      text: "Confirm",
                      ontap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor:
                                  context.theme.colorScheme.surface,
                              title: Text(
                                'Confirm Job',
                                style: context.textTheme.titleLarge?.copyWith(
                                    color: context
                                        .theme.colorScheme.primaryContainer),
                              ),
                              content: SizedBox(
                                height: context.dynamicHeight(0.35),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Reg Number: ',
                                          style: context.textTheme.bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: context.theme
                                                      .colorScheme.primary),
                                        ),
                                        Text(
                                          '${jobModel.regNumber}',
                                          style: context.textTheme.bodyMedium
                                              ?.copyWith(
                                                  color: context.theme
                                                      .colorScheme.primary),
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 0.5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Date: ',
                                          style: context.textTheme.bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: context.theme
                                                      .colorScheme.primary),
                                        ),
                                        Text(
                                          '${jobModel.date}',
                                          style: context.textTheme.bodyMedium
                                              ?.copyWith(
                                                  color: context.theme
                                                      .colorScheme.primary),
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 0.5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Movement Type: ',
                                          style: context.textTheme.bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: context.theme
                                                      .colorScheme.primary),
                                        ),
                                        Text(
                                          jobModel.movementTypeId!.name,
                                          style: context.textTheme.bodyMedium
                                              ?.copyWith(
                                                  color: context.theme
                                                      .colorScheme.primary),
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 0.5,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'From: ',
                                            style: context.textTheme.bodyMedium
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: context.theme
                                                        .colorScheme.primary),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            '${jobModel.startAddress}',
                                            style: context.textTheme.bodyMedium
                                                ?.copyWith(
                                                    color: context.theme
                                                        .colorScheme.primary),
                                          ),
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 0.5,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'To: ',
                                            style: context.textTheme.bodyMedium
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: context.theme
                                                        .colorScheme.primary),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            '${jobModel.endAddress}',
                                            style: context.textTheme.bodyMedium
                                                ?.copyWith(
                                                    color: context.theme
                                                        .colorScheme.primary),
                                          ),
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 0.5,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: context.textTheme.bodyLarge
                                        ?.copyWith(
                                            color: context.theme.colorScheme
                                                .primaryContainer),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: context
                                          .theme.colorScheme.primaryContainer,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      minimumSize: Size(
                                          context.dynamicWidth(0.07),
                                          context.dynamicHeight(0.04))),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context
                                        .read<HomeBloc>()
                                        .add(ConfirmJob(jobModel.id, false));
                                  },
                                  child: Text(
                                    'Confirm',
                                    style: context.textTheme.bodyLarge
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddressRow(
      BuildContext context, String address, String postalCode,
      {required bool isLast}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: isDetail
                      ? context.theme.colorScheme.onSurface
                      : determineTextColor(
                          context,
                          jobModel,
                        ),
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Container(
                  height: context.height * 0.05,
                  width: 2,
                  color: isDetail
                      ? context.theme.colorScheme.onSurface
                      : determineTextColor(
                          context,
                          jobModel,
                        ),
                ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    address,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDetail
                          ? context.theme.colorScheme.onSurface
                          : determineTextColor(
                              context,
                              jobModel,
                            ),
                    ),
                  ),
                ),
                SizedBox(width: context.width * 0.1),
                Expanded(
                  child: Text(
                    postalCode,
                    maxLines: 1,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDetail
                          ? context.theme.colorScheme.onSurface
                          : determineTextColor(
                              context,
                              jobModel,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BadgeStatusUpcomingWidget extends StatelessWidget {
  final String status;
  final Color titleColor;
  final Color backgroundColor;

  const BadgeStatusUpcomingWidget({
    super.key,
    required this.status,
    required this.titleColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.dynamicHeight(0.033),
      width: context.dynamicWidth(0.21),
      decoration: BoxDecoration(
        color: titleColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          status,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: backgroundColor,
          ),
        ),
      ),
    );
  }
}
