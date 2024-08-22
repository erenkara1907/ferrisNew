import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/home/data/datasources/remote/job_damage_datasource.dart';
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
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';

import '../../../../product/utility/error_handler/sentry_error_handler.dart';

final class JobDamageRepositoryImpl implements JobDamageRepository {
  JobDamageRepositoryImpl({required JobDamageRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final JobDamageRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<DamagesCategory>>> getDamageCategories(
      {required int inspectionId}) async {
    try {
      final response =
          await _dataSource.getDamageCategories(inspectionId: inspectionId);
      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<DamagesFailure>>> getDamageFailures({
    required int inspectionId,
    required int issueId,
  }) async {
    try {
      final response = await _dataSource.getDamageFailures(
          inspectionId: inspectionId, issueId: issueId);
      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<DamagesIssue>>> getDamageIssues({
    required int inspectionId,
    required int partId,
  }) async {
    try {
      final response = await _dataSource.getDamageIssues(
          inspectionId: inspectionId, partId: partId);
      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<DamagesPart>>> getDamageParts({
    required int inspectionId,
    required int categoryId,
  }) async {
    try {
      final response = await _dataSource.getDamageParts(
          inspectionId: inspectionId, categoryId: categoryId);
      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<DamagesRepair>>> getDamageRepairs({
    required int inspectionId,
    required int failureId,
  }) async {
    try {
      final response = await _dataSource.getDamageRepairs(
          inspectionId: inspectionId, failureId: failureId);
      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<DamageAssetsModel>>> getAllDamageAssets() async {
    try {
      final response = await _dataSource.getAllDamageAssets();
      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<DamageCombinationModel>>>
      getAllDamageCombination() async {
    try {
      final response = await _dataSource.getAllDamageCombination();
      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<GradeModel>>> getAllGrade() async {
    try {
      final response = await _dataSource.getAllGrade();
      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<GradeRuleModel>>> getAllGradeRule() async {
    try {
      final response = await _dataSource.getAllGradeRule();
      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<GradeRuleUpliftModel>>>
      getAllGradeRuleUplift() async {
    try {
      final response = await _dataSource.getAllGradeRuleUplift();
      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      return left(UnknownFailure());
    }
  }
}
