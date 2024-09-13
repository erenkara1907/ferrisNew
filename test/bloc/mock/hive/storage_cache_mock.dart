import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_assets/damage_assets_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_categories/damage_category.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_combination/damage_combination_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_failures/damage_failure.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_issues/damage_issue.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_parts/damage_part.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_repairs/damage_repair.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade/grade_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade_rule/grade_rule_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade_rule_uplift/grade_rule_uplift_model.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expense_categories_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expenses_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/job_start/job_start_model.dart';
import 'package:ferrisfwt/feature/home/data/models/job_stop/stop_categories_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/job_tracking_coordinates/tracking_coordinates_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/valet_standard/valet_standard_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/checklist/checklist_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/condition_image/condition_image_response_model.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspections_details_model.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/checklist/inspection_checklist_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_customer_sign_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_inspector_sign_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/end_job_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/update_job_status_post_model.dart';
import 'package:mockito/mockito.dart';

final class StorageCacheMock extends Mock implements HiveStorageManager {
  @override
  Future<JobsResponseModelItem?> getJobWorkingOn() {
    return Future.value(JobsResponseModelItem(id: 1));
  }

  @override
  Future<void> setJobWorkingOn(JobsResponseModelItem data) {
    return Future.value();
  }

  @override
  Future<void> addJobToTable(List<JobStartModel> data) {
    return Future.value();
  }

  @override
  Future<void> saveJobToFinish(EndJobPostModel data) {
    return Future.value();
  }

  @override
  Future<void> setJopUpdates(UpdateJobStatusPostModel userModel) {
    return Future.value();
  }

  @override
  Future insertJobUpdate(UpdateJobStatusPostModel data) {
    return Future.value();
  }

  @override
  Future<void> setValetStandards(List<ValetStandardResponseModelItem> list) {
    return Future.value();
  }

  @override
  Future<List<ValetStandardResponseModelItem>?> getValetStandards() {
    return Future.value();
  }

  @override
  Future<TrackingCoordinatesResponseModelItem?> getTrackingCoordinateModel() {
    TrackingCoordinatesResponseModelItem model =
        const TrackingCoordinatesResponseModelItem(
            id: 1, jobId: 1, latitude: 10.0, longitude: 10.0, addedTime: 1);
    return Future.value(model);
  }

  @override
  Future<void> setStopCategories(
      List<StopCategoriesResponseModelItem> stopCategories) {
    return Future.value();
  }

  @override
  List<StopCategoriesResponseModelItem> getStopCategories() {
    List<StopCategoriesResponseModelItem> r = [
      StopCategoriesResponseModelItem(id: 1, name: "category 1"),
      StopCategoriesResponseModelItem(id: 2, name: "category 2"),
      StopCategoriesResponseModelItem(id: 3, name: "category 3"),
    ];

    return r;
  }

  @override
  Future<List<ExpensesResponseModelItem?>> getExpense() {
    List<ExpensesResponseModelItem?> r = [
      ExpensesResponseModelItem(
        id: 1,
        jobId: 1,
        price: 20.0,
        reasonNoReceipt: "reason no receipt",
        receiptPath: [],
        categoryId:
            ExpenseCategoriesResponseModelItem(id: 1, name: "category 1"),
      ),
    ];
    return Future.value(r);
  }

  @override
  Future<void> addPostExpenseSaveImage(ExpensePostModel userModel) {
    return Future.value();
  }

  @override
  Future<ExpensesResponseModelItem?> setExpenseById(
      ExpensesResponseModelItem expense) {
    return Future.value(
      ExpensesResponseModelItem(
        id: 1,
        jobId: 1,
        categoryId:
            ExpenseCategoriesResponseModelItem(id: 1, name: "category 1"),
        price: 20.0,
        reasonNoReceipt: "reasonNoReceipt",
        receiptPath: [],
      ),
    );
  }

  @override
  Future<void> setJobExpenseAsync(ExpensePostModel data) {
    return Future.value();
  }

  @override
  Future<ExpensesResponseModelItem?> setExpenseUpdateById(
      ExpensesResponseModelItem expense, int id) {
    return Future.value(
      ExpensesResponseModelItem(
        id: 1,
        jobId: 1,
        categoryId:
            ExpenseCategoriesResponseModelItem(id: 1, name: "category 1"),
        price: 20.0,
        reasonNoReceipt: "reasonNoReceipt",
        receiptPath: [],
      ),
    );
  }

  @override
  ExpensePostModel? getPostExpenseSaveImage(
      {required double price, required int categoryId}) {
    return ExpensePostModel(jobId: 1, categoryId: categoryId, price: price);
  }

  @override
  Future<void> updateLastPostExpenseSaveImage(
      {required double oldPrice,
      required int oldCategoryId,
      required ExpensePostModel newExpense}) {
    return Future.value();
  }

  @override
  Future<void> setJobExpensePatchAsync(ExpensePatchModel data) {
    return Future.value();
  }

  @override
  Future<void> updateJobExpenseAsync(
      ExpensePostModel data, bool Function(ExpensePostModel p1) criteria) {
    return Future.value();
  }

  @override
  Future<void> setExpenseCategories(
      List<ExpenseCategoriesResponseModelItem> categoryList) {
    return Future.value();
  }

  @override
  Future<List<ExpensePostModel?>> getJobExpenseAsync() {
    List<ExpensePostModel?> r = [
      ExpensePostModel(categoryId: 1, jobId: 1, price: 20.0),
      ExpensePostModel(categoryId: 2, jobId: 1, price: 20.0),
      ExpensePostModel(categoryId: 3, jobId: 1, price: 20.0),
    ];
    return Future.value(r);
  }

  @override
  Future<void> deleteExpenses() {
    return Future.value();
  }

  @override
  Future<bool> addExpense(List<ExpensesResponseModelItem> expense) {
    return Future.value(true);
  }

  @override
  Future<List<ExpenseCategoriesResponseModelItem>?> getExpenseCategories() {
    List<ExpenseCategoriesResponseModelItem>? r = [
      ExpenseCategoriesResponseModelItem(id: 1, name: "category 1"),
      ExpenseCategoriesResponseModelItem(id: 2, name: "category 2"),
      ExpenseCategoriesResponseModelItem(id: 3, name: "category 3"),
    ];
    return Future.value(r);
  }

  @override
  Future<void> addDamageAssetsToTable(List<DamageAssetsModel> data) {
    return Future.value();
  }

  @override
  Future<void> addDamageCombinationToTable(List<DamageCombinationModel> data) {
    return Future.value();
  }

  @override
  Future<void> addGradeToTable(List<GradeModel> data) {
    return Future.value();
  }

  @override
  Future<void> addGradeRuleToTable(List<GradeRuleModel> data) {
    return Future.value();
  }

  @override
  Future<void> addGradeRuleUpliftToTable(List<GradeRuleUpliftModel> data) {
    return Future.value();
  }

  @override
  Future<List<DamagesCategory?>> getDamageCategories() {
    List<DamagesCategory?> r = [
      DamagesCategory(id: 1, name: "category 1"),
      DamagesCategory(id: 2, name: "category 2"),
      DamagesCategory(id: 3, name: "category 3"),
    ];
    return Future.value(r);
  }

  @override
  Future<List<JobInspectionResponseModelItem?>> getInspectionsListModel() {
    List<JobInspectionResponseModelItem?> r = [
      const JobInspectionResponseModelItem(id: 1),
      const JobInspectionResponseModelItem(id: 2),
      const JobInspectionResponseModelItem(id: 3),
    ];
    return Future.value(r);
  }

  @override
  Future<void> setInspectionsListModel(
      List<JobInspectionResponseModelItem?> data) {
    return Future.value();
  }

  @override
  Future<void> putInspectionChecklist(
      List<ChecklistResponseModelItem> inspectionChecklist) {
    return Future.value();
  }

  @override
  Future<void> setItemCheckList(InspectionChecklistPostModel model) {
    return Future.value();
  }

  @override
  Future<void> setChecklistPostModel(InspectionChecklistPostModel data) {
    return Future.value();
  }

  @override
  Future<void> updateInspectionConditionImage(
      int imageId, ConditionImageResponseModel updatedData) {
    return Future.value();
  }

  @override
  Future<void> addConditionImage(ConditionImageResponseModel userModel) {
    return Future.value();
  }

  @override
  Future<void> replaceInspectionConditionImagesTable(
      ConditionImageResponseModel data) {
    return Future.value();
  }

  @override
  Future<void> setConditionImagePostModel(ConditionImageResponseModel data) {
    return Future.value();
  }

  @override
  Future<List<ConditionImageResponseModel?>> getConditionImagePostModel(
      int inspectionsId) {
    List<ConditionImageResponseModel?> r = [
      ConditionImageResponseModel(jobInspectionId: 1),
      ConditionImageResponseModel(jobInspectionId: 2),
      ConditionImageResponseModel(jobInspectionId: 3),
    ];
    return Future.value(r);
  }

  @override
  Future<void> deleteConditionImagePostModel(int id) {
    return Future.value();
  }

  @override
  Future<void> storeDeletedId(ConditionImageResponseModel data) {
    return Future.value();
  }

  @override
  Future<void> deleteInspectionConditionImage(
      {required int jobInspectionId, required int conditionId}) {
    return Future.value();
  }

  @override
  Future<void> deleteConditionImage(int jobInspectionId, int index) {
    return Future.value();
  }

  @override
  Future<JobInspectionResponseModelItem?> getInspectionById(int inspectionId) {
    return Future.value(const JobInspectionResponseModelItem(id: 1));
  }

  @override
  Future<List<DamageResponseModel>> getGetDamageNew(int inspectionId) {
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
    return Future.value(r);
  }

  @override
  Future<void> deleteGetDamageNew(int inspectionId, int damageId) {
    return Future.value();
  }

  @override
  Future<void> deleteDamagePostModel(int inspectionsId) {
    return Future.value();
  }

  @override
  Future<void> deleteGetDamage(int inspectionId, int damageId) {
    return Future.value();
  }

  @override
  Future<void> setGetDamageNew(DamageResponseModel damage) {
    return Future.value();
  }

  @override
  Future<void> updateDamageId(int oldId, int newId) {
    return Future.value();
  }

  @override
  void setDamageBoolValue(bool value) {
    return;
  }

  @override
  Future<List<JobStartModel?>> getJobs() {
    List<JobStartModel?> r = [
      JobStartModel(id: 1),
      JobStartModel(id: 2),
      JobStartModel(id: 3),
    ];
    return Future.value(r);
  }

  @override
  Future<List<DamageCombinationModel?>> getDamageCombination() {
    List<DamageCombinationModel?> r = [
      DamageCombinationModel(id: 1),
      DamageCombinationModel(id: 2),
      DamageCombinationModel(id: 3),
    ];
    return Future.value(r);
  }

  @override
  Future<void> setDamagePostModel(InspectionDamagePostModel data) {
    return Future.value();
  }

  @override
  Future<void> setGetDamage(DamageResponseModel damage) {
    return Future.value();
  }

  @override
  Future<void> setRecordedDamage(InspectionDamagePostModel userModel) {
    return Future.value();
  }

  @override
  Future<void> updateInspectionsListModelGrade(
      JobInspectionResponseModelItem data) {
    return Future.value();
  }

  @override
  Future<List<ConditionImageResponseModel>> getInspectionConditionImages(
      int inspectionId) {
    List<ConditionImageResponseModel> r = [
      ConditionImageResponseModel(
          id: 1, jobInspectionId: 1, imageFile: File("path"), imagePath: ""),
      ConditionImageResponseModel(
          id: 1, jobInspectionId: 2, imageFile: File("path"), imagePath: ""),
      ConditionImageResponseModel(
          id: 1, jobInspectionId: 3, imageFile: File("path"), imagePath: ""),
    ];
    return Future.value(r);
  }

  @override
  Future<void> updateInspectionsListModel(
      List<JobInspectionResponseModelItem?> data) {
    return Future.value();
  }

  @override
  Future<List<GradeModel?>> getGrades() {
    List<GradeModel?> r = [
      GradeModel(id: 1),
      GradeModel(id: 2),
      GradeModel(id: 3),
    ];
    return Future.value(r);
  }

  @override
  Future<List<GradeRuleModel?>> getGradeRules() {
    List<GradeRuleModel?> r = [
      GradeRuleModel(id: 1, gradeId: 1),
      GradeRuleModel(id: 2, gradeId: 2),
      GradeRuleModel(id: 3, gradeId: 3),
    ];
    return Future.value(r);
  }

  @override
  Future<List<GradeRuleUpliftModel?>> getGradeRuleUplifts() {
    List<GradeRuleUpliftModel?> r = [
      GradeRuleUpliftModel(gradeRuleId: 1, upToGradeId: 1),
      GradeRuleUpliftModel(gradeRuleId: 2, upToGradeId: 2),
      GradeRuleUpliftModel(gradeRuleId: 3, upToGradeId: 3),
    ];
    return Future.value(r);
  }

  @override
  Future<List<DamageResponseModel>> getGetDamage(int inspectionId) {
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

    return Future.value(r);
  }

  @override
  Future<void> setSignCustomerPostModel(
      InspectionCustomerSignPostModel data, int inspectionsId) {
    return Future.value();
  }

  @override
  Future<void> setSignInspectorPostModel(
      InspectionInspectorSignPostModel data, int inspectionsId) {
    return Future.value();
  }

  @override
  Future<void> putInspectionDetails(
      InspectionDetailsPostModel inspectionDetails) {
    return Future.value();
  }

  @override
  Future<List<DamageAssetsModel>> getDamageAssetsByIds(List<int> standardIds) {
    List<DamageAssetsModel> r = [
      DamageAssetsModel(id: 1),
      DamageAssetsModel(id: 2),
      DamageAssetsModel(id: 3),
    ];
    return Future.value(r);
  }
}
