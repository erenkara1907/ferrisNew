import 'package:easy_localization/easy_localization.dart'; // Tarih formatlama için
import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/mixin/network_mixin.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_horizontal_spacer.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.status == ViewStatus.loading) {
          return const Center(
            child: LoadingProgress(),
          );
        }
        return Scaffold(
            backgroundColor: context.theme.colorScheme.surface,
            body: SafeArea(
              child: Padding(
                padding: context.paddingHorizontalDefault,
                child: Column(
                  children: [
                    const VerticalSpace.small(),
                    const HistoryTextfieldSearchWidget(),
                    const VerticalSpace.small(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("History",
                            style: context.textTheme.headlineMedium
                                ?.copyWith(fontSize: 20)),
                      ],
                    ),
                    const VerticalSpace.small(),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          final result = await hasNetwork();
                          if (result) {
                            context.read<HomeBloc>().add(const GetJobHistory());
                          }
                        },
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: state.jobsHistory.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CustomHistoryCard(
                              jobModel: state.jobsHistory[index],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const VerticalSpace.small();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}

class CustomHistoryCard extends StatelessWidget {
  final JobsResponseModelItem jobModel;
  final bool isJobCompleted = true;
  const CustomHistoryCard({
    super.key,
    required this.jobModel,
  });

  @override
  Widget build(BuildContext context) {
    // startDate ve endDate int? türündeyse DateTime'e dönüştürüyoruz
    String formattedStartDate = jobModel.startDate != null
        ? DateFormat('dd-MM-yyyy').format((jobModel.scheduleDate!.isNotEmpty)
            ? DateTime.parse(jobModel.scheduleDate!)
            : DateTime.fromMillisecondsSinceEpoch(jobModel.startDate! * 1000))
        : '';

    String formattedEndDate = jobModel.endDate != null
        ? DateFormat('dd-MM-yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(jobModel.endDate! * 1000))
        : '';

    return InkWell(
      onTap: () {
        context.push('/job_detail_page', extra: {
          'jobId': jobModel.id.toString(),
          'jobModel': jobModel,
          'isCameHomePage': false
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: context.paddingAllDefault,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    jobModel.vehicleId!.name.toString(),
                    style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w400, color: Colors.white),
                  ),
                  Text(
                    jobModel.regNumber.toString(),
                    style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ],
              ),
              const VerticalSpace.xxSmall(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(jobModel.clientId?.name.toString() ?? '',
                      style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600, color: Colors.white)),
                ],
              ),
              const VerticalSpace.xSmall(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: context.dynamicHeight(0.013),
                            width: context.dynamicWidth(0.022),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.white),
                            ),
                          ),
                          Container(
                            height: 20,
                            width: 2,
                            color: Colors.white,
                          ),
                          Container(
                            height: context.dynamicHeight(0.013),
                            width: context.dynamicWidth(0.022),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const HorizontalSpace.xSmall(),
                      SizedBox(
                        width: context.dynamicWidth(0.6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(jobModel.startAddress.toString(),
                                style: context.textTheme.bodySmall
                                    ?.copyWith(color: Colors.white)),
                            const VerticalSpace.xSmall(),
                            Text(jobModel.endAddress.toString(),
                                style: context.textTheme.bodySmall
                                    ?.copyWith(color: Colors.white)),
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(jobModel.startAddressPostalCode.toString(),
                          style: context.textTheme.bodySmall
                              ?.copyWith(color: Colors.white)),
                      const VerticalSpace.small(),
                      Text(jobModel.endAddressPostalCode.toString(),
                          style: context.textTheme.bodySmall
                              ?.copyWith(color: Colors.white)),
                    ],
                  )
                ],
              ),
              const VerticalSpace.xSmall(),
              Row(
                children: [
                  const SizedBox.shrink(),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Start Date: ',
                              style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              formattedStartDate,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'End Date: ',
                              style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              formattedEndDate,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Expanded(
                    child: BadgeStatusCompletedWidget(
                      status: "Completed",
                    ),
                  ),
                ],
              ),
              const VerticalSpace.xSmall(),
            ],
          ),
        ),
      ),
    );
  }
}

class BadgeStatusCompletedWidget extends StatelessWidget {
  final String status;
  const BadgeStatusCompletedWidget({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: context.dynamicHeight(0.033),
        width: context.dynamicWidth(0.21),
        decoration: BoxDecoration(
          color: const Color(0xFFE5FFED),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(status,
              style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: const Color(0xFF4A8C57))),
        ));
  }
}

class HistoryRowScrollWidget extends StatelessWidget {
  String text;
  String iconName;
  String number;
  Color? color;

  HistoryRowScrollWidget({
    required this.color,
    required this.text,
    required this.iconName,
    required this.number,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.dynamicHeight(0.1),
      width: context.dynamicWidth(0.33),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: context.paddingAllLow + context.paddingHorizontalLow,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.theme.colorScheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Image.asset(
                  color: color,
                  iconName,
                  width: 16,
                  height: 16,
                )
              ],
            ),
            VerticalSpace.withPercentage(
              percentage: 0.006,
              context: context,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(number,
                    style: context.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class HistoryTextfieldSearchWidget extends StatelessWidget {
  const HistoryTextfieldSearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          context.push('/search_history_page');
        },
        child: Container(
            height: 41,
            decoration: BoxDecoration(
              color: context.theme.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: context.paddingHorizontalDefault,
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: context.theme.colorScheme.outline,
                  ),
                  const HorizontalSpace.xxSmall(),
                  Text(
                    "Search a Job",
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            )));
  }
}
