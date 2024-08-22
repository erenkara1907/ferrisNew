// To parse this JSON data, do
//
//     final jobStartModel = jobStartModelFromMap(jsonString);

import 'package:hive/hive.dart';
import 'dart:convert';

part 'job_start_model.g.dart';

JobStartModel jobStartModelFromMap(String str) =>
    JobStartModel.fromMap(json.decode(str));

String jobStartModelToMap(JobStartModel data) => json.encode(data.toMap());

@HiveType(typeId: 183)
class JobStartModel {
  @HiveField(1)
  int? id;
  @HiveField(2)
  int? vehicleId;
  @HiveField(3)
  int? combinationId;
  @HiveField(4)
  String? price;

  JobStartModel({
    this.id,
    this.vehicleId,
    this.combinationId,
    this.price,
  });

  factory JobStartModel.fromMap(Map<String, dynamic> json) => JobStartModel(
        id: json["id"],
        vehicleId: json["vehicleId"],
        combinationId: json["combinationId"],
        price: json["price"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "vehicleId": vehicleId,
        "combinationId": combinationId,
        "price": price,
      };
}
