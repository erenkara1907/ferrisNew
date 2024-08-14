import 'package:bot_toast/bot_toast.dart';
import 'package:ferrisfwt/feature/home/data/models/job_tracking_coordinates/tracking_coordinates_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/job_expense/job_expense_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/stop_job/stop_job_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/view/home_page.dart';
import 'package:ferrisfwt/feature/home/presentation/widget/job_page_custom_info_card_widget.dart';
import 'package:ferrisfwt/feature/inspections/presentation/bloc/inspections_bloc.dart';
import 'package:ferrisfwt/product/database/hive/core/hive_database_manager.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/manager/location/location_service_manager.dart';
import 'package:ferrisfwt/product/manager/network/core/platform_network_credentials_manager.dart';
import 'package:ferrisfwt/product/manager/network/index.dart';
import 'package:ferrisfwt/product/mixin/network_mixin.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/button/custom_grey_app_button.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/popup/question_popup.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_horizontal_spacer.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:map_launcher/map_launcher.dart';

import '../widget/job_page_custom_profile_card_widget.dart';

class JobDetailPage extends StatefulWidget {
  final String jobId;
  final bool? asyncJob;
  final bool? isSigned;
  final bool? isCameHomePage;

  const JobDetailPage(
      {super.key,
      required this.jobId,
      this.asyncJob = false,
      this.isSigned = false,
      this.isCameHomePage = true});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  JobsResponseModelItem? job;
  TrackingCoordinatesResponseModelItem? _trackingCoordinate;
  ScrollController scrollController = ScrollController();
  bool showExtraButtons = false;
  bool isStarted = false;
  late HiveStorageManager _hiveStorageManager;
  HiveDatabaseManager? _hi;

  @override
  void initState() {
    super.initState();

    context.read<HomeBloc>().add(const ClearJob());
    isStarted = false;
    _initializeJob();
    _hiveStorageManager = ProductStateItems.hiveStorageManager;
    _hi = ProductStateItems.hiveDatabaseManager;
  }

  String capitalizeFirstLetter(String input) {
    // Parçalara ayırma
    List<String> parts = input.split('.');

    // Her bir parçanın ilk harfini büyük yapma
    List<String> capitalizedParts = parts.map((part) {
      if (part.isNotEmpty) {
        return part[0].toUpperCase() + part.substring(1).toLowerCase();
      }
      return part;
    }).toList();

    // Parçaları birleştirme
    String result = capitalizedParts.join('.');

    return result;
  }

  void _initializeJob() async {
    job = await ProductStateItems.hiveStorageManager
        .getJobWorkingOnModel(int.parse(widget.jobId));
    // print("job: $job");
    if (widget.asyncJob == false) {
      context.read<HomeBloc>().add(GetJob(widget.jobId));
    } else if (job != null && job!.id.toString() == widget.jobId) {
      context.read<HomeBloc>().add(SetJob(job!));
    }
    if (job != null &&
        ProductStateItems.hiveDatabaseManager.getUserModel() != null &&
        ProductStateItems.hiveDatabaseManager.getUserModel()!.isjobFinish ==
            true) {
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
                    text: 'Finish Job',
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
                              contentColor: context.theme.colorScheme.error);
                          BotToast.closeAllLoading();
                          return;
                        }

                        context.read<HomeBloc>().add(EndJob(
                            isViewFuel: job?.movementTypeId!
                                        .availableFuelEvLevelInputs.isEmpty ==
                                    false ||
                                job?.movementTypeId!.feedbackInputs
                                        ?.showAnyInput ==
                                    true,
                            isFeedBackView: job?.movementTypeId!.feedbackInputs
                                    ?.showAnyInput ==
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
                        await _hi?.deleteJob();
                        await _hiveStorageManager.deleteInspectionChecklist();
                        await _hiveStorageManager
                            .clearAllInspectionConditionImages();
                        await _hiveStorageManager
                            .clearAllConditionImagePostModels();
                        await _hiveStorageManager.clearAllInspectionDamages();
                        await _hiveStorageManager.clearAllDamagePostModels();
                        await _hiveStorageManager.clearAllInspectionDetails();
                        await _hiveStorageManager.clearAllInspectionSigns();
                        await _hiveStorageManager
                            .clearAllSignCustomerPostModels();
                        await _hiveStorageManager
                            .clearAllSignInspectorPostModels();
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
                        await _hiveStorageManager
                            .deleteExpensePatchPostResponses();
                        await _hiveStorageManager.deleteDamageCategories();
                        await _hiveStorageManager.deleteAllRecordedDamage();
                        await _hiveStorageManager.clearAllConditionImages();
                        await _hiveStorageManager
                            .deleteAllInspectionListModel();
                        await _hiveStorageManager.deleteExpenses();
                        await _hiveStorageManager.clearItemCheckList();
                        await _hiveStorageManager
                            .clearAllPostExpenseSaveImages();
                        context.read<StopJobBloc>().add(const ClearJobStops());
                        context
                            .read<JobExpenseBloc>()
                            .add(const ClearExpensePost());
                        context
                            .read<InspectionsBloc>()
                            .add(const ClearInspection());
                        if (await LocationServiceManager().isServiceStarted()) {
                          await LocationServiceManager().stopService();
                        }
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                icon: Image.asset(
                                    'assets/images/fr_success_finish.png',
                                    height: context.dynamicHeight(0.09),
                                    width: context.dynamicWidth(0.09)),
                                title: const Text('Finish job success'),
                                actions: [
                                  CustomAppButton(
                                      text: 'Go Home Page',
                                      ontap: () {
                                        context
                                            .read<HomeBloc>()
                                            .add(const GetJobs());
                                        context.go('/home_page');
                                      })
                                ],
                              );
                            });
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
  }

  Future<void> _launchMap() async {
    job ??= context.read<HomeBloc>().state.showJob;

    _trackingCoordinate =
        await ProductStateItems.hiveStorageManager.getTrackingCoordinateModel();
    // print("trackingCoordinate: $_trackingCoordinate");

    final googleMapAvailable = await MapLauncher.isMapAvailable(MapType.google);
    final appleMapAvailable = await MapLauncher.isMapAvailable(MapType.apple);

    if (googleMapAvailable == true) {
      MapLauncher.showMarker(
        mapType: MapType.google,
        coords: Coords(job!.endAddressCordinates!.latitude ?? 0.00,
            job!.endAddressCordinates!.longitude ?? 0.00),
        title: job!.endAddress!,
      );
    } else if (appleMapAvailable == true) {
      MapLauncher.showMarker(
        mapType: MapType.apple,
        coords: Coords(job!.endAddressCordinates?.latitude ?? 0.00,
            job!.endAddressCordinates!.longitude ?? 0.00),
        title: job!.endAddress!,
      );
    } else {
      print("Neither Google Maps nor Apple Maps is available.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          previous.isStarted != current.isStarted,
      listener: (context, state) async {
        if (state.isStarted) {
          setState(() {
            isStarted = true;
          });
          context
              .read<HomeBloc>()
              .add(GetTrackingCoordinate(state.showJob!.id));
          showTopSnackBarFr(context, message: 'Job created successfully');
          context.read<HomeBloc>().add(GetJob(state.showJob!.id.toString()));
          context.read<InspectionsBloc>().add(GetJobInspections(
                jobId: state.showJob!.id,
              ));
          if (state.showJob?.isDriverConfirm != true) {
            context
                .read<HomeBloc>()
                .add(ConfirmJob(state.showJob?.id ?? 0, true));
          }
          PlatformNetworkCredentialsManager.setCredentials(
            jobId: state.showJob!.id,
            token:
                ProductStateItems.hiveDatabaseManager.getUserModel()!.token ??
                    "",
            url: ServicePath.jobTrackings.value,
          );

          if (!await LocationServiceManager().isServiceStarted()) {
            await LocationServiceManager().startService();
          }
        }
      },
      builder: (context, state) {
        if (widget.asyncJob == true && widget.jobId != job?.id.toString()) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: context.theme.colorScheme.surface,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/fr_empty_job.png',
                      width: 130,
                      height: 130,
                    ),
                    SizedBox(
                      height: context.dynamicHeight(0.03),
                    ),
                    Text(
                      'No jobs found. Maybe you are offline. Please check your internet connection.',
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyLarge,
                    )
                  ],
                ),
              ));
        }
        if (state.status == ViewStatus.loading) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: context.theme.colorScheme.surface,
              leading: widget.asyncJob != true
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        context.pop();
                      },
                    )
                  : null,
            ),
            body: const Center(
              child: LoadingProgress(),
            ),
          );
        }
        if (widget.asyncJob == true && state.showJob == null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: context.theme.colorScheme.surface,
            ),
            body: const Center(
              child: Text("No jobs found. Please contact the administrator."),
            ),
          );
        }
        if (state.showJob != null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: context.theme.colorScheme.surface,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: context.theme.colorScheme.primary,
                  size: 24,
                ),
                onPressed: () {
                  if (widget.isSigned == true) {
                    context.go("/home_page");
                    return;
                  }
                  context.pop();
                },
              ),
            ),
            body: WillPopScope(
              onWillPop: () async {
                if (widget.asyncJob == true) {
                  return false;
                }
                return true;
              },
              child: _jobDetailPageBody(
                context,
                state,
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: context.theme.colorScheme.surface,
            leading: widget.asyncJob != true
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      context.pop();
                    },
                  )
                : null,
          ),
          body: const Center(
            child: LoadingProgress(),
          ),
        );
      },
    );
  }

  SingleChildScrollView _jobDetailPageBody(
    BuildContext context,
    HomeState state,
  ) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          Padding(
            padding: context.paddingAllDefault,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      capitalizeFirstLetter(
                        state.showJob!.movementTypeId?.name ?? "",
                      ),
                      style: context.textTheme.headlineMedium,
                    ),
                    const SizedBox.shrink()
                  ],
                ),
                const VerticalSpace.small(),
                const VerticalSpace.small(),
                CustomInfoCard(
                  jobModel: state.showJob!,
                  state: state,
                ),
                const VerticalSpace.small(),
                CustomCard(
                  onChanged: (value) async {},
                  jobModel: state.showJob!,
                  isToday: false,
                  isDetail: true,
                ),
                const VerticalSpace.small(),
                CustomProfileCard(
                  jobModel: state.showJob!,
                ),
              ],
            ),
          ),
          if (ProductStateItems.hiveDatabaseManager.getUserModel()?.isStarted ==
                      true &&
                  ProductStateItems.hiveDatabaseManager
                          .getUserModel()
                          ?.currentJobId ==
                      state.showJob?.id
              ? true
              : state.showJob?.status != 2)
            Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: context.paddingAllDefault,
                child: Column(
                  children: [
                    widget.isCameHomePage == true
                        ? CustomAppButton(
                            isCustomColor: state.showJob?.status == 1 ||
                                isStarted ||
                                widget.asyncJob == true,
                            text: state.showJob?.status == 1 ||
                                    isStarted ||
                                    widget.asyncJob == true
                                ? "Finish Job"
                                : "Start Job",
                            ontap: () {
                              if (state.showJob?.status == 1 ||
                                  isStarted ||
                                  widget.asyncJob == true) {
                                context.push("/finish_job_page", extra: {
                                  "isFuelView": job
                                                  ?.movementTypeId!
                                                  .availableFuelEvLevelInputs
                                                  .isEmpty ==
                                              false ||
                                          state
                                                  .showJob
                                                  ?.movementTypeId!
                                                  .availableFuelEvLevelInputs
                                                  .isEmpty ==
                                              false
                                      ? true
                                      : false,
                                  "isFeedbackView": job?.movementTypeId!
                                              .feedbackInputs?.showAnyInput ==
                                          true ||
                                      state.showJob?.movementTypeId!
                                              .feedbackInputs?.showAnyInput ==
                                          true,
                                  "feedbackInputAvailability":
                                      job?.movementTypeId!.feedbackInputs ??
                                          state.showJob?.movementTypeId!
                                              .feedbackInputs,
                                });
                              } else {
                                if (state.showJob?.status == 1 ||
                                    isStarted ||
                                    widget.asyncJob == true) {
                                  context.push("/finish_job_page", extra: {
                                    "isFuelView": job
                                                    ?.movementTypeId!
                                                    .availableFuelEvLevelInputs
                                                    .isEmpty ==
                                                false ||
                                            state
                                                    .showJob
                                                    ?.movementTypeId!
                                                    .availableFuelEvLevelInputs
                                                    .isEmpty ==
                                                false
                                        ? true
                                        : false,
                                    "isFeedbackView": job?.movementTypeId!
                                                .feedbackInputs?.showAnyInput ==
                                            true ||
                                        state.showJob?.movementTypeId!
                                                .feedbackInputs?.showAnyInput ==
                                            true,
                                    "feedbackInputAvailability":
                                        job?.movementTypeId!.feedbackInputs ??
                                            state.showJob?.movementTypeId!
                                                .feedbackInputs,
                                  });
                                } else {
                                  context
                                      .read<HomeBloc>()
                                      .add(StartJob(state.showJob!, context));
                                }
                              }
                            })
                        : const SizedBox.shrink(),
                    const VerticalSpace.small(),
                    if (state.showJob?.status == 1 ||
                        isStarted ||
                        widget.asyncJob == true)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomGreyAppButton(
                            textColor: context.theme.colorScheme.primary,
                            text: "Inspect",
                            containerColor: context.theme.colorScheme.surface,
                            ontap: () async {
                              BotToast.showLoading();
                              final result = await hasNetwork();
                              context
                                  .read<InspectionsBloc>()
                                  .add(GetJobInspections(
                                    jobId: state.showJob!.id,
                                  ));
                              context.push("/inspection_page", extra: {
                                "isAsync": !result,
                              });
                              BotToast.closeAllLoading();
                            },
                          ),
                          const VerticalSpace.xSmall(),
                          CustomGreyAppButton(
                            textColor: context.theme.colorScheme.primary,
                            text: "Open Map",
                            containerColor: context.theme.colorScheme.surface,
                            ontap: () {
                              context.push("/map_view_page2");
                            },
                          ),
                          const VerticalSpace.xSmall(),
                          if (showExtraButtons) ...[
                            const VerticalSpace.xSmall(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomGreyAppButton(
                                    width: context.dynamicWidth(0.44),
                                    textColor:
                                        context.theme.colorScheme.primary,
                                    text: "Add Stop",
                                    containerColor:
                                        context.theme.colorScheme.surface,
                                    ontap: () {
                                      context.push("/add_stop_page");
                                    }),
                                const HorizontalSpace.xxSmall(),
                                CustomGreyAppButton(
                                    width: context.dynamicWidth(0.44),
                                    textColor:
                                        context.theme.colorScheme.primary,
                                    text: "View Expenses",
                                    containerColor:
                                        context.theme.colorScheme.surface,
                                    ontap: () async {
                                      BotToast.showLoading();
                                      final result = await hasNetwork();
                                      context
                                          .push("/view_expenses_page", extra: {
                                        "isAsync": !result,
                                        "jobId": state.showJob!.id,
                                      });
                                      BotToast.closeAllLoading();
                                    }),
                              ],
                            ),
                            const VerticalSpace.xSmall(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomGreyAppButton(
                                    width: context.dynamicWidth(0.44),
                                    textColor:
                                        context.theme.colorScheme.primary,
                                    text: "Add Expense",
                                    containerColor:
                                        context.theme.colorScheme.surface,
                                    ontap: () {
                                      context.push("/expense_details", extra: {
                                        "jobId": state.showJob!.id,
                                      });
                                    }),
                                const HorizontalSpace.xxSmall(),
                                CustomGreyAppButton(
                                    width: context.dynamicWidth(0.44),
                                    textColor:
                                        context.theme.colorScheme.primary,
                                    text: "Navigation",
                                    containerColor:
                                        context.theme.colorScheme.surface,
                                    ontap: () {
                                      if (state.showJob
                                                  ?.startAddressCordinates ==
                                              null ||
                                          state.showJob?.endAddressCordinates ==
                                              null ||
                                          state.showJob?.startAddress == null ||
                                          state.showJob?.endAddress == null) {
                                        BotToast.showText(
                                            text:
                                                'The address and location cannot be shown because they cannot be found.');
                                      } else {
                                        _launchMap();
                                      }
                                    }),
                              ],
                            ),
                            const VerticalSpace.xSmall(),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (job
                                              ?.movementTypeId!
                                              .availableFuelEvLevelInputs
                                              .isEmpty ==
                                          false ||
                                      state
                                              .showJob
                                              ?.movementTypeId!
                                              .availableFuelEvLevelInputs
                                              .isEmpty ==
                                          false)
                                    CustomGreyAppButton(
                                        width: context.dynamicWidth(0.44),
                                        textColor:
                                            context.theme.colorScheme.primary,
                                        text: "Fuel/EV Level",
                                        containerColor:
                                            context.theme.colorScheme.surface,
                                        ontap: () {
                                          context.push("/fuel_level_page",
                                              extra: {
                                                "jobId": job == null
                                                    ? state.showJob?.id
                                                    : job?.id
                                              });
                                        }),
                                  if (job?.movementTypeId!.feedbackInputs
                                              ?.showAnyInput ==
                                          true ||
                                      state.showJob?.movementTypeId!
                                              .feedbackInputs?.showAnyInput ==
                                          true)
                                    CustomGreyAppButton(
                                        width: context.dynamicWidth(0.44),
                                        textColor:
                                            context.theme.colorScheme.primary,
                                        text: "Feedback",
                                        containerColor:
                                            context.theme.colorScheme.surface,
                                        ontap: () {
                                          // print(ProductStateItems
                                          //     .hiveDatabaseManager
                                          //     .getUserModel()
                                          //     ?.currentJobId);
                                          // print(state.showJob!.id);
                                          context
                                              .push("/feedback_page", extra: {
                                            "feedbackInputAvailability": job
                                                    ?.movementTypeId
                                                    ?.feedbackInputs ??
                                                state.showJob?.movementTypeId
                                                    ?.feedbackInputs
                                          });
                                        }),
                                ]),
                            const VerticalSpace.xSmall(),
                          ],
                          const VerticalSpace.xxSmall(),
                          CustomGreyAppButton(
                            containerColor: context.theme.colorScheme.surface,
                            textColor: context.theme.colorScheme.primary,
                            text: showExtraButtons ? "Less" : "More",
                            ontap: () {
                              setState(() {
                                showExtraButtons = !showExtraButtons;
                              });
                              final targetExtent = showExtraButtons
                                  ? scrollController.position.maxScrollExtent +
                                      context.dynamicHeight(0.25)
                                  : scrollController.position.minScrollExtent -
                                      context.dynamicHeight(0.1);

                              scrollController.animateTo(
                                targetExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          const VerticalSpace.small(),
        ],
      ),
    );
  }
}
