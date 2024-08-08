import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/inspections/data/datasources/remote/job_inspections_remote_datasource.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_abort_type_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/domain/repositories/job_inspections_repository.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';

final class JobInspectionsRepositoryImpl implements JobInspectionsRepository {
  JobInspectionsRepositoryImpl(
      {required JobInspectionsRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final JobInspectionsRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<JobInspectionResponseModelItem>>>
      getJobInspections({int? jobId, String? regNumber}) async {
    try {
      final response = await _dataSource.getJobInspections(
        jobId: jobId,
        regNumber: regNumber,
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

  @override
  Future<Either<Failure, List<JobInspectionAbortTypeItem>>>
      getJobInspectionAbortTypes() async {
    try {
      final response = await _dataSource.getJobInspectionAbortTypes();
      return right(response);
    } on DioException {
      return left(NetworkFailure());
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, JobInspectionResponseModelItem>> postDetails({
    required double odoReading,
    required int fuelLevel,
    required int inspectionId,
  }) async {
    try {
      final response = await _dataSource.postDetails(
        odoReading: odoReading,
        fuelLevel: fuelLevel,
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
}
