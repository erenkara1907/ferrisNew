import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_update_response_model.dart';
import 'package:ferrisfwt/feature/inspections/domain/repositories/inspection_damages_repository.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_post_model.dart';

final class UCGetJobInspectionsDamages {
  UCGetJobInspectionsDamages(
      {required JobInspectionsDamagesRepository repository})
      : _repository = repository;

  final JobInspectionsDamagesRepository _repository;

  Future<Either<Failure, DamageResponseModel>> postDamage({
    required InspectionDamagePostModel data,
  }) {
    return _repository.postDamage(
      data: data,
    );
  }

  Future<Either<Failure, void>> deleteRecordedDamage({
    required int damageId,
  }) {
    return _repository.deleteRecordedDamage(
      damageId: damageId,
    );
  }

  Future<Either<Failure, DamageUpdateResponseModel>> patchDamage({
    required int damageId,
    required InspectionDamagePatchModel data,
  }) {
    return _repository.patchDamage(
      damageId: damageId,
      data: data,
    );
  }
}
