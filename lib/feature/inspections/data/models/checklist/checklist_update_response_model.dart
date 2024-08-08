import 'package:equatable/equatable.dart';
import 'package:ferrisfwt/feature/inspections/data/models/checklist/checklist_response_model_item.dart';

class ChecklistUpdateResponseModel extends Equatable {
  final ChecklistResponseModelItem oldChecklist;
  final ChecklistResponseModelItem newChecklist;

  ChecklistUpdateResponseModel({
    required this.oldChecklist,
    required this.newChecklist,
  });

  factory ChecklistUpdateResponseModel.fromMap(Map<String, dynamic> map) {
    return ChecklistUpdateResponseModel(
      oldChecklist: ChecklistResponseModelItem.fromMap(map['old']),
      newChecklist: ChecklistResponseModelItem.fromMap(map['new']),
    );
  }

  @override
  List<Object?> get props => [oldChecklist, newChecklist];
}
