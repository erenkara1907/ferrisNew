import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/inspections/data/models/condition_image/condition_image_response_model.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/condition_image/inspection_condition_image_post_model.dart';

abstract interface class JobInspectionsConditionImagesRepository {
  Future<Either<Failure, ConditionImageResponseModel>> postConditionImage({
    int? jobInspectionId,
    required InspectionConditionImagePostModel data,
  });

  Future<Either<Failure, String>> deleteConditionImage({
    required int imageId,
  });
}
