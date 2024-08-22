// To parse this JSON data, do
//
//     final gradeRuleUpliftModel = gradeRuleUpliftModelFromMap(jsonString);

import 'package:hive/hive.dart';
import 'dart:convert';

part 'grade_rule_uplift_model.g.dart';

GradeRuleUpliftModel gradeRuleUpliftModelFromMap(String str) =>
    GradeRuleUpliftModel.fromMap(json.decode(str));

String gradeRuleUpliftModelToMap(GradeRuleUpliftModel data) =>
    json.encode(data.toMap());

// @HiveType(typeId: 138)
// class GradeRuleUpliftModel {
//   @HiveField(1)
//   List<Datum>? data;

//   GradeRuleUpliftModel({
//     this.data,
//   });

//   factory GradeRuleUpliftModel.fromMap(Map<String, dynamic> json) =>
//       GradeRuleUpliftModel(
//         data: json["data"] == null
//             ? []
//             : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
//       );

//   Map<String, dynamic> toMap() => {
//         "data":
//             data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
//       };
// }

@HiveType(typeId: 139)
class GradeRuleUpliftModel {
  @HiveField(1)
  int? gradeRuleId;
  @HiveField(2)
  int? upToGradeId;
  @HiveField(3)
  int? requiredDamageCombinationCount;

  GradeRuleUpliftModel({
    this.gradeRuleId,
    this.upToGradeId,
    this.requiredDamageCombinationCount,
  });

  factory GradeRuleUpliftModel.fromMap(Map<String, dynamic> json) =>
      GradeRuleUpliftModel(
        gradeRuleId: json["gradeRuleId"],
        upToGradeId: json["upToGradeId"],
        requiredDamageCombinationCount: json["requiredDamageCombinationCount"],
      );

  Map<String, dynamic> toMap() => {
        "gradeRuleId": gradeRuleId,
        "upToGradeId": upToGradeId,
        "requiredDamageCombinationCount": requiredDamageCombinationCount,
      };
}
