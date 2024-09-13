import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/home/data/models/job_stop/stop_categories_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/job_stop/stops_response_model_item.dart';
import 'package:ferrisfwt/feature/home/domain/usecases/uc_get_job_stop.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/stops/stop_post_model.dart';
import 'package:mockito/mockito.dart';

final class StopServiceMock extends Mock implements UCGetJobStop {
  @override
  Future<Either<Failure, List<StopsResponseModelItem>>> getJobStops(
      {required int jobId}) {
    List<StopsResponseModelItem> r = [
      StopsResponseModelItem(
        id: 1,
        jobId: 1,
        reason: "reason",
        longitude: 20.0,
        latitude: 20.0,
        evidence: "evidence",
        categoryId: StopCategoriesResponseModelItem(id: 1, name: "category 1"),
      ),
      StopsResponseModelItem(
        id: 2,
        jobId: 2,
        reason: "reason",
        longitude: 20.0,
        latitude: 20.0,
        evidence: "evidence",
        categoryId: StopCategoriesResponseModelItem(id: 2, name: "category 2"),
      ),
      StopsResponseModelItem(
        id: 3,
        jobId: 3,
        reason: "reason",
        longitude: 20.0,
        latitude: 20.0,
        evidence: "evidence",
        categoryId: StopCategoriesResponseModelItem(id: 3, name: "category 3"),
      ),
    ];

    if (jobId == 1) {
      return Future.value(Right(r));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, StopsResponseModelItem>> postJobStops(
      {required int jobId, required StopPostModel data}) {
    if (jobId == 1) {
      return Future.value(Right(StopsResponseModelItem(evidence: "evidence")));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, List<StopCategoriesResponseModelItem>>>
      getStopCategories() {
    List<StopCategoriesResponseModelItem> r = [
      StopCategoriesResponseModelItem(id: 1, name: "category 1"),
      StopCategoriesResponseModelItem(id: 2, name: "category 2"),
      StopCategoriesResponseModelItem(id: 3, name: "category 3"),
    ];
    if (r.isNotEmpty) {
      return Future.value(Right(r));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }
}
