import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_update_response_model.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_post_model.dart';

abstract interface class JobInspectionsDamagesRepository {
  Future<Either<Failure, DamageResponseModel>> postDamage({
    required InspectionDamagePostModel data,
  });

  Future<Either<Failure, DamageUpdateResponseModel>> patchDamage({
    required int damageId,
    required InspectionDamagePatchModel data,
  });

  Future<Either<Failure, void>> deleteRecordedDamage({
    required int damageId,
  });

}
