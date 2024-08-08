import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';
import 'package:hive/hive.dart';

part 'job_inspections_details_model.g.dart';

@HiveType(typeId: 211)
class InspectionDetailsPostModel extends INetworkSentDataModel {
  @HiveField(0)
  final double odoReading;
  @HiveField(1)
  final int fuelLevel;
  @HiveField(2)
  final int inspectionId;

  InspectionDetailsPostModel({
    required this.odoReading,
    required this.fuelLevel,
    required this.inspectionId,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'odoReading': odoReading,
      'fuelLevel': fuelLevel,
      'inspectionId': inspectionId,
    };
  }
}
