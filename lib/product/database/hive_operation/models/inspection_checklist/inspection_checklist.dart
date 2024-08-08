import 'package:ferrisfwt/feature/inspections/data/models/checklist/checklist_response_model_item.dart';
import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/checklist/inspection_checklist_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/checklist/inspection_checklist_post_model.dart';
import 'package:hive/hive.dart';

part 'inspection_checklist.g.dart';

@HiveType(typeId: TypeIds.modelIdInspectionChecklist)
class InspectionChecklist {
  @HiveField(0)
  final int inspectionId;

  @HiveField(1)
  final int inflatorKit;

  @HiveField(2)
  final int evCable;

  @HiveField(3)
  final int jack;

  @HiveField(4)
  final int spareWheel;

  @HiveField(5)
  final int gelCompressorKit;

  @HiveField(6)
  final int thirteenAmpEvChargingCable;

  @HiveField(7)
  final int hvChargingCable;

  @HiveField(8)
  final int spareKey;

  @HiveField(9)
  final int masterKey;

  @HiveField(10)
  final bool synced;

  @HiveField(11)
  final ChecklistResponseModelItem? responseModel;

  InspectionChecklist({
    required this.inspectionId,
    required this.inflatorKit,
    required this.evCable,
    required this.jack,
    required this.spareWheel,
    required this.gelCompressorKit,
    required this.thirteenAmpEvChargingCable,
    required this.hvChargingCable,
    required this.spareKey,
    required this.masterKey,
    required this.synced,
    this.responseModel,
  });

  factory InspectionChecklist.fromResponseModel({
    required ChecklistResponseModelItem responseModel,
  }) {
    return InspectionChecklist(
      inspectionId: responseModel.jobInspectionId,
      inflatorKit: responseModel.inflatorKit,
      evCable: responseModel.evCable,
      jack: responseModel.jack,
      spareWheel: responseModel.spareWheel,
      gelCompressorKit: responseModel.gelCompressorKit,
      thirteenAmpEvChargingCable: responseModel.thirteenAmpEvChargingCable,
      hvChargingCable: responseModel.hvChargingCable,
      spareKey: responseModel.spareKey,
      masterKey: responseModel.masterKey,
      synced: true,
      responseModel: responseModel,
    );
  }

  InspectionChecklistPostModel toPostModel() {
    return InspectionChecklistPostModel(
      jobInspectionId: inspectionId,
      inflatorKit: inflatorKit,
      evCable: evCable,
      jack: jack,
      spareWheel: spareWheel,
      gelCompressorKit: gelCompressorKit,
      thirteenAmpEvChargingCable: thirteenAmpEvChargingCable,
      hvChargingCable: hvChargingCable,
      spareKey: spareKey,
      masterKey: masterKey,
    );
  }

  InspectionChecklistPatchModel toPatchModel() {
    if (responseModel == null) {
      throw Exception('responseModel is null');
    }

    // define variables for each field to use in the patch model
    int? newInflatorKit;
    int? newEvCable;
    int? newJack;
    int? newSpareWheel;
    int? newGelCompressorKit;
    int? newThirteenAmpEvChargingCable;
    int? newHvChargingCable;
    int? newSpareKey;
    int? newMasterKey;

    if (responseModel!.inflatorKit != inflatorKit) {
      newInflatorKit = inflatorKit;
    }
    if (responseModel!.evCable != evCable) {
      newEvCable = evCable;
    }
    if (responseModel!.jack != jack) {
      newJack = jack;
    }
    if (responseModel!.spareWheel != spareWheel) {
      newSpareWheel = spareWheel;
    }
    if (responseModel!.gelCompressorKit != gelCompressorKit) {
      newGelCompressorKit = gelCompressorKit;
    }
    if (responseModel!.thirteenAmpEvChargingCable !=
        thirteenAmpEvChargingCable) {
      newThirteenAmpEvChargingCable = thirteenAmpEvChargingCable;
    }
    if (responseModel!.hvChargingCable != hvChargingCable) {
      newHvChargingCable = hvChargingCable;
    }
    if (responseModel!.spareKey != spareKey) {
      newSpareKey = spareKey;
    }
    if (responseModel!.masterKey != masterKey) {
      newMasterKey = masterKey;
    }

    return InspectionChecklistPatchModel(
      inflatorKit: newInflatorKit,
      evCable: newEvCable,
      jack: newJack,
      spareWheel: newSpareWheel,
      gelCompressorKit: newGelCompressorKit,
      thirteenAmpEvChargingCable: newThirteenAmpEvChargingCable,
      hvChargingCable: newHvChargingCable,
      spareKey: newSpareKey,
      masterKey: newMasterKey,
    );
  }

  InspectionChecklist copyWith({
    int? inspectionId,
    int? inflatorKit,
    int? evCable,
    int? jack,
    int? spareWheel,
    int? gelCompressorKit,
    int? thirteenAmpEvChargingCable,
    int? hvChargingCable,
    int? spareKey,
    int? masterKey,
    bool? synced,
    ChecklistResponseModelItem? responseModel,
  }) {
    return InspectionChecklist(
      inspectionId: inspectionId ?? this.inspectionId,
      inflatorKit: inflatorKit ?? this.inflatorKit,
      evCable: evCable ?? this.evCable,
      jack: jack ?? this.jack,
      spareWheel: spareWheel ?? this.spareWheel,
      gelCompressorKit: gelCompressorKit ?? this.gelCompressorKit,
      thirteenAmpEvChargingCable:
          thirteenAmpEvChargingCable ?? this.thirteenAmpEvChargingCable,
      hvChargingCable: hvChargingCable ?? this.hvChargingCable,
      spareKey: spareKey ?? this.spareKey,
      masterKey: masterKey ?? this.masterKey,
      synced: synced ?? this.synced,
      responseModel: responseModel ?? this.responseModel,
    );
  }
}
