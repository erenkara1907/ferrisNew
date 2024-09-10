import 'dart:convert';

import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';
import 'package:hive/hive.dart';

part 'end_job_post_model.g.dart';

@HiveType(typeId: TypeIds.modelIdEndJobPostModel)
class EndJobPostModel extends INetworkSentDataModel {
  @HiveField(0)
  final int endDate;

  @HiveField(1)
  final String? spendCharging;

  @HiveField(2)
  final int? valetStandardId;

  // @HiveField(3)
  // final String? departedHubTime; // format H:i

  // @HiveField(4)
  // final String? arrivedCustomerTime; // format H:i

  // @HiveField(5)
  // final String? departedCustomerTime; // format H:i

  EndJobPostModel({
    required this.endDate,
    this.spendCharging,
    this.valetStandardId,
    // this.departedHubTime,
    // this.arrivedCustomerTime,
    // this.departedCustomerTime,
  });

  factory EndJobPostModel.fromMap(Map<String, dynamic> map) {
    return EndJobPostModel(
      endDate: map['endDate'],
      spendCharging: map['spendCharging'],
      valetStandardId: map['valetStandardId'],
      // departedHubTime: map['departedHubTime'],
      // arrivedCustomerTime: map['arrivedCustomerTime'],
      // departedCustomerTime: map['departedCustomerTime'],
    );
  }

  factory EndJobPostModel.fromJson(String json) {
    return EndJobPostModel.fromMap(jsonDecode(json));
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'endDate': endDate,
      'spendCharging': spendCharging,
      'valetStandardId': valetStandardId,
      // 'departedHubTime': departedHubTime,
      // 'arrivedCustomerTime': arrivedCustomerTime,
      // 'departedCustomerTime': departedCustomerTime,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
