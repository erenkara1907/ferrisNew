import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_update_response_model.dart';
import 'package:ferrisfwt/feature/inspections/data/datasources/remote/inspection_damages_remote_datasource.dart';
import 'package:ferrisfwt/feature/inspections/domain/repositories/inspection_damages_repository.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_post_model.dart';

import '../../../../product/utility/error_handler/sentry_error_handler.dart';

final class JobInspectionsDamagesRepositoryImpl
    implements JobInspectionsDamagesRepository {
  JobInspectionsDamagesRepositoryImpl(
      {required JobInspectionsDamagesRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final JobInspectionsDamagesRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, DamageResponseModel>> postDamage({
    required InspectionDamagePostModel data,
  }) async {
    try {
      final response = await _dataSource.postDamage(
        data: data,
      );

      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecordedDamage({
    required int damageId,
  }) async {
    try {
      await _dataSource.deleteRecordedDamage(
        damageId: damageId,
      );

      return right(unit);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, DamageUpdateResponseModel>> patchDamage({
    required int damageId,
    required InspectionDamagePatchModel data,
  }) async {
    try {
      final response = await _dataSource.patchDamage(
        damageId: damageId,
        data: data,
      );

      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<DamageResponseModel>>> getDamages({
    required int jobInspectionId,
  }) async {
    try {
      final response = await _dataSource.getDamages(
        jobInspectionId: jobInspectionId,
      );

      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      return left(UnknownFailure());
    }
  }
}
