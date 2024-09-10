// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

import 'package:ferrisfwt/feature/home/data/models/damages/damage_categories/damage_category.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_failures/damage_failure.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_issues/damage_issue.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_parts/damage_part.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_repairs/damage_repair.dart';
import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:ferrisfwt/product/state/base/model/i_response_model.dart';

part 'damage_response_model.g.dart';

@HiveType(typeId: TypeIds.modelIdInspectionDamageResponse)
class DamageResponseModel implements IResponseModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int jobInspectionId;

  @HiveField(2)
  final DamagesCategory categoryId;

  @HiveField(3)
  final DamagesPart partId;

  @HiveField(4)
  final DamagesIssue issueId;

  @HiveField(5)
  final DamagesFailure failureId;

  @HiveField(6)
  final DamagesRepair repairId;

  @HiveField(7)
  final String? damageImage;

  @HiveField(8)
  final String? contextImage;

  @HiveField(9)
  final double? price;

  @HiveField(10)
  final String? gradeId;

  @HiveField(11)
  final int? combinationId;

  DamageResponseModel({
    required this.id,
    required this.jobInspectionId,
    required this.categoryId,
    required this.partId,
    required this.issueId,
    required this.failureId,
    required this.repairId,
    this.gradeId,
    this.damageImage,
    this.contextImage,
    this.price,
    this.combinationId,
  });

  factory DamageResponseModel.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> damageCombination = map['damageCombinationId'];

    // final gradeId = map["jobInspectionId"]['gradeId']["name"];

    final jobInspection = map["jobInspectionId"];
    final grade = jobInspection?['gradeId'];
    final gradeName = grade?["name"];
    return DamageResponseModel(
      id: map['id'],
      jobInspectionId: map['jobInspectionId'] is int?
          ? map['jobInspectionId']
          : map['jobInspectionId']?['id'],
      categoryId: DamagesCategory.fromMap(damageCombination['categoryId']),
      partId: DamagesPart.fromMap(damageCombination['partId']),
      issueId: DamagesIssue.fromMap(damageCombination['issueId']),
      failureId: DamagesFailure.fromMap(damageCombination['failureId']),
      repairId: DamagesRepair.fromMap(damageCombination['repairId']),
      damageImage: map['damageImage'],
      contextImage: map['contextImage'],
      gradeId: gradeName is String ? gradeName : gradeName?.toString(),
      price: map['price'] is double?
          ? map['price']
          : double.parse(map['price'].toString()),
    );
  }

  @override
  String toString() =>
      'DamageResponseModel(id: $id, jobInspectionId: $jobInspectionId, categoryId: $categoryId, partId: $partId, issueId: $issueId, failureId: $failureId, repairId: $repairId, damageImage: $damageImage, contextImage: $contextImage, price: $price)';

  DamageResponseModel copyWith({
    int? id,
    int? jobInspectionId,
    DamagesCategory? categoryId,
    DamagesPart? partId,
    DamagesIssue? issueId,
    DamagesFailure? failureId,
    DamagesRepair? repairId,
    String? damageImage,
    String? contextImage,
    double? price,
    String? gradeId,
  }) {
    return DamageResponseModel(
      id: id ?? this.id,
      jobInspectionId: jobInspectionId ?? this.jobInspectionId,
      categoryId: categoryId ?? this.categoryId,
      partId: partId ?? this.partId,
      issueId: issueId ?? this.issueId,
      failureId: failureId ?? this.failureId,
      repairId: repairId ?? this.repairId,
      damageImage: damageImage ?? this.damageImage,
      contextImage: contextImage ?? this.contextImage,
      price: price ?? this.price,
      gradeId: gradeId ?? this.gradeId,
    );
  }
}
