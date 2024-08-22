// To parse this JSON data, do
//
//     final damageCombinationModel = damageCombinationModelFromMap(jsonString);

import 'package:hive/hive.dart';
import 'dart:convert';

part 'damage_combination_model.g.dart';

DamageCombinationModel damageCombinationModelFromMap(String str) =>
    DamageCombinationModel.fromMap(json.decode(str));

String damageCombinationModelToMap(DamageCombinationModel data) =>
    json.encode(data.toMap());

// @HiveType(typeId: 130)
// class DamageCombinationModel {
//   @HiveField(1)
//   List<Datum>? data;

//   DamageCombinationModel({
//     this.data,
//   });

//   factory DamageCombinationModel.fromMap(Map<String, dynamic> json) =>
//       DamageCombinationModel(
//         data: json["data"] == null
//             ? []
//             : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
//       );

//   Map<String, dynamic> toMap() => {
//         "data":
//             data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
//       };
// }

@HiveType(typeId: 130)
class DamageCombinationModel {
  @HiveField(1)
  int? id;
  @HiveField(2)
  int? categoryId;
  @HiveField(3)
  int? partId;
  @HiveField(4)
  int? issueId;
  @HiveField(5)
  int? failureId;
  @HiveField(6)
  int? repairId;
  @HiveField(7)
  List<int>? damageStandards;

  DamageCombinationModel({
    this.id,
    this.categoryId,
    this.partId,
    this.issueId,
    this.failureId,
    this.repairId,
    this.damageStandards,
  });

  factory DamageCombinationModel.fromMap(Map<String, dynamic> json) =>
      DamageCombinationModel(
        id: json["id"],
        // categoryId: json["categoryId"],
        // partId: json["partId"],
        // issueId: json["issueId"],
        // failureId: json["failureId"],
        // repairId: json["repairId"],
        damageStandards: json["damageStandards"] == null
            ? []
            : List<int>.from(json["damageStandards"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "categoryId": categoryId,
        "partId": partId,
        "issueId": issueId,
        "failureId": failureId,
        "repairId": repairId,
        "damageStandards": damageStandards == null
            ? []
            : List<dynamic>.from(damageStandards!.map((x) => x)),
      };
}
