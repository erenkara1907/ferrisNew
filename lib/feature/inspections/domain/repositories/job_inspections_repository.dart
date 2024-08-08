import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_abort_type_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_response_model_item.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';

abstract interface class JobInspectionsRepository {
  Future<Either<Failure, List<JobInspectionResponseModelItem>>>
      getJobInspections({int? jobId, String? regNumber});

  Future<Either<Failure, List<JobInspectionAbortTypeItem>>>
      getJobInspectionAbortTypes();

  Future<Either<Failure, JobInspectionResponseModelItem>> postDetails({
    required double odoReading,
    required int fuelLevel,
    required int inspectionId,
  });
}
