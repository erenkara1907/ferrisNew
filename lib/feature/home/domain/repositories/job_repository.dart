import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/valet_standard/valet_standard_response_model_item.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/end_job_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/start_job_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/update_job_status_post_model.dart';

abstract interface class JobRepository {
  Future<Either<Failure, List<JobsResponseModelItem>>> getJob({
    String date,
    String status,
  });

  Future<Either<Failure, JobsResponseModelItem>> getJobShow({
    required String id,
  });

  Future<Either<Failure, String>> startJob({
    required StartJobPostModel data,
    required int jobId,
  });

  Future<Either<Failure, String>> endJob({
    required int jobId,
    required EndJobPostModel data,
  });

  Future<Either<Failure, String>> updateJob({
    required int jobId,
    required UpdateJobStatusPostModel updateJobStatusPostModel,
  });

  Future<Either<Failure, List<ValetStandardResponseModelItem>>>
      getJobValetStandards();

  Future<Either<Failure, ValetStandardResponseModelItem>>
      showJobValetStandards({
    required String id,
  });

  Future<Either<Failure, String>> confirmJob({required int id});
}
