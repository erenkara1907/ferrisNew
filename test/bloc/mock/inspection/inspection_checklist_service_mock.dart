import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/inspections/data/models/checklist/checklist_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/checklist/checklist_update_response_model.dart';
import 'package:ferrisfwt/feature/inspections/domain/usecases/uc_get_inspection_checklist.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/checklist/inspection_checklist_post_model.dart';
import 'package:mockito/mockito.dart';

final class InspectionChecklistServiceMock extends Mock
    implements UCGetJobInspectionsCheckList {
  @override
  Future<Either<Failure, List<ChecklistResponseModelItem>>> getChecklists(
      {required int? inspectionId}) {
    List<ChecklistResponseModelItem> r = [
      ChecklistResponseModelItem(
        id: 1,
        jobInspectionId: 1,
        inflatorKit: 1,
        evCable: 1,
        jack: 1,
        spareWheel: 1,
        gelCompressorKit: 1,
        thirteenAmpEvChargingCable: 1,
        hvChargingCable: 1,
        spareKey: 1,
        masterKey: 1,
      ),
      ChecklistResponseModelItem(
        id: 2,
        jobInspectionId: 1,
        inflatorKit: 1,
        evCable: 1,
        jack: 1,
        spareWheel: 1,
        gelCompressorKit: 1,
        thirteenAmpEvChargingCable: 1,
        hvChargingCable: 1,
        spareKey: 1,
        masterKey: 1,
      ),
    ];
    if (inspectionId == 1) {
      return Future.value(Right(r));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, String>> postChecklist(
      {required InspectionChecklistPostModel data}) {
    if (data.jobInspectionId == 1) {
      return Future.value(const Right("OKAY"));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, ChecklistUpdateResponseModel>> patchChecklist(
      {required InspectionChecklistPostModel data, required int checklistId}) {
    // TODO: implement patchChecklist
    if (checklistId == 1) {
      return Future.value(
        Right(
          ChecklistUpdateResponseModel(
            oldChecklist: ChecklistResponseModelItem(
              id: 1,
              jobInspectionId: 1,
              inflatorKit: 1,
              evCable: 1,
              jack: 1,
              spareWheel: 1,
              gelCompressorKit: 1,
              thirteenAmpEvChargingCable: 1,
              hvChargingCable: 1,
              spareKey: 1,
              masterKey: 1,
            ),
            newChecklist: ChecklistResponseModelItem(
              id: 2,
              jobInspectionId: 1,
              inflatorKit: 1,
              evCable: 1,
              jack: 1,
              spareWheel: 1,
              gelCompressorKit: 1,
              thirteenAmpEvChargingCable: 1,
              hvChargingCable: 1,
              spareKey: 1,
              masterKey: 1,
            ),
          ),
        ),
      );
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }
}
