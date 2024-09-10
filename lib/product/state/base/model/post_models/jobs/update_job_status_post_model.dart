import 'dart:convert';
import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';
import 'package:hive/hive.dart';

part 'update_job_status_post_model.g.dart';

@HiveType(typeId: 188)
class UpdateJobStatusPostModel extends INetworkSentDataModel {
  @HiveField(0)
  final String timestamp;
  // @HiveField(1)
  // final int? trackingStatusId;
  @HiveField(1)
  final int? fuelChargeLevelDelivery;
  @HiveField(2)
  final int? fuelChargeLevelCollection;
  @HiveField(3)
  final String? vehicleFeedback;
  @HiveField(4)
  final String? customerFeedback;

  UpdateJobStatusPostModel({
    required this.timestamp,
    // this.trackingStatusId,
    this.fuelChargeLevelDelivery,
    this.fuelChargeLevelCollection,
    this.vehicleFeedback,
    this.customerFeedback,
  });

  factory UpdateJobStatusPostModel.fromMap(Map<String, dynamic> map) {
    return UpdateJobStatusPostModel(
      timestamp: map['timestamp'] as String,
      // trackingStatusId: map['trackingStatusId'],
      fuelChargeLevelDelivery: map['fuelChargeLevelDelivery'],
      fuelChargeLevelCollection: map['fuelChargeLevelCollection'],
      vehicleFeedback: map['vehicleFeedback'],
      customerFeedback: map['customerFeedback'],
    );
  }

  factory UpdateJobStatusPostModel.fromJson(String json) {
    return UpdateJobStatusPostModel.fromMap(jsonDecode(json));
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      // if (trackingStatusId != null) 'trackingStatusId': trackingStatusId,
      if (fuelChargeLevelDelivery != 0)
        'fuelChargeLevelDelivery': fuelChargeLevelDelivery,
      if (fuelChargeLevelCollection != 0)
        'fuelChargeLevelCollection': fuelChargeLevelCollection,
      if (vehicleFeedback != null) 'vehicleFeedback': vehicleFeedback,
      if (customerFeedback != null) 'customerFeedback': customerFeedback,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  UpdateJobStatusPostModel copyWith({
    String? timestamp,
    int? trackingStatusId,
    int? fuelChargeLevelDelivery,
    int? fuelChargeLevelCollection,
    String? vehicleFeedback,
    String? customerFeedback,
  }) {
    return UpdateJobStatusPostModel(
      timestamp: timestamp ?? this.timestamp,
      // trackingStatusId: trackingStatusId ?? this.trackingStatusId,
      fuelChargeLevelDelivery:
          fuelChargeLevelDelivery ?? this.fuelChargeLevelDelivery,
      fuelChargeLevelCollection:
          fuelChargeLevelCollection ?? this.fuelChargeLevelCollection,
      vehicleFeedback: vehicleFeedback ?? this.vehicleFeedback,
      customerFeedback: customerFeedback ?? this.customerFeedback,
    );
  }
}
