import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_customer_sign_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_inspector_sign_post_model.dart';

abstract interface class JobInspectionsSignRepository {
  Future<Either<Failure, String>> postCustomerSign({
    required int inspectionId,
    required InspectionCustomerSignPostModel data,
  });

  Future<Either<Failure, String>> postInspectorSign({
    required int inspectionId,
    required InspectionInspectorSignPostModel data,
  });

  Future<Either<Failure, String>> patchCustomerSign({
    required InspectionCustomerSignPostModel data,
  });

  Future<Either<Failure, String>> patchInspectorSign({
    required InspectionInspectorSignPostModel data,
  });
}
