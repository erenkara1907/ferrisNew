import 'package:bot_toast/bot_toast.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/movement_type/feedback_input_availability.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/job_expense/job_expense_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/stop_job/stop_job_bloc.dart';
import 'package:ferrisfwt/feature/inspections/presentation/bloc/inspections_bloc.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/edit_details_page.dart';
import 'package:ferrisfwt/product/database/hive/core/hive_database_manager.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/manager/location/location_service_manager.dart';
import 'package:ferrisfwt/product/mixin/network_mixin.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/end_job_post_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/button/custom_grey_app_button.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/popup/question_popup.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FinishJobPage extends StatefulWidget {
  final bool? isFuelView;
  final bool? isFeedBackView;
  final FeedbackInputAvailability? feedbackInputAvailability;
  const FinishJobPage({
    super.key,
    this.isFuelView,
    this.isFeedBackView,
    this.feedbackInputAvailability,
  });

  @override
  State<FinishJobPage> createState() => _FinishJobPageState();
}

class _FinishJobPageState extends State<FinishJobPage> {
  final List<String> _spendChargingValues = [
    '0 min',
    '10 mins',
    '20 mins',
    '30 mins',
    '40 mins',
    '50 mins',
    '60> mins',
  ];
  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  late HiveStorageManager _hiveStorageManager;
  HiveDatabaseManager? _hi;
  JobsResponseModelItem? job;

  @override
  void initState() {
    super.initState();
    _hiveStorageManager = ProductStateItems.hiveStorageManager;
    _hi = ProductStateItems.hiveDatabaseManager;
    _onCheck();
    _initializeJob();
  }

  Future<void> checkInternetConnection() async {
    final userHiveOperation = ProductStateItems.hiveStorageManager;
    final userHiveDatabase = ProductStateItems.hiveDatabaseManager;
    if (ProductStateItems.hiveDatabaseManager.getUserModel()?.isStarted ==
        false) return;
    var connectivityResult = await hasNetwork();
    if (connectivityResult) {
      final result = await userHiveOperation.getJobExpenseAsync();
      // print('result: $result');

      final resultStop = await userHiveOperation.getJobStopAsync();

      // print('resultStop: $resultStop');

      final resultJobUpdate = await userHiveOperation.getJobUpdate();

      // print('resultJobUpdate: $resultJobUpdate');

      final resultPatch = await userHiveOperation.getJobExpensePatchAsync();

      // print('resultPatch: $resultPatch');

      if (result != [] && result.isNotEmpty && result != {}) {
        for (var item in result) {
          context.read<JobExpenseBloc>().add(PostExpense(item!, true));
          await Future.delayed(const Duration(seconds: 5));
        }
        await Future.delayed(const Duration(seconds: 5));

        userHiveOperation.deleteJobExpenseAsync();
      }
      if (resultPatch.isNotEmpty &&
          resultPatch != {} &&
          resultPatch != [] &&
          userHiveDatabase.getUserModel() != null) {
        for (var item in resultPatch) {
          context.read<JobExpenseBloc>().add(PatchExpense(item!, true, 0));
          await Future.delayed(const Duration(seconds: 5));
        }
        userHiveOperation.deleteJobExpensePatchAsync();
      }

      if (resultStop != [] &&
          resultStop.isNotEmpty &&
          resultStop != {} &&
          userHiveDatabase.getUserModel() != null) {
        for (var item in resultStop) {
          context.read<StopJobBloc>().add(PostJobStops(
              isAsync: true,
              jobId: int.parse(
                  userHiveDatabase.getUserModel()!.currentJobId ?? ""),
              data: item!));
          await Future.delayed(const Duration(seconds: 2));
        }
        userHiveOperation.deleteJobStopAsync();
      }

      if (resultJobUpdate.isNotEmpty &&
          resultJobUpdate != {} &&
          resultJobUpdate != [] &&
          userHiveDatabase.getUserModel() != null) {
        for (var item in resultJobUpdate) {
          context.read<HomeBloc>().add(UpdateJob(
              userHiveDatabase.getUserModel()!.currentJobId ?? "",
              item!,
              true));
          await Future.delayed(const Duration(seconds: 2));
        }

        userHiveOperation.deleteJobUpdates();
      }
      final List<int> jobInspectionsId = ProductStateItems.hiveDatabaseManager
              .getUserModel()
              ?.inspectionsJobId ??
          [];

      // print('jobInspectionsId: $jobInspectionsId');

      for (var id in jobInspectionsId) {
        try {
          final resultInspection =
              await userHiveOperation.getChecklistPostModel(id);
          // print('resultInspectionChekList: $resultInspection');
          if (resultInspection.isNotEmpty) {
            await Future.forEach(resultInspection, (item) async {
              context
                  .read<InspectionsBloc>()
                  .add(PostJobInspectionsCheckList(item!, true, false, null));
              await Future.delayed(const Duration(seconds: 2));
            });
            await userHiveOperation.deleteChecklistPostModel(id);
          }

          /*
          final resultInspectionPatch =
              await _userHiveOperation.getConditionImagePostModel(id);
          print('resultInspectionConditionsImage: $resultInspectionPatch');
          if (resultInspectionPatch != null &&
              resultInspectionPatch.isNotEmpty) {
            await Future.forEach(resultInspectionPatch, (item) async {
              context.read<InspectionsBloc>().add(PostConditionImages(
                  data: item!, jobInspectionId: id, isAsync: true));
              await Future.delayed(const Duration(seconds: 2));
            });
            await _userHiveOperation.deleteConditionImagePostModel(id);
          }
*/
          final resultInspectionEditDetail =
              await userHiveOperation.getInspectionDetails(id);
          // print('resultInspectionEditDetail: $resultInspectionEditDetail');
          if (resultInspectionEditDetail.isNotEmpty) {
            await Future.forEach(resultInspectionEditDetail, (item) async {
              context.read<InspectionsBloc>().add(InspectionsItemDetail(
                    odoReading: item!.odoReading,
                    fuelLevel: item.fuelLevel,
                    inspectionId: item.inspectionId,
                    isAsync: true,
                  ));
              await Future.delayed(const Duration(seconds: 2));
            });
            await userHiveOperation.removeInspectionDetailsRecord(id);
          }
/*
          final resultInspectionEdit =
              await _userHiveOperation.getDamagePostModel(id);
          print('resultInspectionDamage $resultInspectionEdit');
          if (resultInspectionEdit != null && resultInspectionEdit.isNotEmpty) {
            await Future.forEach(resultInspectionEdit, (item) async {
              context
                  .read<InspectionsBloc>()
                  .add(PostJobInspectionsDamages(data: item!, isAsync: true));
              await Future.delayed(const Duration(seconds: 2));
            });
            await _userHiveOperation.deleteDamagePostModel(id);
          }

          */

          final resultInspectionCustomerSign =
              await userHiveOperation.getSignCustomerPostModel(id);
          final resultInspectionSign =
              await userHiveOperation.getSignInspectorPostModel(id);
          // print('resultInspectionSign $resultInspectionCustomerSign');

          if (resultInspectionCustomerSign != null) {
            context.read<InspectionsBloc>().add(PostJobInspectionsCustomerSign(
                  jobInspectionId: id,
                  data: resultInspectionCustomerSign,
                  isAsync: true,
                ));
            await Future.delayed(const Duration(seconds: 1));

            context.read<InspectionsBloc>().add(PostInspectionSign(
                  jobInspectionId: id,
                  data: resultInspectionSign!,
                  isAsync: true,
                ));
            await Future.delayed(const Duration(seconds: 2));

            await userHiveOperation.clearAllSignCustomerPostModels();
            await userHiveOperation.clearAllSignInspectorPostModels();
          }
        } catch (e) {
          print('Error occurred: $e');
          // Hata meydana gelirse, devam edebilir veya döngüyü durdurabilirsiniz.
          // Burada nasıl davranmak istediğinize karar verin.
        }
      }
      //future delaye ekle
    }
  }

  void _initializeJob() async {
    job = await ProductStateItems.hiveStorageManager.getJobWorkingOnModel(750);
  }

  Future<void> _onCheck() async {
    if (context.read<HomeBloc>().state.status == ViewStatus.loading) {
      return;
    }

    final result = await ProductStateItems.hiveStorageManager.getJobUpdate();
    if (result != [] && result.isNotEmpty && result != {}) {
      BotToast.showText(
        text: 'Syncing Expenses...',
        contentColor: context.theme.colorScheme.primary,
        duration: const Duration(seconds: 4),
      );
      // print('resultJOBExpemde: $result');
      for (var item in result) {
        context.read<HomeBloc>().add(UpdateJob(
              ProductStateItems.hiveDatabaseManager
                  .getUserModel()!
                  .currentJobId!,
              item!,
              true,
            ));
        await Future.delayed(const Duration(seconds: 1));
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
        await Future.delayed(const Duration(seconds: 1));
      }
      ProductStateItems.hiveStorageManager.deleteJobExpensePatchAsync();
    }
  }

  String? _selectedValletStandart;
  String? _spendCharging;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => current.status != previous.status,
      listener: (context, state) async {
        if (state.status == ViewStatus.success && state.isFinished) {
          await _hi?.deleteJob();
          await _hiveStorageManager.deleteInspectionChecklist();
          await _hiveStorageManager.clearAllInspectionConditionImages();
          await _hiveStorageManager.clearAllConditionImagePostModels();
          await _hiveStorageManager.clearAllInspectionDamages();
          await _hiveStorageManager.clearAllDamagePostModels();
          await _hiveStorageManager.clearAllInspectionDetails();
          await _hiveStorageManager.clearAllInspectionSigns();
          await _hiveStorageManager.clearAllSignCustomerPostModels();
          await _hiveStorageManager.clearAllSignInspectorPostModels();
          await _hiveStorageManager.deleteTrackingCoordinate();
          await _hiveStorageManager.clearStops();
          await _hiveStorageManager.deleteJobStopAsync();
          await _hiveStorageManager.deleteJobUpdate();
          await _hiveStorageManager.deleteJobToFinish();
          await _hiveStorageManager.deleteJopUpdates();
          await _hiveStorageManager.deleteJobExpensePatchAsync();
          await _hiveStorageManager.deleteJobExpenseAsync();
          await _hiveStorageManager.clearItemCheckList();
          await _hiveStorageManager.deleteExpensePostResponses();
          await _hiveStorageManager.deleteExpensePatchPostResponses();
          await _hiveStorageManager.deleteDamageCategories();
          await _hiveStorageManager.deleteAllRecordedDamage();
          await _hiveStorageManager.clearAllConditionImages();
          await _hiveStorageManager.deleteAllInspectionListModel();
          await _hiveStorageManager.deleteExpenses();
          await _hiveStorageManager.clearItemCheckList();
          await _hiveStorageManager.clearAllPostExpenseSaveImages();
          context.read<StopJobBloc>().add(const ClearJobStops());
          context.read<JobExpenseBloc>().add(const ClearExpensePost());
          context.read<InspectionsBloc>().add(const ClearInspection());
          if (await LocationServiceManager().isServiceStarted()) {
            await LocationServiceManager().stopService();
          }
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  icon: Image.asset('assets/images/fr_success_finish.png',
                      height: context.dynamicHeight(0.09),
                      width: context.dynamicWidth(0.09)),
                  title: const Text('Finish job success'),
                  actions: [
                    CustomAppButton(
                        text: 'Go Home Page',
                        ontap: () {
                          context.read<HomeBloc>().add(const GetJobs());
                          context.go('/home_page');
                        })
                  ],
                );
              });
        } else if (state.status == ViewStatus.success &&
            !state.isFinished &&
            state.noNetworkFinished) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  icon: Image.asset('assets/images/fr_success_finish.png',
                      height: context.dynamicHeight(0.09),
                      width: context.dynamicWidth(0.09)),
                  title: Text(
                    'Finish job success, waiting for internet connection to sync job...',
                    style: context.textTheme.bodyMedium,
                  ),
                  actions: [
                    CustomAppButton(
                        text: 'finish job',
                        ontap: () async {
                          BotToast.showLoading();
                          final result = await hasNetwork();

                          if (result) {
                            final jobToFinish = await ProductStateItems
                                .hiveStorageManager
                                .getJobToFinish();
                            if (jobToFinish == null) {
                              BotToast.showText(
                                  text: 'No job to finish',
                                  contentColor:
                                      context.theme.colorScheme.error);
                              BotToast.closeAllLoading();
                              return;
                            }
                            context.read<HomeBloc>().add(EndJob(
                                isViewFuel: job
                                            ?.movementTypeId!
                                            .availableFuelEvLevelInputs
                                            .isEmpty ==
                                        false ||
                                    job?.movementTypeId!.feedbackInputs
                                            ?.showAnyInput ==
                                        true,
                                isFeedBackView: job?.movementTypeId!
                                        .feedbackInputs?.showAnyInput ==
                                    true,
                                feedbackInputAvailability:
                                    job?.movementTypeId!.feedbackInputs ??
                                        job?.movementTypeId!.feedbackInputs,
                                context: context,
                                id: ProductStateItems.hiveDatabaseManager
                                    .getUserModel()!
                                    .currentJobId
                                    .toString(),
                                data: jobToFinish));
                            context.pop();
                          } else {
                            BotToast.showText(
                                text: 'No internet connection',
                                contentColor: context.theme.colorScheme.error);
                          }
                          BotToast.closeAllLoading();
                        })
                  ],
                );
              });
          return;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: context.theme.colorScheme.surface,
            title: const Text('Finish Job'),
          ),
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state.status == ViewStatus.loading) {
                return const Center(
                  child: LoadingProgress(),
                );
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: context.paddingAllDefault,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Job Finish",
                                style: context.theme.textTheme.headlineMedium),
                          ),
                        ],
                      ),
                      const VerticalSpace.small(),
                      Column(
                        children: [
                          if (job?.movementTypeId!.feedbackInputs
                                      ?.showAnyInput ==
                                  true ||
                              state.showJob?.movementTypeId!.feedbackInputs
                                      ?.showAnyInput ==
                                  true)
                            CustomAppButton(
                                text: 'Feedback',
                                ontap: () {
                                  context.push("/feedback_page", extra: {
                                    "feedbackInputAvailability":
                                        job?.movementTypeId?.feedbackInputs ??
                                            state.showJob?.movementTypeId
                                                ?.feedbackInputs
                                  });
                                }),
                          const VerticalSpace.small(),
                          if (job?.movementTypeId!.availableFuelEvLevelInputs
                                      .isEmpty ==
                                  false ||
                              state.showJob?.movementTypeId!
                                      .availableFuelEvLevelInputs.isEmpty ==
                                  false)
                            CustomAppButton(
                                text: 'Fuel Level',
                                ontap: () {
                                  context.push('/fuel_level_page', extra: {
                                    "jobId": job == null
                                        ? state.showJob?.id
                                        : job?.id
                                  });
                                }),
                        ],
                      ),
                      const VerticalSpace.small(),
                      DropdownButtonWidget(
                        value: _spendCharging,
                        hintText: "Time Spent Charging",
                        items: _spendChargingValues
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        text: "Time Spent Charging",
                        onChanged: (String) {
                          setState(() {
                            _spendCharging = String;
                          });
                        },
                        textSpanEnable: true,
                      ),
                      const VerticalSpace.small(),
                      DropdownButtonWidget(
                        value: _selectedValletStandart,
                        hintText: "Select Level at Part",
                        items: state.jobsValet
                            .map((e) => DropdownMenuItem(
                                  value: e.name,
                                  child: Text(e.name),
                                ))
                            .toList(),
                        text: "Valet Standard",
                        onChanged: (String) {
                          setState(() {
                            _selectedValletStandart = String;
                          });
                        },
                        textSpanEnable: true,
                      ),
                      const VerticalSpace.small(),
                      CustomGreyAppButton(
                          textColor: Colors.white,
                          text: "Finish Job",
                          containerColor: context.theme.colorScheme.error,
                          ontap: () async {
                            if (_spendCharging == null) {
                              BotToast.showText(
                                  text: "Time spent charging is required");
                              return;
                            }
                            if (_selectedValletStandart == null) {
                              BotToast.showText(
                                  text: "Valet Standard is required");
                              return;
                            }

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return QuestionPopup(
                                    actionButtonText: 'Confirm',
                                    title: 'Finish Job',
                                    description:
                                        'Are you sure you want to finish this job? (As long as you have internet you can start a new job)',
                                    actionButtonOnPressed: () async {
                                      BotToast.showLoading();
                                      await checkInternetConnection();
                                      await _onCheck();
                                      final id = state.jobsValet
                                          .firstWhere((element) =>
                                              element.name ==
                                              _selectedValletStandart)
                                          .id;

                                      DateTime now = DateTime.now();
                                      final date =
                                          '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}';
                                      final currentTime = DateTime.now()
                                              .millisecondsSinceEpoch ~/
                                          1000;
                                      // print(widget.isFuelView);
                                      // print(widget.feedbackInputAvailability);
                                      // print(widget.feedbackInputAvailability);

                                      context.read<HomeBloc>().add(EndJob(
                                            isViewFuel: widget.isFuelView ==
                                                        null ||
                                                    widget.isFuelView == false
                                                ? false
                                                : true,
                                            isFeedBackView:
                                                widget.feedbackInputAvailability ==
                                                        null
                                                    ? false
                                                    : true,
                                            feedbackInputAvailability: widget
                                                .feedbackInputAvailability,
                                            context: context,
                                            id: state.showJob!.id.toString(),
                                            data: EndJobPostModel(
                                              departedHubTime: date,
                                              arrivedCustomerTime: date,
                                              departedCustomerTime: date,
                                              endDate: currentTime,
                                              spendCharging: _spendCharging,
                                              valetStandardId: id,
                                            ),
                                          ));
                                      context.pop();
                                      BotToast.closeAllLoading();
                                    },
                                    iconPath:
                                        'assets/images/fr_finish_job.png');
                                // return AlertDialog(
                                //   icon: ClipRRect(
                                //     borderRadius: BorderRadius.circular(12.0),
                                //     child: Container(
                                //       height: context.dynamicHeight(
                                //           0.12), // Yüksekliği ayarlayın
                                //       width: context.dynamicWidth(
                                //           0.25), // Genişliği ayarlayın
                                //       decoration: BoxDecoration(
                                //         image: DecorationImage(
                                //           image: AssetImage(
                                //               'assets/images/finish_job.png'),
                                //           fit: BoxFit.contain,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                //   title: const Text('Finish Job'),
                                //   content: const Text(
                                //       'Are you sure you want to finish this job? (As long as you have internet you can start a new job)'),
                                //   actions: [
                                //     TextButton(
                                //       onPressed: () {
                                //         Navigator.of(context).pop();
                                //       },
                                //       child: Text('Cancel'),
                                //     ),
                                //     TextButton(
                                //       onPressed: () async {
                                //         final id = state.jobsValet
                                //             .firstWhere((element) =>
                                //                 element.name ==
                                //                 _selectedValletStandart)
                                //             .id;
                                //         print('akjsdhfaklsjdhflkasjdfh$id');
                                //         DateTime now = DateTime.now();
                                //         final date =
                                //             '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}';
                                //         final currentTime =
                                //             DateTime.now().millisecondsSinceEpoch ~/
                                //                 1000;
                                //         context.read<HomeBloc>().add(EndJob(
                                //               context: context,
                                //               id: state.showJob!.id.toString(),
                                //               data: EndJobPostModel(
                                //                 departedHubTime: date,
                                //                 arrivedCustomerTime: date,
                                //                 departedCustomerTime: date,
                                //                 endDate: currentTime,
                                //                 spendCharging: _spendCharging,
                                //                 valetStandardId: id,
                                //               ),
                                //             ));
                                //         Navigator.of(context).pop();
                                //       },
                                //       child: Text('Confirm'),
                                //     ),
                                //   ],
                                // );
                              },
                            );
                          })
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
