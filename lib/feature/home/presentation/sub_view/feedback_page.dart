import 'package:bot_toast/bot_toast.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/movement_type/feedback_input_availability.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/sub_view/expense_detail_page.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/update_job_status_post_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/popup/question_popup.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key, required this.feedbackInputAvailability})
      : super(key: key);
  final FeedbackInputAvailability feedbackInputAvailability;

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  late final HiveStorageManager _hiveStorageManager;
  UpdateJobStatusPostModel? updateModel;
  final bool _isSaveButtonEnabled = false;
  final TextEditingController _customerFeedbackController =
      TextEditingController();
  final TextEditingController _vehicleFeedbackController =
      TextEditingController();

  @override
  void dispose() {
    _customerFeedbackController.dispose();
    _vehicleFeedbackController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _hiveStorageManager = ProductStateItems.hiveStorageManager;
    getJobUpdate(_hiveStorageManager);
    _customerFeedbackController.text = updateModel?.customerFeedback ?? '';
    _vehicleFeedbackController.text = updateModel?.vehicleFeedback ?? '';
    super.initState();
  }

  void getJobUpdate(HiveStorageManager hiveStorageManager) {
    setState(() {
      final result = hiveStorageManager.getJopUpdatePage();
      updateModel = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.status == ViewStatus.success) {
          showTopSnackBarFr(context, message: 'Feedback saved successfully');
          context.pop();
        }
      },
      builder: (context, state) {
        if (state.status == ViewStatus.loading) {
          return const Scaffold(
            body: Center(
              child: LoadingProgress(),
            ),
          );
        }
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
          body: SingleChildScrollView(
            child: Padding(
              padding: context.paddingAllDefault,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Feedback',
                        style: context.textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  const VerticalSpace.small(),
                  if (widget.feedbackInputAvailability.customer.isRequired)
                    Column(
                      children: [
                        CustomJobTextfield(
                          height: context.dynamicHeight(0.12),
                          expands: true,
                          controller: _customerFeedbackController,
                          text: "Customer Feedback",
                          hintText: "Enter feedback...",
                        ),
                        const VerticalSpace.xxSmall(),
                        Padding(
                          padding: context.paddingHorizontalDefault,
                          child: Text(
                              "Provide any information relating to the customer’s experience with the vehicle and the company in general",
                              style: context.textTheme.bodySmall
                                  ?.copyWith(fontSize: 10)),
                        ),
                      ],
                    ),
                  const VerticalSpace.small(),
                  if (widget.feedbackInputAvailability.vehicle.isRequired)
                    Column(
                      children: [
                        CustomJobTextfield(
                          expands: true,
                          height: context.dynamicHeight(0.12),
                          controller: _vehicleFeedbackController,
                          text: "Vehicle Feedback",
                          hintText: "Enter feedback...",
                        ),
                        const VerticalSpace.xxSmall(),
                        Padding(
                          padding: context.paddingHorizontalDefault,
                          child: Text(
                              "Provide any information relating to the vehicle state when collected from hub (cleanliness, refurb quality, etc)",
                              style: context.textTheme.bodySmall
                                  ?.copyWith(fontSize: 10)),
                        ),
                      ],
                    ),
                  const VerticalSpace.small(),
                  CustomAppButton(
                    enabled: true,
                    text: "Save",
                    ontap: () {
                      final customerFeedback =
                          _customerFeedbackController.text.isNotEmpty
                              ? _customerFeedbackController.text
                              : updateModel?.customerFeedback ?? '';
                      final vehicleFeedback =
                          _vehicleFeedbackController.text.isNotEmpty
                              ? _vehicleFeedbackController.text
                              : updateModel?.vehicleFeedback ?? '';

                      if (_customerFeedbackController.text.isEmpty &&
                          _vehicleFeedbackController.text.isEmpty) {
                        BotToast.showText(text: 'No changes were made');
                        return;
                      }
                      context.read<HomeBloc>().add(
                            UpdateJob(
                              ProductStateItems.hiveDatabaseManager
                                      .getUserModel()
                                      ?.currentJobId ??
                                  '${state.showJob!.id}',
                              UpdateJobStatusPostModel(
                                timestamp: DateTime.now().toString(),
                                vehicleFeedback: vehicleFeedback,
                                customerFeedback: customerFeedback,
                                fuelChargeLevelCollection:
                                    updateModel?.fuelChargeLevelCollection ?? 0,
                                fuelChargeLevelDelivery:
                                    updateModel?.fuelChargeLevelDelivery ?? 0,
                              ),
                              false,
                            ),
                          );
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
}
