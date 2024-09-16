import 'package:hive/hive.dart';
import 'dart:convert';

part 'damage_combination_model.g.dart';

DamageCombinationModel damageCombinationModelFromMap(String str) => DamageCombinationModel.fromMap(json.decode(str));

String damageCombinationModelToMap(DamageCombinationModel data) => json.encode(data.toMap());

@HiveType(typeId: 130)
class DamageCombinationModel {
  @HiveField(1)
  int? id;
  @HiveField(2)
  CategoryId? categoryId;
  @HiveField(3)
  PartId? partId;
  @HiveField(4)
  IssueId? issueId;
  @HiveField(5)
  FailureId? failureId;
  @HiveField(6)
  RepairId? repairId;
  @HiveField(7)
  List<int>? damageStandards;
  @HiveField(8)
  int? score;

  DamageCombinationModel({
    this.id,
    this.categoryId,
    this.partId,
    this.issueId,
    this.failureId,
    this.repairId,
    this.damageStandards,
    this.score,
  });

  factory DamageCombinationModel.fromMap(Map<String, dynamic> json) => DamageCombinationModel(
        id: json["id"],
        categoryId: json["categoryId"] == null ? null : CategoryId.fromMap(json["categoryId"]),
        partId: json["partId"] == null ? null : PartId.fromMap(json["partId"]),
        issueId: json["issueId"] == null ? null : IssueId.fromMap(json["issueId"]),
        failureId: json["failureId"] == null ? null : FailureId.fromMap(json["failureId"]),
        repairId: json["repairId"] == null ? null : RepairId.fromMap(json["repairId"]),
        damageStandards: json["damageStandards"] == null ? [] : List<int>.from(json["damageStandards"]!.map((x) => x)),
        score: json["score"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "categoryId": categoryId?.toMap(),
        "partId": partId?.toMap(),
        "issueId": issueId?.toMap(),
        "failureId": failureId?.toMap(),
        "repairId": repairId?.toMap(),
        "damageStandards": damageStandards == null ? [] : List<dynamic>.from(damageStandards!.map((x) => x)),
      };
}

@HiveType(typeId: 131)
class CategoryId {
  @HiveField(1)
  int? id;
  @HiveField(2)
  String? name;

  CategoryId({
    this.id,
    this.name,
  });

  factory CategoryId.fromMap(Map<String, dynamic> json) => CategoryId(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}

@HiveType(typeId: 138)
class FailureId {
  @HiveField(1)
  int? id;
  @HiveField(2)
  int? issueId;
  @HiveField(3)
  String? name;

  FailureId({
    this.id,
    this.issueId,
    this.name,
  });

  factory FailureId.fromMap(Map<String, dynamic> json) => FailureId(
        id: json["id"],
        issueId: json["issueId"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "issueId": issueId,
        "name": name,
      };
}

@HiveType(typeId: 140)
class IssueId {
  @HiveField(1)
  int? id;
  @HiveField(2)
  int? partId;
  @HiveField(3)
  String? name;

  IssueId({
    this.id,
    this.partId,
    this.name,
  });

  factory IssueId.fromMap(Map<String, dynamic> json) => IssueId(
        id: json["id"],
        partId: json["partId"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "partId": partId,
        "name": name,
      };
}

@HiveType(typeId: 141)
class PartId {
  @HiveField(1)
  int? id;
  @HiveField(2)
  int? categoryId;
  @HiveField(3)
  String? name;

  PartId({
    this.id,
    this.categoryId,
    this.name,
  });

  factory PartId.fromMap(Map<String, dynamic> json) => PartId(
        id: json["id"],
        categoryId: json["categoryId"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "categoryId": categoryId,
        "name": name,
      };
}

@HiveType(typeId: 142)
class RepairId {
  @HiveField(1)
  int? id;
  @HiveField(2)
  int? failureId;
  @HiveField(3)
  String? name;

  RepairId({
    this.id,
    this.failureId,
    this.name,
  });

  factory RepairId.fromMap(Map<String, dynamic> json) => RepairId(
        id: json["id"],
        failureId: json["failureId"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "failureId": failureId,
        "name": name,
      };
}
