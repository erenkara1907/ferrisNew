import 'package:dartz/dartz.dart';

import 'package:ferrisfwt/feature/inspections/data/models/checklist/checklist_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/checklist/checklist_update_response_model.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/checklist/inspection_checklist_post_model.dart';

abstract interface class JobInspectionsCheckListRepository {
  Future<Either<Failure, List<ChecklistResponseModelItem>>> getChecklists({
    required int? inspectionId,
  });

  Future<Either<Failure, String>> postChecklist({
    required InspectionChecklistPostModel data,
  });

  Future<Either<Failure, ChecklistUpdateResponseModel>> patchChecklist({
    required InspectionChecklistPostModel data,
    required int checklistId,
  });
}
