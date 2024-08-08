import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_categories/damage_category.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_failures/damage_failure.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_issues/damage_issue.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_parts/damage_part.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_repairs/damage_repair.dart';
import 'package:ferrisfwt/feature/home/domain/usecases/uc_get_job_damage.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';

import '../../../../../product/mixin/network_mixin.dart';
import '../../../../../product/state/base/model/post_models/job_inspections/damage/inspection_damage_post_model.dart';
import '../../../../inspections/domain/usecases/uc_get_inspection_damages.dart';
import '../../../data/models/damages/damage_response_model.dart';

part 'job_damage_event.dart';
part 'job_damage_state.dart';

class JobDamageBloc extends Bloc<JobDamageEvent, JobDamageState> {
  JobDamageBloc({
    required UCGetJobDamage ucGetJobDamage,
    required UCGetJobInspectionsDamages ucGetInspectionsDamage,
  })  : _ucGetJobDamage = ucGetJobDamage,
        _ucGetJobInspectionsDamages = ucGetInspectionsDamage,
        super(const JobDamageState()) {
    _hiveStorageManager = ProductStateItems.hiveStorageManager;
    on<GetDamageCategories>(_onGetDamageCategories);
    on<GetDamageIssues>(_onGetDamageIssues);
    on<GetDamageParts>(_onGetDamageParts);
    on<GetDamageRepairs>(_onGetDamageRepairs);
    on<GetDamageFailures>(_onGetDamageFailures);
    on<SetDamageCategories>(_onSetDamageRepairs);
    on<PostJobDamages>(_postJobDamages);
  }

  final UCGetJobDamage _ucGetJobDamage;
  late final HiveStorageManager _hiveStorageManager;

  final UCGetJobInspectionsDamages _ucGetJobInspectionsDamages;

  Future<void> _onGetDamageCategories(
      GetDamageCategories event, Emitter<JobDamageState> emit) async {
    print("GİRDİ KRAL");
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _ucGetJobDamage.getDamageCategories(
        inspectionId: event.inspectionId);
    result.fold(
        (failure) =>
            emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
        (data) {
      print("DATA : $data");
      _hiveStorageManager.replaceDamageCategoriesTable(data);
      emit(state.copyWith(
        status: ViewStatus.success,
        getDamageCategoriesResponse: data,
      ));
    });
  }

  Future<void> _onGetDamageIssues(
      GetDamageIssues event, Emitter<JobDamageState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _ucGetJobDamage.getDamageIssues(
      inspectionId: event.inspectionId,
      partId: event.damagePartId,
    );
    result.fold(
        (failure) =>
            emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
        (data) {
      _hiveStorageManager.replaceDamageIssuesTable(data);
      emit(state.copyWith(
        status: ViewStatus.success,
        getDamageIssuesResponse: data,
      ));
    });
  }

  Future<void> _onGetDamageParts(
      GetDamageParts event, Emitter<JobDamageState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));

    final result = await _ucGetJobDamage.getDamageParts(
      inspectionId: event.inspectionId,
      categoryId: event.damageCategoryId,
    );
    result.fold(
        (failure) =>
            emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
        (data) {
      _hiveStorageManager.replaceDamagePartsTable(data);
      emit(state.copyWith(
        status: ViewStatus.success,
        getDamagePartsResponse: data,
      ));
    });
  }

  Future<void> _onGetDamageRepairs(
      GetDamageRepairs event, Emitter<JobDamageState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _ucGetJobDamage.getDamageRepairs(
      inspectionId: event.inspectionId,
      failureId: event.damageFailureId,
    );
    result.fold(
        (failure) =>
            emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
        (data) {
      _hiveStorageManager.replaceDamageRepairsTable(data);
      emit(state.copyWith(
        status: ViewStatus.success,
        getDamageRepairsResponse: data,
      ));
    });
  }

  Future<void> _onGetDamageFailures(
      GetDamageFailures event, Emitter<JobDamageState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _ucGetJobDamage.getDamageFailures(
      inspectionId: event.inspectionId,
      issueId: event.damageIssueId,
    );
    result.fold(
        (failure) =>
            emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
        (data) {
      _hiveStorageManager.replaceDamageFailuresTable(data);
      emit(state.copyWith(
        status: ViewStatus.success,
        getDamageFailuresResponse: data,
      ));
    });
  }

  Future<void> _onSetDamageRepairs(
      SetDamageCategories event, Emitter<JobDamageState> emit) async {
    final data = await _hiveStorageManager.getDamageCategories();

    emit(state.copyWith(getDamageCategoriesResponse: data));
  }

  Future<void> _postJobDamages(
      PostJobDamages event, Emitter<JobDamageState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await hasNetwork();
    if (result) {
      final result = await _ucGetJobInspectionsDamages.postDamage(
        data: event.data,
      );

      result.fold(
        (failure) {
          emit(state.copyWith(status: ViewStatus.failure, failure: failure));
        },
        (data) {
          emit(state.copyWith(
            status: ViewStatus.success,
          ));
        },
      );
      if (!event.isAsync) {
        _hiveStorageManager.setDamagePostModel(event.data);
        await Future.delayed(const Duration(seconds: 2));
        final categoryNmae = state.getDamageCategoriesResponse
            .firstWhere((element) => element?.id == event.data.categoryId);

        final partName = state.getDamagePartsResponse
            .firstWhere((element) => element.id == event.data.partId);

        final issueName = state.getDamageIssuesResponse
            .firstWhere((element) => element.id == event.data.issueId);

        final failureName = state.getDamageFailuresResponse
            .firstWhere((element) => element.id == event.data.failureId);

        final repairName = state.getDamageRepairsResponse
            .firstWhere((element) => element.id == event.data.repairId);

        final DamageResponseModel data = DamageResponseModel(
            id: Random().nextInt(10000),
            jobInspectionId: event.data.jobInspectionId,
            categoryId: DamagesCategory(
                id: event.data.categoryId, name: categoryNmae?.name ?? ''),
            partId: DamagesPart(
                id: event.data.partId,
                name: partName.name ?? '',
                categoryId: event.data.categoryId),
            issueId: DamagesIssue(
                id: event.data.issueId,
                name: issueName.name,
                partId: event.data.partId),
            failureId: DamagesFailure(
                id: event.data.failureId,
                name: failureName.name,
                issueId: event.data.issueId),
            repairId: DamagesRepair(
                id: event.data.repairId,
                name: repairName.name,
                failureId: event.data.failureId),
            damageImage: event.data.damageImage?.path ?? '',
            contextImage: event.data.contextImage?.path ?? '',
            price: 0.0);
        _hiveStorageManager.setGetDamage(data);
        await Future.delayed(const Duration(seconds: 2));
        _hiveStorageManager.setRecordedDamage(event.data);

        emit(state.copyWith(
          status: ViewStatus.success,
          damageResponse: [data, ...state.damageResponse],
        ));
        return;
      }
    } else {
      if (event.isAsync) {
        emit(state.copyWith(status: ViewStatus.failure));
        return;
      }
      _hiveStorageManager.setDamagePostModel(event.data);
      await Future.delayed(const Duration(seconds: 2));
      final categoryNmae = state.getDamageCategoriesResponse
          .firstWhere((element) => element?.id == event.data.categoryId);

      final partName = state.getDamagePartsResponse
          .firstWhere((element) => element.id == event.data.partId);

      final issueName = state.getDamageIssuesResponse
          .firstWhere((element) => element.id == event.data.issueId);

      final failureName = state.getDamageFailuresResponse
          .firstWhere((element) => element.id == event.data.failureId);

      final repairName = state.getDamageRepairsResponse
          .firstWhere((element) => element.id == event.data.repairId);

      final DamageResponseModel data = DamageResponseModel(
          id: Random().nextInt(10000),
          jobInspectionId: event.data.jobInspectionId,
          categoryId: DamagesCategory(
              id: event.data.categoryId, name: categoryNmae?.name ?? ''),
          partId: DamagesPart(
              id: event.data.partId,
              name: partName.name ?? '',
              categoryId: event.data.categoryId),
          issueId: DamagesIssue(
              id: event.data.issueId,
              name: issueName.name,
              partId: event.data.partId),
          failureId: DamagesFailure(
              id: event.data.failureId,
              name: failureName.name,
              issueId: event.data.issueId),
          repairId: DamagesRepair(
              id: event.data.repairId,
              name: repairName.name,
              failureId: event.data.failureId),
          damageImage: event.data.damageImage?.path ?? '',
          contextImage: event.data.contextImage?.path ?? '',
          price: 0.0);
      _hiveStorageManager.setGetDamage(data);
      await Future.delayed(const Duration(seconds: 2));
      _hiveStorageManager.setRecordedDamage(event.data);
      emit(state.copyWith(
        status: ViewStatus.success,
        damageResponse: [data, ...state.damageResponse],
      ));
    }
  }
}
