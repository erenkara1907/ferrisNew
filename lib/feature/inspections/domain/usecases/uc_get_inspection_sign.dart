import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/inspections/domain/repositories/inspection_sign_repository.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_customer_sign_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_inspector_sign_post_model.dart';

class UCGetJobInspectionsSign {
  UCGetJobInspectionsSign({required JobInspectionsSignRepository repository})
      : _repository = repository;

  final JobInspectionsSignRepository _repository;

  Future<Either<Failure, String>> postCustomerSign({
    required int inspectionId,
    required InspectionCustomerSignPostModel data,
  }) {
    return _repository.postCustomerSign(
      data: data,
      inspectionId: inspectionId,
    );
  }

  Future<Either<Failure, String>> postInspectorSign({
    required int inspectionId,
    required InspectionInspectorSignPostModel data,
  }) {
    return _repository.postInspectorSign(
      data: data,
      inspectionId: inspectionId,
    );
  }

  Future<Either<Failure, String>> patchCustomerSign({
    required InspectionCustomerSignPostModel data,
  }) {
    return _repository.patchCustomerSign(
      data: data,
    );
  }

  Future<Either<Failure, String>> patchInspectorSign({
    required InspectionInspectorSignPostModel data,
  }) {
    return _repository.patchInspectorSign(
      data: data,
    );
  }
}
