import 'dart:async';
import 'package:ferrisfwt/feature/auth/data/models/user_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_assets/damage_assets_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_categories/damage_category.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_failures/damage_failure.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_issues/damage_issue.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_parts/damage_part.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_repairs/damage_repair.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade/grade_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade_rule/grade_rule_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade_rule_uplift/grade_rule_uplift_model.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expense_categories_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expense_patch_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expenses_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/job_start/job_start_model.dart';
import 'package:ferrisfwt/feature/home/data/models/job_stop/stop_categories_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/valet_standard/valet_standard_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/checklist/checklist_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/condition_image/condition_image_response_model.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_response_model_item.dart';
import 'package:ferrisfwt/product/database/hive/constants/hive_database_constants.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/checklist/inspection_checklist_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/condition_image/inspection_condition_image_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/update_job_status_post_model.dart';
import 'package:ferrisfwt/product/utility/enums/app_theme_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../feature/home/data/models/damages/damage_combination/damage_combination_model.dart';
import '../../../state/base/model/post_models/job_inspections/sign/inspection_inspector_sign_post_model.dart';

// @immutable
class HiveDatabaseManager {
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter<UserModel>(UserModelAdapter());
    Hive.registerAdapter<StopCategoriesResponseModelItem>(
        StopCategoriesResponseModelItemAdapter());
    Hive.registerAdapter<ValetStandardResponseModelItem>(
        ValetStandardResponseModelItemAdapter());
    Hive.registerAdapter<ExpenseCategoriesResponseModelItem>(
        ExpenseCategoriesResponseModelItemAdapter());
    Hive.registerAdapter<DamagesCategory>(DamagesCategoryAdapter());
    Hive.registerAdapter<DamagesFailure>(DamagesFailureAdapter());
    Hive.registerAdapter<DamagesIssue>(DamagesIssueAdapter());
    Hive.registerAdapter<DamagesPart>(DamagesPartAdapter());
    Hive.registerAdapter<DamagesRepair>(DamagesRepairAdapter());
    Hive.registerAdapter<ChecklistResponseModelItem>(
        ChecklistResponseModelItemAdapter());
    Hive.registerAdapter(ConditionImageResponseModelAdapter());
    Hive.registerAdapter(DamageResponseModelAdapter());
    Hive.registerAdapter(ExpensePostModelAdapter());
    Hive.registerAdapter(InspectionInspectorSignPostModelAdapter());
    Hive.registerAdapter(ExpensesResponseModelItemAdapter());
    Hive.registerAdapter(ExpensePatchResponseModelAdapter());
    Hive.registerAdapter(UpdateJobStatusPostModelAdapter());

    await Hive.openBox<UserModel>(HiveDatabaseConstants.userModelBox);
    await Hive.openBox<JobStartModel>(HiveDatabaseConstants.jobStartModelBox);
    await Hive.openBox<int>(HiveDatabaseConstants.themeModeBox);
    await Hive.openBox<StopCategoriesResponseModelItem>(
        HiveDatabaseConstants.jobStopCategoriesBox);
    await Hive.openBox<ValetStandardResponseModelItem>(
        HiveDatabaseConstants.jobValetStandardBox);
    await Hive.openBox<ExpenseCategoriesResponseModelItem>(
        HiveDatabaseConstants.jobExpenseBox);
    await Hive.openBox<DamagesCategory>(
        HiveDatabaseConstants.damageCategoryBox);
    await Hive.openBox<DamageAssetsModel>(
        HiveDatabaseConstants.damageAssetsBox);
    await Hive.openBox<DamageCombinationModel>(
        HiveDatabaseConstants.damageCombinationBox);
    await Hive.openBox<GradeModel>(HiveDatabaseConstants.gradeBox);
    await Hive.openBox<GradeRuleModel>(HiveDatabaseConstants.gradeRuleBox);
    await Hive.openBox<GradeRuleUpliftModel>(
        HiveDatabaseConstants.gradeRuleUpliftBox);
    await Hive.openBox(HiveDatabaseConstants.location);

    await Hive.openBox<DamagesIssue>(HiveDatabaseConstants.damageIssueBox);
    await Hive.openBox<DamagesFailure>(HiveDatabaseConstants.damageFailureBox);
    await Hive.openBox<DamagesPart>(HiveDatabaseConstants.damagePartBox);
    await Hive.openBox<DamagesRepair>(HiveDatabaseConstants.damageRepairBox);
    await Hive.openBox<ChecklistResponseModelItem>(
        HiveDatabaseConstants.checklistBox);
    await Hive.openBox<DamageResponseModel>(HiveDatabaseConstants.getDamage);
    await Hive.openBox<DamageResponseModel>(HiveDatabaseConstants.getDamageNew);
    await Hive.openBox<ConditionImageResponseModel>(
        HiveDatabaseConstants.conditionImagesBox);
    await Hive.openBox<ExpensesResponseModelItem>(
        HiveDatabaseConstants.expensePostResponse);
    await Hive.openBox<ExpensePatchResponseModel>(
        HiveDatabaseConstants.expensePatchResponse);
    await Hive.openBox<UpdateJobStatusPostModel>(
        HiveDatabaseConstants.jobUpdate);
    await Hive.openBox<InspectionDamagePostModel>(
        HiveDatabaseConstants.getDamages);
    await Hive.openBox<InspectionChecklistPostModel>(
        HiveDatabaseConstants.itemcheckListBox);
    await Hive.openBox<ConditionImageResponseModel>(
        HiveDatabaseConstants.conditionImage);
    await Hive.openBox<InspectionDamagePostModel>(
        HiveDatabaseConstants.recordedDamages);
    await Hive.openBox<ExpensePostModel>(
        HiveDatabaseConstants.postExpenseSaveImage);
    await Hive.openBox<JobInspectionResponseModelItem>(
        HiveDatabaseConstants.inspectEditDetail);
  }

  static final userModelBoxHive =
      Hive.box<UserModel>(HiveDatabaseConstants.userModelBox);

  Future<void> clearUserModel() async {
    await userModelBoxHive.clear();
  }

  Future<void> closeUserModel() async {
    await userModelBoxHive.close();
  }

  Future<void> saveUserModel(UserModel userModel) async {
    await userModelBoxHive.put(HiveDatabaseConstants.userModel, userModel);
  }

  Future<void> saveJob(String jobId, String regnNumber) async {
    UserModel? currentUserModel = getUserModel();
    UserModel user = currentUserModel!.copyWith(
      currentJobId: jobId,
      regnNumber: regnNumber,
      isStarted: true,
    );
    await saveUserModel(user);
  }

  Future<void> updateToken(
      {required String mail, required String token}) async {
    UserModel? currentUserModel = getUserModel();
    UserModel user = currentUserModel!.copyWith(token: token, mail: mail);
    await saveUserModel(user);
  }

  //jobupdate tarzı finish olacak
  //initstate de job detayda true ise popup tekrar çıkart internet iöin

  Future<void> saveInspectionsSign(int inspectionsId) async {
    UserModel? currentUserModel = getUserModel();
    UserModel user = currentUserModel!.copyWith(
      inspectionsSign: [
        inspectionsId,
        ...currentUserModel.inspectionsSign ?? []
      ],
    );
    await saveUserModel(user);
  }

  Future<void> updateFinishStatus() async {
    UserModel? currentUserModel = getUserModel();
    UserModel user = currentUserModel!.copyWith(
      isjobFinish: true,
    );
    await saveUserModel(user);
  }

  Future<void> updateLastUse() async {
    UserModel? currentUserModel = getUserModel();
    UserModel user = currentUserModel!.copyWith(
      isLastUse: DateTime.now().toString(),
    );
    await saveUserModel(user);
  }

  Future<void> deleteJob() async {
    UserModel? currentUserModel = getUserModel();
    UserModel user = currentUserModel!.copyWith(
      currentJobId: "",
      inspectionsJobId: [],
      totalStop: 0,
      inspectionsSign: [],
      regnNumber: null,
      isStarted: false,
      isjobFinish: false,
    );
    await saveUserModel(user);
  }

  Future<void> setToken(String token) async {
    UserModel? currentUserModel = getUserModel();
    UserModel user = currentUserModel!.copyWith(
      token: token,
    );
    await saveUserModel(user);
  }

  Future<void> saveInspectionsJobId(List<int> inspectionsJobId) async {
    UserModel? currentUserModel = getUserModel();
    UserModel user = currentUserModel!.copyWith(
      inspectionsJobId: inspectionsJobId,
    );
    await saveUserModel(user);
  }

  Future<void> saveTotalStop(int totalStop) async {
    UserModel? currentUserModel = getUserModel();
    UserModel user = currentUserModel!.copyWith(
      totalStop: totalStop,
    );
    await saveUserModel(user);
  }

  UserModel? getUserModel() {
    return userModelBoxHive.get(HiveDatabaseConstants.userModel);
  }

  Future<void> deleteUserModel() async {
    await userModelBoxHive.delete(HiveDatabaseConstants.userModel);
    await userModelBoxHive.clear();
  }

  Future<void> deleteUserToken() async {
    UserModel? currentUserModel = getUserModel();
    UserModel user = currentUserModel!.copyWith(
      token: '',
    );
    await saveUserModel(user);
  }

  static final themeModeBox = Hive.box<int>(HiveDatabaseConstants.themeModeBox);

  Future<void> saveThemeMode(AppThemes themeMode) async {
    await themeModeBox.put(HiveDatabaseConstants.themeModeKey, themeMode.index);
  }

  AppThemes? getThemeMode() {
    final int? modeIndex = themeModeBox.get(HiveDatabaseConstants.themeModeKey);
    return modeIndex != null ? AppThemes.values[modeIndex] : null;
  }
}
