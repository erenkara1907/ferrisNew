import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_abort_type_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/domain/repositories/job_inspections_repository.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';

class UCGetJobInspections {
  UCGetJobInspections({required JobInspectionsRepository repository})
      : _repository = repository;

  final JobInspectionsRepository _repository;

  Future<Either<Failure, List<JobInspectionResponseModelItem>>>
      getJobInspections({int? jobId, String? regNumber}) {
    return _repository.getJobInspections(
      jobId: jobId,
      regNumber: regNumber,
    );
  }

  Future<Either<Failure, List<JobInspectionAbortTypeItem>>>
      getJobInspectionAbortTypes() {
    return _repository.getJobInspectionAbortTypes();
  }

  Future<Either<Failure, JobInspectionResponseModelItem>> postDetails({
    required double odoReading,
    required int fuelLevel,
    required int inspectionId,
  }) {
    return _repository.postDetails(
      odoReading: odoReading,
      fuelLevel: fuelLevel,
      inspectionId: inspectionId,
    );
  }
}
