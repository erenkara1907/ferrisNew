import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_assets/damage_assets_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_combination/damage_combination_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade/grade_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade_rule/grade_rule_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade_rule_uplift/grade_rule_uplift_model.dart';
import 'package:ferrisfwt/feature/home/domain/usecases/uc_get_job_damage.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:mockito/mockito.dart';

final class DamageServiceMock extends Mock implements UCGetJobDamage {
  @override
  Future<Either<Failure, List<DamageAssetsModel>>> getAllDamageAssets() {
    List<DamageAssetsModel> r = [
      DamageAssetsModel(id: 1, name: "asset 1"),
      DamageAssetsModel(id: 2, name: "asset 2"),
      DamageAssetsModel(id: 3, name: "asset 3"),
    ];
    if (r.isNotEmpty) {
      return Future.value(Right(r));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, List<DamageCombinationModel>>>
      getAllDamageCombination() {
    List<DamageCombinationModel> r = [
      DamageCombinationModel(id: 1),
      DamageCombinationModel(id: 2),
      DamageCombinationModel(id: 3),
    ];
    if (r.isNotEmpty) {
      return Future.value(Right(r));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, List<GradeModel>>> getAllGrade() {
    List<GradeModel> r = [
      GradeModel(id: 1, name: "grade 1"),
      GradeModel(id: 2, name: "grade 2"),
      GradeModel(id: 3, name: "grade 3"),
    ];
    if (r.isNotEmpty) {
      return Future.value(Right(r));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, List<GradeRuleModel>>> getAllGradeRule() {
    List<GradeRuleModel> r = [
      GradeRuleModel(id: 1, gradeId: 1),
      GradeRuleModel(id: 2, gradeId: 2),
      GradeRuleModel(id: 3, gradeId: 3),
    ];
    if (r.isNotEmpty) {
      return Future.value(Right(r));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, List<GradeRuleUpliftModel>>> getAllGradeRuleUplift() {
    List<GradeRuleUpliftModel> r = [
      GradeRuleUpliftModel(gradeRuleId: 1, upToGradeId: 1),
      GradeRuleUpliftModel(gradeRuleId: 2, upToGradeId: 2),
      GradeRuleUpliftModel(gradeRuleId: 3, upToGradeId: 3),
    ];
    if (r.isNotEmpty) {
      return Future.value(Right(r));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }
}
