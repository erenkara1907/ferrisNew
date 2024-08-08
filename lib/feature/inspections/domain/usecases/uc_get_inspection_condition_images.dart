import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/inspections/data/models/condition_image/condition_image_response_model.dart';
import 'package:ferrisfwt/feature/inspections/domain/repositories/inspection_condition_images_repository.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/condition_image/inspection_condition_image_post_model.dart';

final class UCGetJobInspectionsConditionImages {
  UCGetJobInspectionsConditionImages(
      {required JobInspectionsConditionImagesRepository repository})
      : _repository = repository;

  final JobInspectionsConditionImagesRepository _repository;

  Future<Either<Failure, ConditionImageResponseModel>> postConditionImage({
    int? jobInspectionId,
    required InspectionConditionImagePostModel data,
  }) {
    return _repository.postConditionImage(
      jobInspectionId: jobInspectionId,
      data: data,
    );
  }

  Future<Either<Failure, String>> deleteConditionImage({
    required int imageId,
  }) {
    return _repository.deleteConditionImage(
      imageId: imageId,
    );
  }
}
