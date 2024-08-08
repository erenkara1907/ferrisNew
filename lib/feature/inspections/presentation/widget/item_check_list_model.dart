import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/checklist/inspection_checklist_post_model.dart';
import 'package:ferrisfwt/product/utility/enums/Item_check_list_enum.dart';

class ItemChecklistModel {

  static const List<ItemChecklistModel> emptyForm = [
    ItemChecklistModel(
      title: 'Inflator Kit',
      apiName: InspectionChecklistPostModel.apiNameInflatorKit,
    ),
    ItemChecklistModel(
      title: 'EV Cable',
      apiName: InspectionChecklistPostModel.apiNameEvCable,
    ),
    ItemChecklistModel(
      title: 'Jack',
      apiName: InspectionChecklistPostModel.apiNameJack,
    ),
    ItemChecklistModel(
      title: 'Spare Wheel/Tyre',
      apiName: InspectionChecklistPostModel.apiNameSpareWheel,
    ),
    ItemChecklistModel(
      title: 'Gel & Compressor Kit',
      apiName: InspectionChecklistPostModel.apiNameGelCompressorKit,
    ),
    ItemChecklistModel(
      title: '13 amp EV Charging Cable',
      apiName: InspectionChecklistPostModel.apiName13AmpEvChargingCable,
    ),
    ItemChecklistModel(
      title: 'HV Charging Cable',
      apiName: InspectionChecklistPostModel.apiNameHvChargingCable,
    ),
    ItemChecklistModel(
      title: 'Spare Key',
      apiName: InspectionChecklistPostModel.apiNameSpareKey,
    ),
    ItemChecklistModel(
      title: 'Master Key',
      apiName: InspectionChecklistPostModel.apiNameMaster,
    ),
  ];

  final String title;
  final String apiName;
  final ChecklistItemOption? selectedOption;

  const ItemChecklistModel({
    required this.title,
    required this.apiName,
    this.selectedOption,
  });

  ItemChecklistModel copyWith({
    String? title,
    String? apiName,
    ChecklistItemOption? selectedOption,
  }) {
    return ItemChecklistModel(
      title: title ?? this.title,
      apiName: apiName ?? this.apiName,
      selectedOption: selectedOption ?? this.selectedOption,
    );
  }

  @override
  String toString() {
    return 'ItemChecklistModel(title: $title, apiName: $apiName, selectedOption: $selectedOption)';

  }
}