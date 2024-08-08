import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/inspections/data/datasources/remote/inspection_condition_images_remote_datasource.dart';
import 'package:ferrisfwt/feature/inspections/data/models/condition_image/condition_image_response_model.dart';
import 'package:ferrisfwt/feature/inspections/domain/repositories/inspection_condition_images_repository.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/condition_image/inspection_condition_image_post_model.dart';

final class JobInspectionsConditionImagesRepositoryImpl
    implements JobInspectionsConditionImagesRepository {
  JobInspectionsConditionImagesRepositoryImpl(
      {required JobInspectionsConditionImagesRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final JobInspectionsConditionImagesRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, ConditionImageResponseModel>> postConditionImage({
    int? jobInspectionId,
    required InspectionConditionImagePostModel data,
  }) async {
    try {
      final response = await _dataSource.postConditionImage(
        jobInspectionId: jobInspectionId,
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

  @override
  Future<Either<Failure, String>> deleteConditionImage({
    required int imageId,
  }) async {
    try {
      final response = await _dataSource.deleteConditionImage(
        imageId: imageId,
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
