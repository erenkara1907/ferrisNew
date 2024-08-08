import 'package:dartz/dartz.dart';

import 'package:ferrisfwt/feature/inspections/data/models/checklist/checklist_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/checklist/checklist_update_response_model.dart';
import 'package:ferrisfwt/feature/inspections/domain/repositories/inspection_checklist_repository.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/checklist/inspection_checklist_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/checklist/inspection_checklist_post_model.dart';

final class UCGetJobInspectionsCheckList {
  UCGetJobInspectionsCheckList(
      {required JobInspectionsCheckListRepository repository})
      : _repository = repository;

  final JobInspectionsCheckListRepository _repository;

  Future<Either<Failure, List<ChecklistResponseModelItem>>> getChecklists({
    required int? inspectionId,
  }) {
    return _repository.getChecklists(
      inspectionId: inspectionId,
    );
  }

  Future<Either<Failure, String>> postChecklist({
    required InspectionChecklistPostModel data,
  }) {
    return _repository.postChecklist(
      data: data,
    );
  }

  Future<Either<Failure, ChecklistUpdateResponseModel>> patchChecklist({
    required InspectionChecklistPostModel data,
    required int checklistId,
  }) {
    return _repository.patchChecklist(
      data: data,
      checklistId: checklistId,
    );
  }
}
