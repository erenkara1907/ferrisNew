part of 'job_damage_bloc.dart';

sealed class JobDamageEvent extends Equatable {
  const JobDamageEvent();

  @override
  List<Object> get props => [];
}

class GetAllDamageAssets extends JobDamageEvent {
  const GetAllDamageAssets();

  @override
  List<Object> get props => [];
}

class GetAllDamageCombination extends JobDamageEvent {
  const GetAllDamageCombination();

  @override
  List<Object> get props => [];
}

class GetAllGrade extends JobDamageEvent {
  const GetAllGrade();

  @override
  List<Object> get props => [];
}

class GetAllGradeRule extends JobDamageEvent {
  const GetAllGradeRule();

  @override
  List<Object> get props => [];
}

class GetAllGradeRuleUplift extends JobDamageEvent {
  const GetAllGradeRuleUplift();

  @override
  List<Object> get props => [];
}

class GetDamageCategories extends JobDamageEvent {
  final int inspectionId;
  const GetDamageCategories(this.inspectionId);

  @override
  List<Object> get props => [];
}

class GetDamageIssues extends JobDamageEvent {
  final int damagePartId;
  final int inspectionId;
  const GetDamageIssues(this.damagePartId, this.inspectionId);

  @override
  List<Object> get props => [];
}

class GetDamageFailures extends JobDamageEvent {
  final int damageIssueId;
  final int inspectionId;
  const GetDamageFailures(this.damageIssueId, this.inspectionId);

  @override
  List<Object> get props => [];
}

class GetDamageParts extends JobDamageEvent {
  final int damageCategoryId;
  final int inspectionId;
  const GetDamageParts(this.damageCategoryId, this.inspectionId);

  @override
  List<Object> get props => [];
}

class GetDamageRepairs extends JobDamageEvent {
  final int damageFailureId;
  final int inspectionId;
  const GetDamageRepairs(this.damageFailureId, this.inspectionId);

  @override
  List<Object> get props => [];
}

class SetDamageCategories extends JobDamageEvent {
  const SetDamageCategories();
  @override
  List<Object> get props => [];
}

class PostJobDamages extends JobDamageEvent {
  final InspectionDamagePostModel data;
  final bool isAsync;
  const PostJobDamages({
    required this.data,
    required this.isAsync,
  });
}
