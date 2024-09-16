library hive_storage_manager;

import 'package:bot_toast/bot_toast.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_assets/damage_assets_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_combination/damage_combination_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_combination/score_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade_rule/grade_rule_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade_rule_uplift/grade_rule_uplift_model.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expense_patch_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expenses_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/job_start/job_start_model.dart';
import 'package:ferrisfwt/feature/home/data/models/job_tracking_coordinates/tracking_coordinates_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/gradle_item_model.dart';
import 'package:ferrisfwt/feature/inspections/data/models/checklist/checklist_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/condition_image/condition_image_response_model.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspections_details_model.dart';
import 'package:ferrisfwt/product/database/hive/constants/hive_database_constants.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/checklist/inspection_checklist_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/condition_image/inspection_condition_image_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_customer_sign_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_inspector_sign_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/end_job_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/update_job_status_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/stops/stop_post_model.dart';
import 'package:hive/hive.dart';
import 'package:async/async.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_categories/damage_category.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_failures/damage_failure.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_issues/damage_issue.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_parts/damage_part.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expense_categories_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/job_stop/stop_categories_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/valet_standard/valet_standard_response_model_item.dart';
import 'package:ferrisfwt/product/database/hive_operation/models/inspection_damage/inspection_damage.dart';
import 'package:ferrisfwt/product/database/hive_operation/models/inspection_sign/inspection_sign.dart';
import 'package:ferrisfwt/product/database/hive_operation/models/stop/stop.dart';
import 'package:flutter/cupertino.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_repairs/damage_repair.dart';
import 'package:uuid/uuid.dart';

import '../../../feature/home/data/models/damages/grade/grade_model.dart';
import '../../utility/error_handler/sentry_error_handler.dart';

part 'operation_mixins/damage/damage_assets_operation_mixin.dart';
part 'operation_mixins/job/job_start_operation_mixin.dart';
part 'operation_mixins/damage/damage_combination_operation_mixin.dart';
part 'operation_mixins/damage/grade_operation_mixin.dart';
part 'operation_mixins/damage/grade_rule_operation_mixin.dart';
part 'operation_mixins/damage/grade_rule_uplift_operation_mixin.dart';

part 'operation_mixins/location/location_operation_mixin.dart';

part 'operation_mixins/stop_operations_mixin.dart';

part 'operation_mixins/job_update_operation_mixin.dart';

part 'operation_mixins/expense_operations_mixin.dart';

part 'operation_mixins/job_update_operations_mixin.dart';

part 'operation_mixins/job_to_finish_operations_mixin.dart';

part 'operation_mixins/inspections/inspection_sign_operations_mixin.dart';

part 'operation_mixins/inspections/inspection_damage_operations_mixin.dart';

part 'operation_mixins/inspections/inspection_checklist_operations_mixin.dart';

part 'operation_mixins/inspections/inspection_details_operations_mixin.dart';

part 'operation_mixins/inspections/inspection_condition_image_operations_mixin.dart';

part 'operation_mixins/damage/damage_repair_operation_mixin.dart';

part 'operation_mixins/damage/damage_category_operation_mixin.dart';

part 'operation_mixins/damage/damage_issue_operation_mixin.dart';

part 'operation_mixins/damage/damage_part_operation_mixin.dart';

part 'operation_mixins/damage/damage_failure_operation_mixin.dart';

part 'operation_mixins/valet_standard_operation_mixin.dart';

part 'operation_mixins/expense_categories_operations_mixin.dart';

part 'operation_mixins/job_working_on_operations_mixin.dart';

part 'operation_mixins/stop_categories_operations_mixin.dart';

part 'operation_mixins/tracking_coordinate_operations_mixin.dart';

part 'operation_mixins/stop_async_operations_mixin.dart';

part 'operation_mixins/job_expense_async_operations_mixin.dart';

part 'operation_mixins/inspections/inspection_checklist_post_operations_mixin.dart';

part 'operation_mixins/inspections/inspection_condition_image_post_operations_mixin.dart';

part 'operation_mixins/inspections/inspection_damage_post_operations_mixin.dart';

part 'operation_mixins/inspections/inspection_sign_post_customer_operations_mixin.dart';

part 'operation_mixins/inspections/inspection_sign_post_operations_mixin.dart';

part 'operation_mixins/inspections/inspections_list_operations_mixin.dart';

part 'operation_mixins/job_expense_patch_mixin.dart';

part 'operation_mixins/damage/get_damage_operations_mixin.dart';

part 'operation_mixins/expense_post_response_operations_mixin.dart';

part 'operation_mixins/expense_patch_response_operations_mixin.dart';

part 'operation_mixins/itemchecklist_operation_mixin.dart';

part 'operation_mixins/condition_images_operation_mixin.dart';

part 'operation_mixins/damage_operation_mixin.dart';

part 'operation_mixins/post_expense_save_image.dart';

part 'operation_mixins/inspections/inspect_edit_detail_operation_mixin.dart';

/// Perform the CRUD operations on all oof the hive models with this class.
class HiveStorageManager
    with
        StopOperationsMixin,
        DamageRepairOperationMixin,
        DamageCategoryOperationMixin,
        DamageAssetsOperationMixin,
        DamageCombinationOperationMixin,
        GradeOperationMixin,
        GradeRuleOperationMixin,
        GradeRuleUpliftOperationMixin,
        LocationOperationMixin,
        DamageIssueOperationMixin,
        DamagePartOperationMixin,
        JobStartOperationMixin,
        DamageFailureOperationMixin,
        ValetStandardOperationMixin,
        ExpenseCategoriesOperationsMixin,
        JobWorkingOnOperationsMixin,
        StopCategoriesOperationsMixin,
        ExpenseOperationsMixin,
        JobUpdateOperationsMixin,
        JobToFinishOperationsMixin,
        InspectionSignOperationsMixin,
        InspectionDamageOperationsMixin,
        InspectionChecklistOperationsMixin,
        InspectionDetailsOperationsMixin,
        JobStopAsyncOperationsMixin,
        JobExpenseAsyncOperationsMixin,
        TrackingCoordinateOperationsMixin,
        InspectionConditionImageOperationsMixin,
        InspectionChecklistPostOperationsMixin,
        InspectionConditionImagePostOperationsMixin,
        InspectionSignPostCustomerOperationsMixin,
        InspectionSignPostInspectorOperationsMixin,
        JobExpensePatchAsyncOperationsMixin,
        InspectionsListOperationsMixin,
        ExpensePostResponseOperationsMixin,
        ExpensePatchPostResponseOperationsMixin,
        GetDamageOperationMixin,
        JopUpdateOperationMixin,
        ItemChecklistOperationMixin,
        DamageOperationMixin,
        ConditionImageOperationMixin,
        PostExpenseSaveImageOperationMixin,
        InspectionDamagePostOperationsMixin,
        InspectEditDetail {
  /// gets an merged stream of all the boxes related to uploading job data.
  Future<Stream> get jobDataOperationsStream async => StreamGroup.merge([
        (await _stopBox).watch(),
        (await _expenseBox).watch(),
        (await _jobUpdateBox).watch(),
        (await _inspectionSignBox).watch(),
        (await _inspectionDamageBox).watch(),
        (await _inspectionDetailsBox).watch(),
        (await _jobWorkingBox).watch(),
        (await _jobStopAsyncBox).watch(),
        (await _jobExpenseAsyncBox).watch(),
        (await _jobToFinishBox).watch(),
        (await _trackingCoordinateBox).watch(),
      ]);

  // lazy singleton
  static HiveStorageManager? _instance;

  factory HiveStorageManager() => _instance ??= HiveStorageManager._internal();

  HiveStorageManager._internal();
}
