import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';
import 'package:hive/hive.dart';

part 'inspection_checklist_post_model.g.dart';

@HiveType(typeId: 191)
class InspectionChecklistPostModel extends INetworkSentDataModel {
  static const apiNameInflatorKit = 'inflatorKit';
  static const apiNameEvCable = 'evCable';
  static const apiNameJack = 'jack';
  static const apiNameSpareWheel = 'spareWheel';
  static const apiNameGelCompressorKit = 'gelCompressorKit';
  static const apiName13AmpEvChargingCable = '13AmpEvChargingCable';
  static const apiNameHvChargingCable = 'hvChargingCable';
  static const apiNameSpareKey = 'spareKey';
  static const apiNameMaster = 'masterKey';

  @HiveField(0)
  final int jobInspectionId;
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
  final int thirteenAmpEvChargingCable; // different name in the api
  @HiveField(7)
  final int hvChargingCable;
  @HiveField(8)
  final int spareKey;
  @HiveField(9)
  final int masterKey;

  InspectionChecklistPostModel({
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

  factory InspectionChecklistPostModel.fromMap(Map<String, dynamic> map) {
    return InspectionChecklistPostModel(
      jobInspectionId: map['jobInspectionId'],
      inflatorKit: map[apiNameInflatorKit],
      evCable: map[apiNameEvCable],
      jack: map[apiNameJack],
      spareWheel: map[apiNameSpareWheel],
      gelCompressorKit: map[apiNameGelCompressorKit],
      thirteenAmpEvChargingCable: map[apiName13AmpEvChargingCable],
      hvChargingCable: map[apiNameHvChargingCable],
      spareKey: map[apiNameSpareKey],
      masterKey: map[apiNameMaster],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'jobInspectionId': jobInspectionId,
      apiNameInflatorKit: inflatorKit,
      apiNameEvCable: evCable,
      apiNameJack: jack,
      apiNameSpareWheel: spareWheel,
      apiNameGelCompressorKit: gelCompressorKit,
      apiName13AmpEvChargingCable: thirteenAmpEvChargingCable,
      apiNameHvChargingCable: hvChargingCable,
      apiNameSpareKey: spareKey,
      apiNameMaster: masterKey,
    };
  }
}
