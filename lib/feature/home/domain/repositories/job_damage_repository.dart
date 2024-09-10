import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_assets/damage_assets_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_categories/damage_category.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_combination/damage_combination_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_failures/damage_failure.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_issues/damage_issue.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_parts/damage_part.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_repairs/damage_repair.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade/grade_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade_rule/grade_rule_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade_rule_uplift/grade_rule_uplift_model.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';

abstract interface class JobDamageRepository {
  // Future<Either<Failure, List<DamagesCategory>>> getDamageCategories(
  //     {required int inspectionId});

  // Future<Either<Failure, List<DamagesFailure>>> getDamageFailures(
  //     {required int inspectionId, required int issueId});

  // Future<Either<Failure, List<DamagesIssue>>> getDamageIssues(
  //     {required int inspectionId, required int partId});

  // Future<Either<Failure, List<DamagesPart>>> getDamageParts(
  //     {required int inspectionId, required int categoryId});

  // Future<Either<Failure, List<DamagesRepair>>> getDamageRepairs(
  //     {required int inspectionId, required int failureId});

  Future<Either<Failure, List<DamageAssetsModel>>> getAllDamageAssets();
  Future<Either<Failure, List<DamageCombinationModel>>>
      getAllDamageCombination();
  Future<Either<Failure, List<GradeModel>>> getAllGrade();
  Future<Either<Failure, List<GradeRuleModel>>> getAllGradeRule();
  Future<Either<Failure, List<GradeRuleUpliftModel>>> getAllGradeRuleUplift();
}
