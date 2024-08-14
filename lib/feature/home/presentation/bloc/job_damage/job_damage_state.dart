part of 'job_damage_bloc.dart';

final class JobDamageState extends Equatable {
  const JobDamageState({
    this.status,
    this.failure,
    this.getDamageCategoriesResponse = const [],
    this.getDamageFailuresResponse = const [],
    this.getDamageIssuesResponse = const [],
    this.getDamagePartsResponse = const [],
    this.getDamageRepairsResponse = const [],
    this.damageResponse = const [],
    this.damageAssetsModel = const [],
    this.inspectionId = 0,
  });

  final ViewStatus? status;
  final Failure? failure;
  final List<DamagesCategory?> getDamageCategoriesResponse;
  final List<DamagesFailure> getDamageFailuresResponse;
  final List<DamagesIssue> getDamageIssuesResponse;
  final List<DamagesPart> getDamagePartsResponse;
  final List<DamagesRepair> getDamageRepairsResponse;
  final List<DamageResponseModel> damageResponse;
  final List<DamageAssetsModel> damageAssetsModel;
  final int inspectionId;

  @override
  List<Object?> get props => [
        status,
        failure,
        getDamageCategoriesResponse,
        getDamageFailuresResponse,
        getDamageIssuesResponse,
        getDamagePartsResponse,
        getDamageRepairsResponse,
      ];

  JobDamageState copyWith({
    ViewStatus? status,
    List<DamagesCategory?>? getDamageCategoriesResponse,
    List<DamagesFailure>? getDamageFailuresResponse,
    List<DamagesIssue>? getDamageIssuesResponse,
    List<DamagesPart>? getDamagePartsResponse,
    List<DamagesRepair>? getDamageRepairsResponse,
    List<DamageResponseModel>? damageResponse,
    List<DamageAssetsModel>? damageAssetsModel,
    Failure? failure,
  }) {
    return JobDamageState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      getDamageCategoriesResponse:
          getDamageCategoriesResponse ?? this.getDamageCategoriesResponse,
      damageAssetsModel: damageAssetsModel ?? this.damageAssetsModel,
      getDamageFailuresResponse:
          getDamageFailuresResponse ?? this.getDamageFailuresResponse,
      getDamageIssuesResponse:
          getDamageIssuesResponse ?? this.getDamageIssuesResponse,
      getDamagePartsResponse:
          getDamagePartsResponse ?? this.getDamagePartsResponse,
      damageResponse: damageResponse ?? this.damageResponse,
      getDamageRepairsResponse:
          getDamageRepairsResponse ?? this.getDamageRepairsResponse,
    );
  }
}
