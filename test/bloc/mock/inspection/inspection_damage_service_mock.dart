import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_categories/damage_category.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_failures/damage_failure.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_issues/damage_issue.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_parts/damage_part.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_repairs/damage_repair.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_update_response_model.dart';
import 'package:ferrisfwt/feature/inspections/domain/usecases/uc_get_inspection_damages.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_post_model.dart';
import 'package:mockito/mockito.dart';

final class InspectionDamageServiceMock extends Mock
    implements UCGetJobInspectionsDamages {
  @override
  Future<Either<Failure, DamageResponseModel>> postDamage(
      {required InspectionDamagePostModel data}) {
    if (data.damageId == 1) {
      return Future.value(
        Right(
          DamageResponseModel(
            id: 1,
            jobInspectionId: 1,
            categoryId: DamagesCategory(id: 1, name: "category 1"),
            partId: DamagesPart(id: 1, categoryId: 1, name: "part 1"),
            issueId: DamagesIssue(id: 1, partId: 1, name: "issue 1"),
            failureId: DamagesFailure(id: 1, issueId: 1, name: "failure 1"),
            repairId: DamagesRepair(id: 1, failureId: 1, name: "repair 1"),
          ),
        ),
      );
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, List<DamageResponseModel>>> getDamages(
      {required int jobInspectionId}) {
    List<DamageResponseModel> r = [
      DamageResponseModel(
        id: 1,
        jobInspectionId: 1,
        categoryId: DamagesCategory(id: 1, name: "category 1"),
        partId: DamagesPart(id: 1, categoryId: 1, name: "part 1"),
        issueId: DamagesIssue(id: 1, partId: 1, name: "issue 1"),
        failureId: DamagesFailure(id: 1, issueId: 1, name: "failure 1"),
        repairId: DamagesRepair(id: 1, failureId: 1, name: "repair 1"),
      ),
    ];

    if (jobInspectionId == 1) {
      return Future.value(Right(r));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecordedDamage({required int damageId}) {
    return Future.value(const Right(null));
  }

  @override
  Future<Either<Failure, DamageUpdateResponseModel>> patchDamage(
      {required int damageId, required InspectionDamagePatchModel data}) {
    if (damageId == 1) {
      return Future.value(
        Right(
          DamageUpdateResponseModel(
            oldDamage: DamageResponseModel(
              id: 1,
              jobInspectionId: 1,
              categoryId: DamagesCategory(id: 1, name: "category 1"),
              partId: DamagesPart(id: 1, categoryId: 1, name: "part 1"),
              issueId: DamagesIssue(id: 1, partId: 1, name: "issue 1"),
              failureId: DamagesFailure(id: 1, issueId: 1, name: "failure 1"),
              repairId: DamagesRepair(id: 1, failureId: 1, name: "repair 1"),
            ),
            newDamage: DamageResponseModel(
              id: 2,
              jobInspectionId: 1,
              categoryId: DamagesCategory(id: 1, name: "category 1"),
              partId: DamagesPart(id: 1, categoryId: 1, name: "part 1"),
              issueId: DamagesIssue(id: 1, partId: 1, name: "issue 1"),
              failureId: DamagesFailure(id: 1, issueId: 1, name: "failure 1"),
              repairId: DamagesRepair(id: 1, failureId: 1, name: "repair 1"),
            ),
          ),
        ),
      );
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }
}
