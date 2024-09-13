import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/inspections/data/models/condition_image/condition_image_response_model.dart';
import 'package:ferrisfwt/feature/inspections/domain/usecases/uc_get_inspection_condition_images.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:mockito/mockito.dart';

final class InspectionConditionImagesServiceMock extends Mock
    implements UCGetJobInspectionsConditionImages {
  @override
  Future<Either<Failure, ConditionImageResponseModel>> postConditionImage(
      {int? jobInspectionId, required ConditionImageResponseModel data}) {
    if (jobInspectionId == 1) {
      return Future.value(
          Right(ConditionImageResponseModel(jobInspectionId: 1)));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteConditionImage({required int imageId}) {
    if (imageId == 1) {
      return Future.value(const Right("OKAY"));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }
}
