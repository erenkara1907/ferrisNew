import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/edit_details_page.dart';
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

class FuelLevelPage extends StatefulWidget {
  final int jobId;
  const FuelLevelPage({Key? key, required this.jobId}) : super(key: key);

  @override
  State<FuelLevelPage> createState() => _FuelLevelPageState();
}

class _FuelLevelPageState extends State<FuelLevelPage> {
  late final HiveStorageManager _hiveStorageManager;
  String? _selectedLevelAtHub;
  String? _selectedLevelDelivery;
  UpdateJobStatusPostModel? updateModel;

  List<String> generateLevelList() {
    List<String> levelList = [];
    for (int i = 1; i <= 100; i++) {
      if (i % 10 == 0) {
        levelList.add(i.toString());
      }
    }
    return levelList;
  }

  @override
  void initState() {
    _hiveStorageManager = ProductStateItems.hiveStorageManager;
    getJobUpdate(_hiveStorageManager);
    super.initState();
  }

  void getJobUpdate(HiveStorageManager hiveStorageManager) {
    setState(() {
      final result = hiveStorageManager.getJopUpdatePage();
      updateModel = result;
      print(updateModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.status == ViewStatus.success) {
          showTopSnackBarFr(context, message: 'Fuel level saved successfully');
          context.pop();
          context.pop();
        }
      },
      builder: (context, state) {
        if (state.status == ViewStatus.loading) {
          _selectedLevelAtHub = null;
          _selectedLevelDelivery = null;
          return const Scaffold(
            body: Center(
              child: LoadingProgress(),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: context.theme.colorScheme.background,
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
              children: [
                Row(
                  children: [
                    Text(
                      'Fuel Level',
                      style: context.textTheme.headlineMedium,
                    ),
                  ],
                ),
                const VerticalSpace.small(),
                DropdownButtonWidget(
                  value: '${_selectedLevelAtHub}%',
                  text: 'Fuel/EV Charge Level at Hub',
                  hintText: updateModel?.fuelChargeLevelCollection.toString() ??
                      'Choose the level',
                  onChanged: (value) {
                    setState(() {
                      _selectedLevelAtHub = value;
                    });
                  },
                  items: generateLevelList().map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text('$value%'),
                    );
                  }).toList(),
                  textSpanEnable: true,
                ),
                const VerticalSpace.small(),
                DropdownButtonWidget(
                  value: '${_selectedLevelDelivery}%',
                  text: 'Fuel/EV Charge Level at Delivery',
                  hintText: updateModel?.fuelChargeLevelDelivery.toString() ??
                      'Choose the level',
                  onChanged: (value) {
                    setState(() {
                      _selectedLevelDelivery = value;
                    });
                  },
                  items: generateLevelList().map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text('$value%'),
                    );
                  }).toList(),
                  textSpanEnable: true,
                ),
                const VerticalSpace.medium(),
                CustomAppButton(
                  text: "Save",
                  ontap: () {
                    if (_selectedLevelAtHub == null &&
                        _selectedLevelDelivery == null) {
                      showTopSnackBarFr(context,
                          message: 'Please select fuel level');
                      return;
                    }
                    context.read<HomeBloc>().add(
                          UpdateJob(
                              widget.jobId.toString(),
                              UpdateJobStatusPostModel(
                                timestamp: DateTime.now().toIso8601String(),
                                fuelChargeLevelCollection:
                                    _selectedLevelAtHub != null
                                        ? int.parse(_selectedLevelAtHub!)
                                        : updateModel!
                                            .fuelChargeLevelCollection,
                                fuelChargeLevelDelivery:
                                    _selectedLevelDelivery != null
                                        ? int.parse(_selectedLevelDelivery!)
                                        : updateModel!.fuelChargeLevelDelivery,
                                vehicleFeedback: updateModel?.vehicleFeedback,
                                customerFeedback: updateModel?.customerFeedback,
                              ),
                              false),
                        );
                    context.pop();
                  },
                  enabled: true,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
