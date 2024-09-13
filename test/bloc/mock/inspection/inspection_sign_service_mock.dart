import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/inspections/domain/usecases/uc_get_inspection_sign.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_customer_sign_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_inspector_sign_post_model.dart';
import 'package:mockito/mockito.dart';

final class InspectionSignServiceMock extends Mock
    implements UCGetJobInspectionsSign {
  @override
  Future<Either<Failure, String>> postCustomerSign(
      {required int inspectionId,
      required InspectionCustomerSignPostModel data}) {
    if (inspectionId == 1) {
      return Future.value(const Right("OKAY"));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, String>> postInspectorSign(
      {required int inspectionId,
      required InspectionInspectorSignPostModel data}) {
    if (inspectionId == 1) {
      return Future.value(const Right("OKAY"));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, String>> patchCustomerSign(
      {required InspectionCustomerSignPostModel data}) {
    if (data.customerSignerName == "testName") {
      return Future.value(const Right("OKAY"));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, String>> patchInspectorSign(
      {required InspectionInspectorSignPostModel data}) {
    if (data.inspectorSignerName == "testName") {
      return Future.value(const Right("OKAY"));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }
}
