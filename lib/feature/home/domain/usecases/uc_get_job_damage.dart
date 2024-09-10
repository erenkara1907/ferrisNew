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
import 'package:ferrisfwt/feature/home/domain/repositories/job_damage_repository.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';

final class UCGetJobDamage {
  UCGetJobDamage({required JobDamageRepository repository})
      : _repository = repository;

  final JobDamageRepository _repository;

  // Future<Either<Failure, List<DamagesCategory>>> getDamageCategories(
  //     {required int inspectionId}) {
  //   return _repository.getDamageCategories(inspectionId: inspectionId);
  // }

  // Future<Either<Failure, List<DamagesFailure>>> getDamageFailures(
  //     {required int inspectionId, required int issueId}) {
  //   return _repository.getDamageFailures(
  //       inspectionId: inspectionId, issueId: issueId);
  // }

  // Future<Either<Failure, List<DamagesIssue>>> getDamageIssues(
  //     {required int inspectionId, required int partId}) {
  //   return _repository.getDamageIssues(
  //       inspectionId: inspectionId, partId: partId);
  // }

  // Future<Either<Failure, List<DamagesPart>>> getDamageParts(
  //     {required int inspectionId, required int categoryId}) {
  //   return _repository.getDamageParts(
  //       inspectionId: inspectionId, categoryId: categoryId);
  // }

  // Future<Either<Failure, List<DamagesRepair>>> getDamageRepairs(
  //     {required int inspectionId, required int failureId}) {
  //   return _repository.getDamageRepairs(
  //       inspectionId: inspectionId, failureId: failureId);
  // }

  Future<Either<Failure, List<DamageAssetsModel>>> getAllDamageAssets() {
    return _repository.getAllDamageAssets();
  }

  Future<Either<Failure, List<DamageCombinationModel>>>
      getAllDamageCombination() {
    return _repository.getAllDamageCombination();
  }

  Future<Either<Failure, List<GradeModel>>> getAllGrade() {
    return _repository.getAllGrade();
  }

  Future<Either<Failure, List<GradeRuleModel>>> getAllGradeRule() {
    return _repository.getAllGradeRule();
  }

  Future<Either<Failure, List<GradeRuleUpliftModel>>> getAllGradeRuleUplift() {
    return _repository.getAllGradeRuleUplift();
  }
}
