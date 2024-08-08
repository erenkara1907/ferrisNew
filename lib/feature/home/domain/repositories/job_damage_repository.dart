import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_categories/damage_category.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_failures/damage_failure.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_issues/damage_issue.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_parts/damage_part.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_repairs/damage_repair.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';

abstract interface class JobDamageRepository {
  Future<Either<Failure, List<DamagesCategory>>> getDamageCategories(
      {required int inspectionId});

  Future<Either<Failure, List<DamagesFailure>>> getDamageFailures(
      {required int inspectionId, required int issueId});

  Future<Either<Failure, List<DamagesIssue>>> getDamageIssues(
      {required int inspectionId, required int partId});

  Future<Either<Failure, List<DamagesPart>>> getDamageParts(
      {required int inspectionId, required int categoryId});

  Future<Either<Failure, List<DamagesRepair>>> getDamageRepairs(
      {required int inspectionId, required int failureId});
}
