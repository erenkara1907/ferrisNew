import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/home/data/models/job_start/job_start_model.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/valet_standard/valet_standard_response_model_item.dart';
import 'package:ferrisfwt/feature/home/domain/usecases/uc_get_job.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/end_job_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/start_job_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/update_job_status_post_model.dart';
import 'package:mockito/mockito.dart';

final class JobServiceMock extends Mock implements UCGetJob {
  @override
  Future<Either<Failure, List<JobsResponseModelItem>>> getJob(
      {String? date, String? status}) {
    List<JobsResponseModelItem> r = [
      JobsResponseModelItem(id: 1),
      JobsResponseModelItem(id: 2),
      JobsResponseModelItem(id: 3),
      JobsResponseModelItem(id: 4),
      JobsResponseModelItem(id: 5),
    ];
    if (date == "testDate" && status == "testStatus") {
      return Future.value(Right(r));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, JobsResponseModelItem>> getJobShow(
      {required String id}) {
    if (id == "testId") {
      return Future.value(Right(JobsResponseModelItem(id: 1)));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, String>> startJob(
      {required StartJobPostModel data, required int jobId}) {
    if (jobId == 1) {
      return Future.value(const Right("OKAY"));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, String>> endJob(
      {required int jobId, required EndJobPostModel data}) {
    if (jobId == 1 && data.endDate == 1) {
      return Future.value(const Right("OKAY"));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, String>> updateJob(
      {required int jobId,
      required UpdateJobStatusPostModel updateJobStatusPostModel}) {
    if (jobId == 1 && updateJobStatusPostModel.customerFeedback != null) {
      return Future.value(const Right("OKAY"));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, List<ValetStandardResponseModelItem>>>
      getJobValetStandards() {
    List<ValetStandardResponseModelItem> r = [
      ValetStandardResponseModelItem(id: 1, name: "1"),
      ValetStandardResponseModelItem(id: 2, name: "2"),
      ValetStandardResponseModelItem(id: 3, name: "3"),
      ValetStandardResponseModelItem(id: 4, name: "4"),
      ValetStandardResponseModelItem(id: 5, name: "5"),
    ];
    return Future.value(Right(r));
  }

  @override
  Future<Either<Failure, ValetStandardResponseModelItem>> showJobValetStandards(
      {required String id}) {
    if (id == "1") {
      return Future.value(
          Right(ValetStandardResponseModelItem(id: 1, name: "1")));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, String>> confirmJob({required int id}) {
    if (id == 1) {
      return Future.value(const Right("OKAY"));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, List<JobStartModel>>> getJobPrice(
      {required int jobId}) {
    List<JobStartModel> r = [
      JobStartModel(id: 1, price: "1"),
      JobStartModel(id: 2, price: "2"),
      JobStartModel(id: 3, price: "3"),
      JobStartModel(id: 4, price: "4"),
      JobStartModel(id: 5, price: "5"),
    ];
    if (jobId == 1) {
      return Future.value(Right(r));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }
}
