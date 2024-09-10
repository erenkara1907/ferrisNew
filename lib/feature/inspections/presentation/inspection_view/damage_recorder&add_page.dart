import 'package:ferrisfwt/feature/home/data/models/damages/damage_response_model.dart';
import 'package:ferrisfwt/feature/inspections/presentation/bloc/inspections_bloc.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_horizontal_spacer.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RecordedDamages extends StatefulWidget {
  final int jobInspectionId;
  final List<int> standardIds;

  const RecordedDamages({
    super.key,
    required this.jobInspectionId,
    required this.standardIds,
  });

  @override
  State<RecordedDamages> createState() => RecordedDamagesState();
}

class RecordedDamagesState extends State<RecordedDamages> {
  late final HiveStorageManager _hiveStorageManager;
  late final bool isSigned;
  @override
  void initState() {
    isSigned =
        ProductStateItems.hiveDatabaseManager.getUserModel()!.inspectionsSign !=
                null &&
            ProductStateItems.hiveDatabaseManager
                .getUserModel()!
                .inspectionsSign!
                .contains(widget.jobInspectionId);
    super.initState();
    _hiveStorageManager = ProductStateItems.hiveStorageManager;

    context.read<InspectionsBloc>().add(SetGetDamages(widget.jobInspectionId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InspectionsBloc, InspectionsState>(
      builder: (context, state) {
        if (state.status == ViewStatus.loading) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Damages', style: context.textTheme.titleSmall),
              backgroundColor: context.theme.colorScheme.surface,
            ),
            body: const Center(
              child: LoadingProgress(),
            ),
          );
        }
        final bool isSigned = ProductStateItems.hiveDatabaseManager
                    .getUserModel()!
                    .inspectionsSign !=
                null &&
            ProductStateItems.hiveDatabaseManager
                .getUserModel()!
                .inspectionsSign!
                .contains(widget.jobInspectionId);
        return Scaffold(
          appBar: AppBar(
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
            backgroundColor: context.theme.colorScheme.surface,
            title: Text('Damages', style: context.textTheme.titleSmall),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSigned)
                SizedBox(
                  width: context.width,
                  child: Center(
                    child: Padding(
                      padding: context.paddingVerticalDefault,
                      child: CustomAppButton(
                        text: 'Add Damage',
                        ontap: () {
                          context.push('/damages_page', extra: {
                            'jobInspectionId': widget.jobInspectionId,
                            "standardIds": widget.standardIds,
                          });
                        },
                      ),
                    ),
                  ),
                ),
              const Divider(
                color: Colors.black,
                thickness: 0.4,
              ),
              Padding(
                padding: context.paddingHorizontalLow + context.paddingTopLow,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Recorded Damages: ',
                    style: context.textTheme.titleMedium,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: context.paddingHorizontalDefault,
                  child: Column(
                    mainAxisAlignment: state.damageResponse.isEmpty
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.damageResponse.isEmpty)
                        Align(
                          alignment: Alignment.center,
                          child: Center(
                              child: Column(
                            children: [
                              Image.asset(
                                'assets/images/fr_car_damage.png',
                                width: 130,
                                height: 130,
                              ),
                              const VerticalSpace.xSmall(),
                              Text(
                                'No Damage Found',
                                style: context.textTheme.bodyLarge,
                              )
                            ],
                          )),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.damageResponse.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  DamageCardWidget(
                                    standarIds: widget.standardIds,
                                    inspection: widget.jobInspectionId,
                                    damageResponse: state.damageResponse[index],
                                  ),
                                  isSigned == false
                                      ? Positioned(
                                          top: 7,
                                          right: 0,
                                          child: IconButton(
                                            onPressed: () async {
                                              List<DamageResponseModel> damage =
                                                  await _hiveStorageManager
                                                      .getGetDamage(widget
                                                          .jobInspectionId);

                                              context
                                                  .read<InspectionsBloc>()
                                                  .add(
                                                    DeleteRecordedDamage(
                                                      damage[index].id,
                                                      widget.jobInspectionId,
                                                      damage[index]
                                                              .combinationId ??
                                                          0,
                                                      stateDamageId: state
                                                          .damageResponse[index]
                                                          .id,
                                                    ),
                                                  );
                                            },
                                            icon: Icon(
                                              Icons.cancel_outlined,
                                              color: context
                                                  .theme.colorScheme.error,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink()
                                ],
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DamageCardWidget extends StatelessWidget {
  final DamageResponseModel damageResponse;
  final int inspection;
  final List<int> standarIds;
  const DamageCardWidget({
    super.key,
    required this.damageResponse,
    required this.inspection,
    required this.standarIds,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          "/damage_detail_page",
          extra: {
            "damageResponse": damageResponse,
            "inspection": inspection,
            "standardIds": standarIds,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.primaryContainer,
          border: Border.all(
            color: context.theme.colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: context.paddingVerticalLow,
        child: Padding(
          padding:
              context.paddingHorizontalDefault + context.paddingVerticalLow,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Category: ',
                          style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: damageResponse.categoryId.name,
                          style: context.textTheme.bodyMedium
                              ?.copyWith(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Part: ',
                      style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: damageResponse.partId.name,
                      style: context.textTheme.bodyMedium
                          ?.copyWith(color: Colors.white),
                    )
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Issue: ',
                      style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: damageResponse.issueId.name,
                      style: context.textTheme.bodyMedium
                          ?.copyWith(color: Colors.white),
                    )
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Failure: ',
                      style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: damageResponse.failureId.name,
                      style: context.textTheme.bodyMedium
                          ?.copyWith(color: Colors.white),
                    )
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Repair: ',
                      style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: damageResponse.repairId.name,
                      style: context.textTheme.bodyMedium
                          ?.copyWith(color: Colors.white),
                    )
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Price: ',
                      style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: damageResponse.price != null
                          ? '£${damageResponse.price}0'
                          : "-",
                      style: context.textTheme.bodyMedium
                          ?.copyWith(color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
