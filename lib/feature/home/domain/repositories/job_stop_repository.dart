import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/home/data/models/job_stop/stop_categories_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/job_stop/stops_response_model_item.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/stops/stop_post_model.dart';

abstract interface class JobStopRepository {
  Future<Either<Failure, List<StopsResponseModelItem>>> getJobStops({
    required int jobId,
  });

  Future<Either<Failure, StopsResponseModelItem>> postJobStops({
    required int jobId,
    required StopPostModel data,
  });

  Future<Either<Failure, List<StopCategoriesResponseModelItem>>>
      getStopCategories();
}
