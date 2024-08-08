import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:ferrisfwt/product/state/base/model/i_response_model.dart';
import 'package:hive/hive.dart';

part 'checklist_response_model_item.g.dart';

@HiveType(typeId: TypeIds.modelIdInspectionChecklistResponse)
class ChecklistResponseModelItem implements IResponseModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int jobInspectionId;

  @HiveField(2)
  final int inflatorKit;

  @HiveField(3)
  final int evCable;

  @HiveField(4)
  final int jack;

  @HiveField(5)
  final int spareWheel;

  @HiveField(6)
  final int gelCompressorKit;

  @HiveField(7)
  final int thirteenAmpEvChargingCable; // different name from the api

  @HiveField(8)
  final int hvChargingCable;

  @HiveField(9)
  final int spareKey;

  @HiveField(10)
  final int masterKey;

  ChecklistResponseModelItem({
    required this.id,
    required this.jobInspectionId,
    required this.inflatorKit,
    required this.evCable,
    required this.jack,
    required this.spareWheel,
    required this.gelCompressorKit,
    required this.thirteenAmpEvChargingCable,
    required this.hvChargingCable,
    required this.spareKey,
    required this.masterKey,
  });

  factory ChecklistResponseModelItem.fromMap(Map<String, dynamic> map) {
    return ChecklistResponseModelItem(
      id: map['id'],
      jobInspectionId: map['jobInspectionId'] is int?
          ? map['jobInspectionId']
          : int.parse(map['jobInspectionId']),
      inflatorKit: map['inflatorKit'] is int?
          ? map['inflatorKit']
          : int.parse(map['inflatorKit']),
      evCable:
          map['evCable'] is int? ? map['evCable'] : int.parse(map['evCable']),
      jack: map['jack'] is int? ? map['jack'] : int.parse(map['jack']),
      spareWheel: map['spareWheel'] is int?
          ? map['spareWheel']
          : int.parse(map['spareWheel']),
      gelCompressorKit: map['gelCompressorKit'] is int?
          ? map['gelCompressorKit']
          : int.parse(map['gelCompressorKit']),
      thirteenAmpEvChargingCable: map['13AmpEvChargingCable'] is int?
          ? map['13AmpEvChargingCable']
          : int.parse(map['13AmpEvChargingCable']),
      hvChargingCable: map['hvChargingCable'] is int?
          ? map['hvChargingCable']
          : int.parse(map['hvChargingCable']),
      spareKey: map['spareKey'] is int?
          ? map['spareKey']
          : int.parse(map['spareKey']),
      masterKey: map['masterKey'] is int?
          ? map['masterKey']
          : int.parse(map['masterKey']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobInspectionId': jobInspectionId,
      'inflatorKit': inflatorKit,
      'evCable': evCable,
      'jack': jack,
      'spareWheel': spareWheel,
      'gelCompressorKit': gelCompressorKit,
      '13AmpEvChargingCable': thirteenAmpEvChargingCable,
      'hvChargingCable': hvChargingCable,
      'spareKey': spareKey,
      'masterKey': masterKey,
    };
  }

  @override
  String toString() => toMap().toString();
}
