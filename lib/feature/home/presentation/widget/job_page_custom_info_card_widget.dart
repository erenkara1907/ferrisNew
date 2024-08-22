import 'package:easy_localization/easy_localization.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/job_expense/job_expense_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/stop_job/stop_job_bloc.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:flutter/material.dart';

import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomInfoCard extends StatelessWidget {
  final JobsResponseModelItem jobModel;
  final HomeState state;

  const CustomInfoCard({
    Key? key,
    required this.jobModel,
    required this.state,
  }) : super(key: key);

  String _formatDate(String date) {
    // DateTime'i UTC olarak parseliyoruz
    DateTime dateTime = DateTime.parse(date).toUtc();

    // UTC'yi yerel saate dönüştürüyoruz
    DateTime localDateTime = dateTime.toLocal();

    // DateFormat'i kullanarak tarih formatını belirtiyoruz
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    // Yerel saate göre formatlıyoruz
    return dateFormat.format(localDateTime);
  }

  @override
  Widget build(BuildContext context) {
    // print(jobModel.predictedStartLocationTime);
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
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
                  'Start',
                  style: context.textTheme.bodySmall,
                ),
                Text(
                  jobModel.predictedStartLocationTime == null
                      ? "-"
                      : "${_formatDate(jobModel.billableHoursStartTime!)} - ${DateFormat('HH:mm').format(DateTime.parse(jobModel.billableHoursStartTime!))}",
                  style: context.textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const VerticalSpace.xxSmall(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'End',
                  style: context.textTheme.bodySmall,
                ),
                Text(
                  jobModel.predictedEndLocationTime == null
                      ? "-"
                      : "${_formatDate(jobModel.billableHoursEndTime!)} - ${DateFormat('HH:mm').format(DateTime.parse(jobModel.billableHoursEndTime!))}",
                  style: context.textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const VerticalSpace.small(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Expenses',
                  style: context.textTheme.bodySmall,
                ),
                if (ProductStateItems.hiveDatabaseManager
                            .getUserModel()
                            ?.currentJobId !=
                        null &&
                    ProductStateItems.hiveDatabaseManager
                            .getUserModel()
                            ?.currentJobId ==
                        jobModel.id.toString())
                  Text(
                    context.watch<JobExpenseBloc>().state.totalExpense != ""
                        ? '£${double.parse(context.watch<JobExpenseBloc>().state.totalExpense).toStringAsFixed(2)}'
                        : "-",
                    style: context.textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  )
                else
                  Text(
                    '£${jobModel.expensesTotalCost?.toStringAsFixed(2) ?? "0.00"}',
                    style: context.textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
              ],
            ),
            const VerticalSpace.xxSmall(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stops',
                  style: context.textTheme.bodySmall,
                ),
                if (ProductStateItems.hiveDatabaseManager
                            .getUserModel()
                            ?.currentJobId !=
                        null &&
                    ProductStateItems.hiveDatabaseManager
                            .getUserModel()
                            ?.currentJobId ==
                        jobModel.id.toString())
                  Text(
                    context.watch<StopJobBloc>().state.totalStop.toString(),
                    style: context.textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  )
                else
                  Text(
                    "${jobModel.stopsCount}",
                    style: context.textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
              ],
            ),
            const VerticalSpace.xxSmall(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Inspections',
                  style: context.textTheme.bodySmall,
                ),
                Text(
                  jobModel.inspectionsCount.toString(),
                  style: context.textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
