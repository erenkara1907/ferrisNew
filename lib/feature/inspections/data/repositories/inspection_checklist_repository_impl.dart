import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:ferrisfwt/feature/inspections/data/datasources/remote/inspection_checklist_remote_datasource.dart';
import 'package:ferrisfwt/feature/inspections/data/models/checklist/checklist_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/checklist/checklist_update_response_model.dart';
import 'package:ferrisfwt/feature/inspections/domain/repositories/inspection_checklist_repository.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/checklist/inspection_checklist_post_model.dart';

import '../../../../product/utility/error_handler/sentry_error_handler.dart';

final class JobInspectionsCheckListRepositoryImpl
    implements JobInspectionsCheckListRepository {
  JobInspectionsCheckListRepositoryImpl(
      {required JobInspectionsCheckListRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final JobInspectionsCheckListRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<ChecklistResponseModelItem>>> getChecklists({
    required int? inspectionId,
  }) async {
    try {
      final response = await _dataSource.getChecklists(
        inspectionId: inspectionId,
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
  Future<Either<Failure, String>> postChecklist({
    required InspectionChecklistPostModel data,
  }) async {
    try {
      final response = await _dataSource.postChecklist(
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
  Future<Either<Failure, ChecklistUpdateResponseModel>> patchChecklist({
    required InspectionChecklistPostModel data,
    required int checklistId,
  }) async {
    try {
      final response = await _dataSource.patchChecklist(
        data: data,
        checklistId: checklistId,
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
