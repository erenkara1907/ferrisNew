import 'package:bot_toast/bot_toast.dart';
import 'package:ferrisfwt/feature/home/presentation/widget/job_page_inspection_card.dart';
import 'package:ferrisfwt/feature/inspections/presentation/bloc/inspections_bloc.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/mixin/network_mixin.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../home/data/models/damages/damage_response_model.dart';

class InspectionPage extends StatefulWidget {
  final bool? isAsync;
  final bool? isSigned;
  const InspectionPage({super.key, this.isAsync = false, this.isSigned = false});

  @override
  State<InspectionPage> createState() => _InspectionPageState();
}

class _InspectionPageState extends State<InspectionPage> {
  @override
  void initState() {
    super.initState();
    if (context.read<InspectionsBloc>().state.inspections.isEmpty) {
      if (widget.isAsync == false) {
        context.read<InspectionsBloc>().add(GetJobInspections(
            jobId: int.parse(ProductStateItems.hiveDatabaseManager.getUserModel()?.currentJobId ?? "0"),
            regnNumber: ProductStateItems.hiveDatabaseManager.getUserModel()?.regnNumber));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InspectionsBloc, InspectionsState>(
      builder: (context, state) {
        if (state.inspectionStatus == ViewStatus.loading) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Inspection', style: context.textTheme.titleSmall),
              backgroundColor: context.theme.colorScheme.surface,
            ),
            body: const Center(
              child: LoadingProgress(),
            ),
          );
        }
        if (state.inspectionStatus != ViewStatus.success &&
            state.inspectionStatus != ViewStatus.loading &&
            state.inspections.isEmpty) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Inspection', style: context.textTheme.titleSmall),
                backgroundColor: context.theme.colorScheme.surface,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: context.theme.colorScheme.primary,
                    size: 24,
                  ),
                  onPressed: () {
                    if (widget.isSigned == true) {
                      context.replace('/job_detail_page', extra: {
                        'jobId': ProductStateItems.hiveDatabaseManager.getUserModel()?.currentJobId,
                        'asyncJob': false,
                      });
                      return;
                    }
                    context.pop();
                  },
                ),
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
                    const VerticalSpace.xSmall(),
                    Text(
                      'No Inspection Found.',
                      style: context.textTheme.bodyLarge,
                    )
                  ],
                ),
              ));
        }

        return Scaffold(
            appBar: AppBar(
              title: Text('Inspection', style: context.textTheme.titleSmall),
              backgroundColor: context.theme.colorScheme.surface,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: context.theme.colorScheme.primary,
                  size: 24,
                ),
                onPressed: () async {
                  BotToast.showLoading();
                  final result = await hasNetwork();
                  if (widget.isSigned == true) {
                    context.replace('/job_detail_page', extra: {
                      'jobId': ProductStateItems.hiveDatabaseManager.getUserModel()?.currentJobId,
                      'asyncJob': !result,
                      'isSigned': true,
                    });
                    BotToast.closeAllLoading();
                    return;
                  }
                  BotToast.closeAllLoading();
                  context.pop();
                },
              ),
            ),
            body: state.inspections.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          child: Image.asset(
                            'assets/images/fr_empty_job.png',
                            width: 130,
                            height: 130,
                          ),
                        ),
                        const VerticalSpace.xSmall(),
                        Text(
                          'No Inspection Found.',
                          style: context.textTheme.bodyLarge,
                        )
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: state.inspections.length,
                    itemBuilder: (BuildContext context, int index) {
                      // final damage = index < state.damageResponse.length
                      //     ? state.damageResponse[index]
                      //     : null;

                      return InspectionCustomInfoCard(
                        inspection: state.inspections[index]!,
                        inspectionState: state,
                        index: index,
                      );
                      // if (state.damageResponse.isNotEmpty &&
                      //     state.inspections.isNotEmpty) {
                      // }

                      // List<DamageResponseModel> trimmedDamageResponse =
                      //     state.damageResponse.isNotEmpty
                      //         ? [state.damageResponse.last]
                      //         : [];

                      // if (trimmedDamageResponse.isNotEmpty &&
                      //     index < trimmedDamageResponse.length) {
                      //   return InspectionCustomInfoCard(
                      //     // damageResponse: trimmedDamageResponse[index],
                      //     inspection: state.inspections[index]!,
                      //   );
                      // } else {
                      //   return InspectionCustomInfoCard(
                      //     inspection: state.inspections[index]!,
                      //   );
                      // }
                    },
                  ));
      },
    );
  }
}
