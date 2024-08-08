import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/inspections/data/datasources/remote/inspection_sign_remote_datasource.dart';
import 'package:ferrisfwt/feature/inspections/domain/repositories/inspection_sign_repository.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_customer_sign_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_inspector_sign_post_model.dart';

final class JobInspectionsSignRepositoryImpl
    implements JobInspectionsSignRepository {
  JobInspectionsSignRepositoryImpl(
      {required JobInspectionsSignRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final JobInspectionsSignRemoteDataSource _dataSource;

  Future<Either<Failure, String>> postCustomerSign({
    required int inspectionId,
    required InspectionCustomerSignPostModel data,
  }) async {
    try {
      final response = await _dataSource.postCustomerSign(
        data: data,
        inspectionId: inspectionId,
      );
      return right(response);
    } on DioException {
      return left(NetworkFailure());
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  Future<Either<Failure, String>> postInspectorSign({
    required int inspectionId,
    required InspectionInspectorSignPostModel data,
  }) async {
    try {
      final response = await _dataSource.postInspectorSign(
        data: data,
        inspectionId: inspectionId,
      );
      return right(response);
    } on DioException {
      return left(NetworkFailure());
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  Future<Either<Failure, String>> patchCustomerSign({
    required InspectionCustomerSignPostModel data,
  }) async {
    try {
      final response = await _dataSource.patchCustomerSign(
        data: data,
      );
      return right(response);
    } on DioException {
      return left(NetworkFailure());
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  Future<Either<Failure, String>> patchInspectorSign({
    required InspectionInspectorSignPostModel data,
  }) async {
    try {
      final response = await _dataSource.patchInspectorSign(
        data: data,
      );
      return right(response);
    } on DioException {
      return left(NetworkFailure());
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e) {
      return left(UnknownFailure());
    }
  }
}
