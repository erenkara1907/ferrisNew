import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';
import 'package:hive/hive.dart';

part 'inspection_details_post_model.g.dart';

@HiveType(typeId: 194)
class InspectionDetailsPostModel extends INetworkSentDataModel {
  @HiveField(0)
  final double odoReading;
  @HiveField(1)
  final int fuelLevel;

  InspectionDetailsPostModel({
    required this.odoReading,
    required this.fuelLevel,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'odoReading': odoReading,
      'fuelLevel': fuelLevel,
    };
  }
}
