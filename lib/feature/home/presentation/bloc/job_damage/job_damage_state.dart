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
    this.damageCombinationModel = const [],
    this.gradeModel = const [],
    this.gradeRuleModel = const [],
    this.gradeRuleUpliftModel = const [],
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
  final List<DamageCombinationModel> damageCombinationModel;
  final List<GradeModel> gradeModel;
  final List<GradeRuleModel> gradeRuleModel;
  final List<GradeRuleUpliftModel> gradeRuleUpliftModel;
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
    List<DamageCombinationModel>? damageCombinationModel,
    List<GradeModel>? gradeModel,
    List<GradeRuleModel>? gradeRuleModel,
    List<GradeRuleUpliftModel>? gradeRuleUpliftModel,
    Failure? failure,
  }) {
    return JobDamageState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      getDamageCategoriesResponse:
          getDamageCategoriesResponse ?? this.getDamageCategoriesResponse,
      damageAssetsModel: damageAssetsModel ?? this.damageAssetsModel,
      damageCombinationModel:
          damageCombinationModel ?? this.damageCombinationModel,
      gradeModel: gradeModel ?? this.gradeModel,
      gradeRuleModel: gradeRuleModel ?? this.gradeRuleModel,
      gradeRuleUpliftModel: gradeRuleUpliftModel ?? this.gradeRuleUpliftModel,
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
