import 'package:bot_toast/bot_toast.dart';
import 'package:ferrisfwt/feature/inspections/data/models/checklist/checklist_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/presentation/bloc/inspections_bloc.dart';
import 'package:ferrisfwt/feature/inspections/presentation/widget/item_check_list_model.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/checklist/inspection_checklist_post_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/popup/question_popup.dart';
import 'package:flutter/material.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ItemCheckListPage extends StatefulWidget {
  final int inspectionId;
  const ItemCheckListPage({super.key, required this.inspectionId});

  @override
  State<ItemCheckListPage> createState() => _ItemCheckListPageState();
}

class _ItemCheckListPageState extends State<ItemCheckListPage> {
  late final List<ChecklistResponseModelItem> savedChecklist2;
  List<List<bool>> _selectedChecklist = List.generate(9, (index) => [false, false, false]);
  bool checkListisSaved = false;
  late final HiveStorageManager _hiveStorageManager;
  InspectionChecklistPostModel? updateModel;

  @override
  void initState() {
    _hiveStorageManager = ProductStateItems.hiveStorageManager;
    context.read<InspectionsBloc>().add(GetJobInspectionsCheckList(inspectionId: widget.inspectionId));
    _loadChecklist();
    super.initState();
  }

  void _loadChecklist() async {
    final savedChecklist = _hiveStorageManager.getItemCheckList(widget.inspectionId);
    if (savedChecklist != null) {
      setState(() {
        _selectedChecklist = [
          _convertToBoolList(savedChecklist.inflatorKit),
          _convertToBoolList(savedChecklist.evCable),
          _convertToBoolList(savedChecklist.jack),
          _convertToBoolList(savedChecklist.spareWheel),
          _convertToBoolList(savedChecklist.gelCompressorKit),
          _convertToBoolList(savedChecklist.thirteenAmpEvChargingCable),
          _convertToBoolList(savedChecklist.hvChargingCable),
          _convertToBoolList(savedChecklist.spareKey),
          _convertToBoolList(savedChecklist.masterKey),
        ];
      });
    }
  }

  List<bool> _convertToBoolList(int value) {
    switch (value) {
      case 1:
        return [true, false, false];
      case 2:
        return [false, true, false];
      case 3:
        return [false, false, true];
      default:
        return [false, false, false];
    }
  }

  Future<void> _saveChecklist() async {
    final model = InspectionChecklistPostModel(
      jobInspectionId: widget.inspectionId,
      inflatorKit: _selectedChecklist[0][0]
          ? 1
          : _selectedChecklist[0][1]
              ? 2
              : 3,
      evCable: _selectedChecklist[1][0]
          ? 1
          : _selectedChecklist[1][1]
              ? 2
              : 3,
      jack: _selectedChecklist[2][0]
          ? 1
          : _selectedChecklist[2][1]
              ? 2
              : 3,
      spareWheel: _selectedChecklist[3][0]
          ? 1
          : _selectedChecklist[3][1]
              ? 2
              : 3,
      gelCompressorKit: _selectedChecklist[4][0]
          ? 1
          : _selectedChecklist[4][1]
              ? 2
              : 3,
      thirteenAmpEvChargingCable: _selectedChecklist[5][0]
          ? 1
          : _selectedChecklist[5][1]
              ? 2
              : 3,
      hvChargingCable: _selectedChecklist[6][0]
          ? 1
          : _selectedChecklist[6][1]
              ? 2
              : 3,
      spareKey: _selectedChecklist[7][0]
          ? 1
          : _selectedChecklist[7][1]
              ? 2
              : 3,
      masterKey: _selectedChecklist[8][0]
          ? 1
          : _selectedChecklist[8][1]
              ? 2
              : 3,
    );
    await _hiveStorageManager.setItemCheckList(model);
  }

  bool isChecklistCompleted() {
    for (var list in _selectedChecklist) {
      if (!list.contains(true)) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InspectionsBloc, InspectionsState>(
      listener: (context, state) {
        if (state.status == ViewStatus.success && checkListisSaved) {
          checkListisSaved = false;
          _selectedChecklist = List.generate(9, (index) => [false, false, false]);
          showTopSnackBarFr(context, message: 'Checklist saved successfully');
          context.pop();
        }
        if (state.status == ViewStatus.failure) {
          // BotToast.showText(text: state.failure.toString());
        }
      },
      builder: (context, state) {
        if (state.status == ViewStatus.loading) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Item Checklist',
                style: context.textTheme.titleSmall,
              ),
              backgroundColor: context.theme.colorScheme.surface,
            ),
            body: const Center(
              child: LoadingProgress(),
            ),
          );
        }
        final bool isSigned = ProductStateItems.hiveDatabaseManager.getUserModel()!.inspectionsSign != null &&
            ProductStateItems.hiveDatabaseManager.getUserModel()!.inspectionsSign!.contains(widget.inspectionId);
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
            title: Text('Item Checklist', style: context.textTheme.titleSmall),
          ),
          body: Scaffold(
            body: Column(
              children: [
                Expanded(
                  flex: 18,
                  child: Card(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        );
                      },
                      itemCount: ItemChecklistModel.emptyForm.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: context.paddingHorizontalLow,
                              child: Text(
                                ItemChecklistModel.emptyForm[index].title,
                                style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: CheckboxListTile(
                                    activeColor: Colors.green,
                                    checkColor: Colors.white,
                                    checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    title: Text("Yes", style: context.textTheme.bodyMedium),
                                    value: _selectedChecklist[index][0],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedChecklist[index] = [value!, false, false];
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: CheckboxListTile(
                                    activeColor: Colors.red,
                                    checkColor: Colors.white,
                                    checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    title: Text("No", style: context.textTheme.bodyMedium),
                                    value: _selectedChecklist[index][1],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedChecklist[index] = [false, value!, false];
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: CheckboxListTile(
                                    activeColor: Colors.black,
                                    checkColor: Colors.white,
                                    checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    title: Text("N/A", style: context.textTheme.bodyMedium),
                                    value: _selectedChecklist[index][2],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedChecklist[index] = [false, false, value!];
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                if (!isSigned)
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: context.dynamicHeight(0.05),
                      width: context.width,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 6.0,
                            spreadRadius: 0.2,
                            offset: Offset(2, 0),
                          ),
                        ],
                        color: context.theme.colorScheme.onSurfaceVariant,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: context.paddingHorizontalDefault + context.paddingBottomHigh + context.paddingTopLow,
                        child: CustomAppButton(
                          text: 'Save',
                          ontap: () async {
                            List<ChecklistResponseModelItem>? checkLists =
                                await _hiveStorageManager.getInspectionChecklists();
                            final bool result = isChecklistCompleted();
                            if (!result) {
                              BotToast.showText(text: "Please answer all questions");
                              return;
                            }
                            setState(() {
                              checkListisSaved = true;
                            });
                            // await _saveChecklist();
                            context.read<InspectionsBloc>().add(
                                  PostJobInspectionsCheckList(
                                    InspectionChecklistPostModel(
                                      jobInspectionId: widget.inspectionId,
                                      inflatorKit: _selectedChecklist[0][0]
                                          ? 1
                                          : _selectedChecklist[0][1]
                                              ? 2
                                              : 3,
                                      evCable: _selectedChecklist[1][0]
                                          ? 1
                                          : _selectedChecklist[1][1]
                                              ? 2
                                              : 3,
                                      jack: _selectedChecklist[2][0]
                                          ? 1
                                          : _selectedChecklist[2][1]
                                              ? 2
                                              : 3,
                                      spareWheel: _selectedChecklist[3][0]
                                          ? 1
                                          : _selectedChecklist[3][1]
                                              ? 2
                                              : 3,
                                      gelCompressorKit: _selectedChecklist[4][0]
                                          ? 1
                                          : _selectedChecklist[4][1]
                                              ? 2
                                              : 3,
                                      thirteenAmpEvChargingCable: _selectedChecklist[5][0]
                                          ? 1
                                          : _selectedChecklist[5][1]
                                              ? 2
                                              : 3,
                                      hvChargingCable: _selectedChecklist[6][0]
                                          ? 1
                                          : _selectedChecklist[6][1]
                                              ? 2
                                              : 3,
                                      spareKey: _selectedChecklist[7][0]
                                          ? 1
                                          : _selectedChecklist[7][1]
                                              ? 2
                                              : 3,
                                      masterKey: _selectedChecklist[8][0]
                                          ? 1
                                          : _selectedChecklist[8][1]
                                              ? 2
                                              : 3,
                                    ),
                                    false,
                                    _hiveStorageManager.getItemCheckList(widget.inspectionId) != null,
                                    state.checklists.isNotEmpty ? state.checklists[0].id : 0,
                                  ),
                                );
                            Navigator.pop(context);
                            showTopSnackBarFr(context, message: 'Checklist saved successfully');
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
