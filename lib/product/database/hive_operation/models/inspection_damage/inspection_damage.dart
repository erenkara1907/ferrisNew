import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';

import 'package:ferrisfwt/product/manager/utils/util/multipart_file_mixin.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_categories/damage_category.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_failures/damage_failure.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_issues/damage_issue.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_parts/damage_part.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_repairs/damage_repair.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_response_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_post_model.dart';
import 'package:hive/hive.dart';

part 'inspection_damage.g.dart';

@HiveType(typeId: TypeIds.modelIdInspectionDamage)
class InspectionDamage with MultipartFileMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int inspectionId;

  @HiveField(2)
  final DamagesCategory category;

  @HiveField(3)
  final DamagesPart part;

  @HiveField(4)
  final DamagesIssue issue;

  @HiveField(5)
  final DamagesFailure failure;

  @HiveField(6)
  final DamagesRepair repair;

  @HiveField(7)
  final String damageImagePath;

  @HiveField(8)
  final String contextImagePath;

  @HiveField(9)
  final bool synced;

  @HiveField(10)
  final bool patchDamageImage;

  @HiveField(11)
  final bool patchContextImage;

  @HiveField(12)
  final DamageResponseModel? damageResponseModel;

  InspectionDamage({
    required this.id,
    required this.inspectionId,
    required this.category,
    required this.part,
    required this.issue,
    required this.failure,
    required this.repair,
    required this.damageImagePath,
    required this.contextImagePath,
    required this.synced,
    required this.patchDamageImage,
    required this.patchContextImage,
    this.damageResponseModel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'inspectionId': inspectionId,
      'category': category.toMap(),
      'part': part.toMap(),
      'issue': issue.toMap(),
      'failure': failure.toMap(),
      'repair': repair.toMap(),
      'damageImagePath': damageImagePath,
      'contextImagePath': contextImagePath,
      'synced': synced,
      'patchDamageImage': patchDamageImage,
      'patchContextImage': patchContextImage,
      'damageResponseModel': damageResponseModel,
    };
  }

  double? get price {
    if (synced) {
      return damageResponseModel?.price;
    }
    return null;
  }

  InspectionDamage copyWith({
    String? id,
    int? inspectionId,
    DamagesCategory? category,
    DamagesPart? part,
    DamagesIssue? issue,
    DamagesFailure? failure,
    DamagesRepair? repair,
    String? damageImagePath,
    String? contextImagePath,
    bool? synced,
    bool? patchDamageImage,
    bool? patchContextImage,
    DamageResponseModel? damageResponseModel,
  }) {
    return InspectionDamage(
      id: id ?? this.id,
      inspectionId: inspectionId ?? this.inspectionId,
      category: category ?? this.category,
      part: part ?? this.part,
      issue: issue ?? this.issue,
      failure: failure ?? this.failure,
      repair: repair ?? this.repair,
      damageImagePath: damageImagePath ?? this.damageImagePath,
      contextImagePath: contextImagePath ?? this.contextImagePath,
      synced: synced ?? this.synced,
      patchDamageImage: patchDamageImage ?? this.patchDamageImage,
      patchContextImage: patchContextImage ?? this.patchContextImage,
      damageResponseModel: damageResponseModel ?? this.damageResponseModel,
    );
  }

  @override
  String toString() => toMap().toString();
}
