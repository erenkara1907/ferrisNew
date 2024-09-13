import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_assets/damage_assets_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_categories/damage_category.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_combination/damage_combination_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_failures/damage_failure.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_issues/damage_issue.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_parts/damage_part.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_repairs/damage_repair.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade/grade_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade_rule/grade_rule_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade_rule_uplift/grade_rule_uplift_model.dart';
import 'package:ferrisfwt/feature/home/domain/usecases/uc_get_job_damage.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';

import '../../../../../product/state/base/model/post_models/job_inspections/damage/inspection_damage_post_model.dart';
import '../../../data/models/damages/damage_response_model.dart';

part 'job_damage_event.dart';
part 'job_damage_state.dart';

class JobDamageBloc extends Bloc<JobDamageEvent, JobDamageState> {
  JobDamageBloc({
    required UCGetJobDamage ucGetJobDamage,
    required HiveStorageManager hiveStorageManager,
  })  : _ucGetJobDamage = ucGetJobDamage,
        _hiveStorageManager = hiveStorageManager,
        super(const JobDamageState()) {
    on<GetAllDamageAssets>(_onGetAllDamageAssets);
    on<GetAllDamageCombination>(_onGetAllDamageCombination);
    on<GetAllGrade>(_onGetAllGrade);
    on<GetAllGradeRule>(_onGetAllGradeRule);
    on<GetAllGradeRuleUplift>(_onGetAllGradeRuleUplift);

    on<SetDamageCategories>(_onSetDamageRepairs);
  }

  final UCGetJobDamage _ucGetJobDamage;
  late final HiveStorageManager _hiveStorageManager;

  Future<void> _onGetAllDamageAssets(
      GetAllDamageAssets event, Emitter<JobDamageState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _ucGetJobDamage.getAllDamageAssets();
    result.fold(
      (failure) {
        emit(state.copyWith(status: ViewStatus.failure, failure: failure));
      },
      (data) {
        _hiveStorageManager.addDamageAssetsToTable(data);
        emit(state.copyWith(
          status: ViewStatus.success,
          damageAssetsModel: data,
        ));
      },
    );
  }

  Future<void> _onGetAllDamageCombination(
      GetAllDamageCombination event, Emitter<JobDamageState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _ucGetJobDamage.getAllDamageCombination();
    result.fold(
      (failure) {
        emit(state.copyWith(status: ViewStatus.failure, failure: failure));
      },
      (data) {
        _hiveStorageManager.addDamageCombinationToTable(data);
        emit(state.copyWith(
          status: ViewStatus.success,
          damageCombinationModel: data,
        ));
      },
    );
  }

  Future<void> _onGetAllGrade(
      GetAllGrade event, Emitter<JobDamageState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _ucGetJobDamage.getAllGrade();
    result.fold(
      (failure) {
        emit(state.copyWith(status: ViewStatus.failure, failure: failure));
      },
      (data) {
        _hiveStorageManager.addGradeToTable(data);
        emit(state.copyWith(
          status: ViewStatus.success,
          gradeModel: data,
        ));
      },
    );
  }

  Future<void> _onGetAllGradeRule(
      GetAllGradeRule event, Emitter<JobDamageState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _ucGetJobDamage.getAllGradeRule();
    result.fold(
      (failure) {
        emit(state.copyWith(status: ViewStatus.failure, failure: failure));
      },
      (data) {
        _hiveStorageManager.addGradeRuleToTable(data);
        emit(state.copyWith(
          status: ViewStatus.success,
          gradeRuleModel: data,
        ));
      },
    );
  }

  Future<void> _onGetAllGradeRuleUplift(
      GetAllGradeRuleUplift event, Emitter<JobDamageState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _ucGetJobDamage.getAllGradeRuleUplift();
    result.fold(
      (failure) {
        emit(state.copyWith(status: ViewStatus.failure, failure: failure));
      },
      (data) {
        _hiveStorageManager.addGradeRuleUpliftToTable(data);
        emit(state.copyWith(
          status: ViewStatus.success,
          gradeRuleUpliftModel: data,
        ));
      },
    );
  }

  Future<void> _onSetDamageRepairs(
      SetDamageCategories event, Emitter<JobDamageState> emit) async {
    final data = await _hiveStorageManager.getDamageCategories();

    emit(state.copyWith(getDamageCategoriesResponse: data));
  }
}
