import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/valet_standard/valet_standard_response_model_item.dart';
import 'package:ferrisfwt/feature/home/domain/repositories/job_repository.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/end_job_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/start_job_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/update_job_status_post_model.dart';

import '../../data/models/job_start/job_start_model.dart';

final class UCGetJob {
  UCGetJob({required JobRepository repository}) : _repository = repository;

  final JobRepository _repository;

  Future<Either<Failure, List<JobsResponseModelItem>>> getJob({
    String? date,
    String? status,
  }) {
    return _repository.getJob(
      date: date ?? '',
      status: status ?? '',
    );
  }

  Future<Either<Failure, JobsResponseModelItem>> getJobShow({
    required String id,
  }) {
    return _repository.getJobShow(id: id);
  }

  Future<Either<Failure, List<JobStartModel>>> startJob({
    required StartJobPostModel data,
    required int jobId,
  }) {
    return _repository.startJob(
      data: data,
      jobId: jobId,
    );
  }

  Future<Either<Failure, String>> endJob({
    required int jobId,
    required EndJobPostModel data,
  }) {
    return _repository.endJob(
      jobId: jobId,
      data: data,
    );
  }

  Future<Either<Failure, String>> updateJob({
    required int jobId,
    required UpdateJobStatusPostModel updateJobStatusPostModel,
  }) {
    return _repository.updateJob(
      jobId: jobId,
      updateJobStatusPostModel: updateJobStatusPostModel,
    );
  }

  Future<Either<Failure, List<ValetStandardResponseModelItem>>>
      getJobValetStandards() {
    return _repository.getJobValetStandards();
  }

  Future<Either<Failure, ValetStandardResponseModelItem>>
      showJobValetStandards({
    required String id,
  }) {
    return _repository.showJobValetStandards(id: id);
  }

  Future<Either<Failure, String>> confirmJob({required int id}) {
    return _repository.confirmJob(id: id);
  }

  Future<Either<Failure, List<JobStartModel>>> getJobPrice({
    required int jobId,
  }) {
    return _repository.getJobPrice(
      jobId: jobId,
    );
  }
}
