// To parse this JSON data, do
//
//     final gradeRuleModel = gradeRuleModelFromMap(jsonString);

import 'package:hive/hive.dart';
import 'dart:convert';

part 'grade_rule_model.g.dart';

GradeRuleModel gradeRuleModelFromMap(String str) =>
    GradeRuleModel.fromMap(json.decode(str));

String gradeRuleModelToMap(GradeRuleModel data) => json.encode(data.toMap());

@HiveType(typeId: 136)
class GradeRuleModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int? gradeId;
  @HiveField(2)
  int? requiredDamageCombinationId;
  @HiveField(3)
  int? requiredDamageCombinationCount;

  GradeRuleModel({
    this.id,
    this.gradeId,
    this.requiredDamageCombinationId,
    this.requiredDamageCombinationCount,
  });

  factory GradeRuleModel.fromMap(Map<String, dynamic> json) => GradeRuleModel(
        id: json['id'],
        gradeId: json["gradeId"],
        requiredDamageCombinationId: json["requiredDamageCombinationId"],
        requiredDamageCombinationCount: json["requiredDamageCombinationCount"],
      );

  Map<String, dynamic> toMap() => {
        "gradeId": gradeId,
        "requiredDamageCombinationId": requiredDamageCombinationId,
        "requiredDamageCombinationCount": requiredDamageCombinationCount,
      };
}
