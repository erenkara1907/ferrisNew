import 'package:ferrisfwt/feature/auth/data/models/user_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/job_stop/stop_evidence_model.dart';
import 'package:ferrisfwt/feature/home/data/models/job_stop/stops_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/job_tracking_coordinates/tracking_coordinates_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/movement_type/feedback_input_availability.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/movement_type/movement_type_model.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/tracking_status_model.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/vehicle_model.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_abort_type_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_type.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspections_details_model.dart';
import 'package:ferrisfwt/feature/inspections/data/models/sign/customer_sign_response_model.dart';
import 'package:ferrisfwt/feature/inspections/data/models/sign/inspector_sign_response_model.dart';
import 'package:ferrisfwt/product/database/hive_operation/models/inspection_checklist/inspection_checklist.dart';
import 'package:ferrisfwt/product/database/hive_operation/models/inspection_condition_image/inspection_condition_image.dart';
import 'package:ferrisfwt/product/database/hive_operation/models/inspection_damage/inspection_damage.dart';
import 'package:ferrisfwt/product/database/hive_operation/models/inspection_details/inspection_details.dart';
import 'package:ferrisfwt/product/database/hive_operation/models/inspection_sign/inspection_sign.dart';
import 'package:ferrisfwt/product/database/hive_operation/models/job_to_finish/job_to_finish.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/checklist/inspection_checklist_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/condition_image/inspection_condition_image_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_customer_sign_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_inspector_sign_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/end_job_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/stops/stop_post_file_adaptor.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/stops/stop_post_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/expense/expense.dart';
import 'models/job_update/job_update.dart';
import 'models/stop/stop.dart';

/// contains functions for initializing hive
abstract class HiveInit {
  /// Initialize hive
  static Future hiveInit() async {
    Hive.registerAdapter(StopAdapter());
    Hive.registerAdapter(ExpenseAdapter());
    Hive.registerAdapter(StopsResponseModelItemAdapter());
    Hive.registerAdapter(StopEvidenceModelAdapter());
    Hive.registerAdapter(FileAdapter());
    Hive.registerAdapter(JobToFinishAdapter());
    Hive.registerAdapter(EndJobPostModelAdapter());
    Hive.registerAdapter(TrackingCoordinatesResponseModelItemAdapter());
    Hive.registerAdapter(InspectionSignAdapter());
    Hive.registerAdapter(CustomerSignResponseModelAdapter());
    Hive.registerAdapter(InspectorSignResponseModelAdapter());
    Hive.registerAdapter(InspectionDamageAdapter());
    Hive.registerAdapter(InspectionChecklistAdapter());
    Hive.registerAdapter(InspectionDetailsAdapter());
    Hive.registerAdapter(InspectionConditionImageAdapter());
    Hive.registerAdapter(JobsResponseModelItemAdapter());
    Hive.registerAdapter(MovementTypeModelAdapter());
    Hive.registerAdapter(VehicleModelAdapter());
    Hive.registerAdapter(UserResponseModelAdapter());
    Hive.registerAdapter(TrackingStatusModelAdapter());
    Hive.registerAdapter(ClientResponseModelAdapter());
    Hive.registerAdapter(RoleAdapter());
    Hive.registerAdapter(FeedbackInputAvailabilityAdapter());
    Hive.registerAdapter(FeedbackInputAvailabilityEnumAdapter());
    Hive.registerAdapter(LatLngAdapter());
    Hive.registerAdapter(StopPostModelAdapter());
    Hive.registerAdapter(JobUpdateAdapter());
    Hive.registerAdapter(InspectionChecklistPostModelAdapter());
    Hive.registerAdapter(InspectionConditionImagePostModelAdapter());
    Hive.registerAdapter(InspectionDamagePostModelAdapter());
    Hive.registerAdapter(InspectionCustomerSignPostModelAdapter());
    Hive.registerAdapter(InspectionInspectorSignPostModelAdapter());
    Hive.registerAdapter(JobInspectionAbortTypeItemAdapter());
    Hive.registerAdapter(JobInspectionTypeAdapter());
    Hive.registerAdapter(InspectionDetailsPostModelAdapter());
    Hive.registerAdapter(ExpensePatchModelAdapter());
    Hive.registerAdapter(JobInspectionResponseModelItemAdapter());
  }
}
