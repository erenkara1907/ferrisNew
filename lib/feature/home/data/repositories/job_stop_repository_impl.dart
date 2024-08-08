import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/home/data/datasources/remote/job_stop_datasource.dart';
import 'package:ferrisfwt/feature/home/data/models/job_stop/stop_categories_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/job_stop/stops_response_model_item.dart';
import 'package:ferrisfwt/feature/home/domain/repositories/job_stop_repository.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/stops/stop_post_model.dart';
import 'package:flutter/material.dart';

final class JobStopRepositoryImpl implements JobStopRepository {
  JobStopRepositoryImpl({required JobStopRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final JobStopRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<StopsResponseModelItem>>> getJobStops({
    required int jobId,
  }) async {
    try {
      final response = await _dataSource.getJobStops(jobId: jobId);
      return right(response);
    } on DioException {
      return left(NetworkFailure());
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e) {
      debugPrint(e.toString());
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, StopsResponseModelItem>> postJobStops({
    required int jobId,
    required StopPostModel data,
  }) async {
    try {
      final response = await _dataSource.postJobStops(
        jobId: jobId,
        data: data,
      );
      return right(response);
    } on DioException {
      return left(NetworkFailure());
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e) {
      debugPrint(e.toString());
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<StopCategoriesResponseModelItem>>>
      getStopCategories() async {
    try {
      final response = await _dataSource.getStopCategories();
      return right(response);
    } on DioException {
      return left(NetworkFailure());
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e) {
      debugPrint(e.toString());
      return left(UnknownFailure());
    }
  }
}
