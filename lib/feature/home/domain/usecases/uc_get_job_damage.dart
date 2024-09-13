import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_assets/damage_assets_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_combination/damage_combination_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade/grade_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade_rule/grade_rule_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade_rule_uplift/grade_rule_uplift_model.dart';
import 'package:ferrisfwt/feature/home/domain/repositories/job_damage_repository.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';

class UCGetJobDamage {
  UCGetJobDamage({required JobDamageRepository repository})
      : _repository = repository;

  final JobDamageRepository _repository;

  Future<Either<Failure, List<DamageAssetsModel>>> getAllDamageAssets() {
    return _repository.getAllDamageAssets();
  }

  Future<Either<Failure, List<DamageCombinationModel>>>
      getAllDamageCombination() {
    return _repository.getAllDamageCombination();
  }

  Future<Either<Failure, List<GradeModel>>> getAllGrade() {
    return _repository.getAllGrade();
  }

  Future<Either<Failure, List<GradeRuleModel>>> getAllGradeRule() {
    return _repository.getAllGradeRule();
  }

  Future<Either<Failure, List<GradeRuleUpliftModel>>> getAllGradeRuleUplift() {
    return _repository.getAllGradeRuleUplift();
  }
}
