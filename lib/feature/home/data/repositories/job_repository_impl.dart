import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/home/data/datasources/remote/job_remote_datasource.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/valet_standard/valet_standard_response_model_item.dart';
import 'package:ferrisfwt/feature/home/domain/repositories/job_repository.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/end_job_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/start_job_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/update_job_status_post_model.dart';
import 'package:flutter/material.dart';

import '../../../../product/utility/error_handler/sentry_error_handler.dart';
import '../models/job_start/job_start_model.dart';

final class JobRepositoryImpl implements JobRepository {
  JobRepositoryImpl({required JobRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final JobRemoteDataSource _dataSource;
  @override
  Future<Either<Failure, List<JobsResponseModelItem>>> getJob({
    String? date,
    String? status,
  }) async {
    try {
      final response = await _dataSource.getJob(
        date: date ?? '',
        status: status ?? '',
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
  Future<Either<Failure, JobsResponseModelItem>> getJobShow({
    required String id,
  }) async {
    try {
      final response = await _dataSource.getJobShow(id: id);
      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      // debugPrint(e.toString());
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, String>> startJob({
    required StartJobPostModel data,
    required int jobId,
  }) async {
    try {
      final response = await _dataSource.startJob(
        data: data,
        jobId: jobId,
      );
      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      // debugPrint(e.toString());
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, String>> endJob({
    required int jobId,
    required EndJobPostModel data,
  }) async {
    try {
      final response = await _dataSource.endJob(
        jobId: jobId,
        data: data,
      );
      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      // debugPrint(e.toString());
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, String>> updateJob({
    required int jobId,
    required UpdateJobStatusPostModel updateJobStatusPostModel,
  }) async {
    try {
      final response = await _dataSource.updateJob(
        jobId: jobId,
        updateJobStatusPostModel: updateJobStatusPostModel,
      );
      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      // debugPrint(e.toString());
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<ValetStandardResponseModelItem>>>
      getJobValetStandards() async {
    try {
      final response = await _dataSource.getJobValetStandards();
      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      // debugPrint(e.toString());
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, ValetStandardResponseModelItem>>
      showJobValetStandards({
    required String id,
  }) async {
    try {
      final response = await _dataSource.showJobValetStandards(id: id);
      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      // debugPrint(e.toString());
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, String>> confirmJob({
    required int id,
  }) async {
    try {
      final response = await _dataSource.confirmJob(jobId: id);
      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      // debugPrint(e.toString());
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<JobStartModel>>> getJobPrice(
      {required int jobId}) async {
    try {
      final response = await _dataSource.getJobPrice(
        jobId: jobId,
      );
      return right(response);
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      // debugPrint(e.toString());
      return left(UnknownFailure());
    }
  }
}
