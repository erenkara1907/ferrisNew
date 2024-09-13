import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_abort_type_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/domain/usecases/uc_get_job_inspections.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:mockito/mockito.dart';

final class InspectionServiceMock extends Mock implements UCGetJobInspections {
  @override
  Future<Either<Failure, List<JobInspectionResponseModelItem>>>
      getJobInspections({int? jobId, String? regNumber}) {
    List<JobInspectionResponseModelItem> r = [
      const JobInspectionResponseModelItem(id: 1),
      const JobInspectionResponseModelItem(id: 2),
      const JobInspectionResponseModelItem(id: 3),
    ];
    if (jobId == 1) {
      return Future.value(Right(r));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, List<JobInspectionAbortTypeItem>>>
      getJobInspectionAbortTypes() {
    List<JobInspectionAbortTypeItem> r = [
      const JobInspectionAbortTypeItem(id: 1),
      const JobInspectionAbortTypeItem(id: 2),
      const JobInspectionAbortTypeItem(id: 3),
    ];
    if (r.isNotEmpty) {
      return Future.value(Right(r));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, JobInspectionResponseModelItem>> postDetails(
      {required double odoReading,
      required int fuelLevel,
      required int inspectionId}) {
    if (inspectionId == 1) {
      return Future.value(const Right(JobInspectionResponseModelItem(id: 1)));
    } else {
      return Future.value(Left(NullResponseFailure()));
    }
  }
}
