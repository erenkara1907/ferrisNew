// ignore_for_file: public_member_api_docs, sort_constructors_first, no_leading_underscores_for_local_identifiers
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/job_expense/job_expense_bloc.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';

class ViewExpenses extends StatefulWidget {
  final bool isAsync;
  final int jobId;
  const ViewExpenses({
    Key? key,
    required this.isAsync,
    required this.jobId,
  }) : super(key: key);

  @override
  State<ViewExpenses> createState() => _ViewExpensesState();
}

class _ViewExpensesState extends State<ViewExpenses> {
  JobsResponseModelItem? job;
  bool isSyncing = false;

  @override
  void initState() {
    super.initState();

    _initializeJob();
    if (widget.isAsync) {
      context.read<JobExpenseBloc>().add(SetExpensePost(int.parse(
          ProductStateItems.hiveDatabaseManager
              .getUserModel()!
              .currentJobId
              .toString())));
    } else {
      _onCheck();
      String? _currentJobId = "";
      // ignore: unused_local_variable
      if (ProductStateItems.hiveDatabaseManager.getUserModel() != null) {
        _currentJobId = ProductStateItems.hiveDatabaseManager
            .getUserModel()!
            .currentJobId
            .toString();
      }

      context.read<JobExpenseBloc>().add(
            GetJobExpenses(
              jobId:
                  _currentJobId != "" ? int.parse(_currentJobId) : widget.jobId,
            ),
          );
    }
  }

  void _initializeJob() async {
    job = await ProductStateItems.hiveStorageManager.getJobWorkingOn();
  }

  Future<void> _onCheck() async {
    if (context.read<JobExpenseBloc>().state.status == ViewStatus.loading) {
      return;
    }
    final result =
        await ProductStateItems.hiveStorageManager.getJobExpenseAsync();
    if (result != [] && result.isNotEmpty && result != {}) {
      setState(() {
        isSyncing = true;
      });
      BotToast.showText(
        text: 'Syncing Expenses...',
        contentColor: context.theme.colorScheme.primary,
        duration: const Duration(seconds: 4),
      );
      // print('resultJOBExpemde: $result');
      for (var item in result) {
        context.read<JobExpenseBloc>().add(PostExpense(item!, true));
        await Future.delayed(const Duration(milliseconds: 300));
      }

      ProductStateItems.hiveStorageManager.deleteJobExpenseAsync();
    }
    final resultPatch =
        await ProductStateItems.hiveStorageManager.getJobExpensePatchAsync();

    if (resultPatch.isNotEmpty &&
        resultPatch != {} &&
        resultPatch != [] &&
        ProductStateItems.hiveDatabaseManager.getUserModel() != null) {
      BotToast.showText(
        text: 'Syncing Expenses...',
        contentColor: context.theme.colorScheme.primary,
        duration: const Duration(seconds: 8),
      );
      // print(
      //   'resultPatchsssss: $resultPatch',
      // );
      for (var item in resultPatch) {
        context.read<JobExpenseBloc>().add(PatchExpense(item!, true, 0));
        await Future.delayed(const Duration(milliseconds: 300));
      }
      ProductStateItems.hiveStorageManager.deleteJobExpensePatchAsync();
    }
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      isSyncing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobExpenseBloc, JobExpenseState>(
      builder: (context, state) {
        if (state.status == ViewStatus.loading && isSyncing) {
          return const Scaffold(
            body: Center(
              child: LoadingProgress(),
            ),
          );
        }

        final expenseMap = <int, dynamic>{};
        for (var expense in state.expenses) {
          expenseMap[expense!.id] = expense;
        }
        final uniqueExpenseList = expenseMap.values.toList();
        if (state.status != ViewStatus.loading) {
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
            body: Padding(
              padding: context.paddingHorizontalDefault,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VerticalSpace.standard(),
                  Text(
                    "View Expenses",
                    style: context.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const VerticalSpace.small(),
                  if (uniqueExpenseList.isEmpty)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const VerticalSpace.large(),
                          Image.asset(
                            'assets/images/fr_empty_job.png',
                            width: 130,
                            height: 130,
                          ),
                          SizedBox(
                            height: context.dynamicHeight(0.03),
                          ),
                          Text(
                            'No Expenses Found.',
                            style: context.textTheme.bodyLarge,
                          )
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (BuildContext context, int index) {
                          return const VerticalSpace.small();
                        },
                        itemCount: uniqueExpenseList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: context.theme.colorScheme.primary
                                      .withOpacity(0.4)),
                              color: context.theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    context
                                        .push('/view_expense_detail', extra: {
                                      'expense': uniqueExpenseList[index],
                                      'index': index,
                                    });
                                  },
                                  child: Padding(
                                    padding: context.paddingAllDefault,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              uniqueExpenseList[index]!
                                                  .categoryId!
                                                  .name,
                                              style: context
                                                  .textTheme.bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                            Text(
                                              "Price: £ ${uniqueExpenseList[index]!.price?.toStringAsFixed(2) ?? '0.00'}",
                                              style:
                                                  context.textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: context
                                              .theme.colorScheme.primary
                                              .withOpacity(0.7),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  const VerticalSpace.small(),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: LoadingProgress(),
            ),
          );
        }
      },
    );
  }
}
