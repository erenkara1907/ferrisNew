import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/home/data/datasources/remote/job_tracking_coordinates_datasource.dart';
import 'package:ferrisfwt/feature/home/data/models/job_tracking_coordinates/tracking_coordinates_response_model_item.dart';
import 'package:ferrisfwt/feature/home/domain/repositories/job_tracking_coordinates_repository.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:flutter/material.dart';

final class JobTrackingCoordinatesRepositoryImpl
    implements JobTrackingCoordinatesRepository {
  JobTrackingCoordinatesRepositoryImpl(
      {required JobTrackingCoordinatesRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final JobTrackingCoordinatesRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<TrackingCoordinatesResponseModelItem>>>
      getJobTrackingCoordinatess({
    required int jobId,
  }) async {
    try {
      final response =
          await _dataSource.getJobTrackingCoordinatess(jobId: jobId);
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
  Future<Either<Failure, TrackingCoordinatesResponseModelItem>>
      getTrackingCoordinate({
    required int id,
  }) async {
    try {
      final response = await _dataSource.getTrackingCoordinate(id: id);
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
  Future<Either<Failure, void>> updateTrackingCoordinate({
    required int jobId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await _dataSource.updateTrackingCoordinate(
        jobId: jobId,
        latitude: latitude,
        longitude: longitude,
      );
      return right(null);
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
