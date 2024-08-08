import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/home/data/models/job_tracking_coordinates/tracking_coordinates_response_model_item.dart';
import 'package:ferrisfwt/feature/home/domain/repositories/job_tracking_coordinates_repository.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';

final class UCGetJobTrackingCoordinates {
  UCGetJobTrackingCoordinates(
      {required JobTrackingCoordinatesRepository repository})
      : _repository = repository;

  final JobTrackingCoordinatesRepository _repository;

  Future<Either<Failure, List<TrackingCoordinatesResponseModelItem>>>
      getJobTrackingCoordinatess({
    required int jobId,
  }) {
    return _repository.getJobTrackingCoordinatess(jobId: jobId);
  }

  Future<Either<Failure, TrackingCoordinatesResponseModelItem>>
      getTrackingCoordinate({
    required int id,
  }) {
    return _repository.getTrackingCoordinate(id: id);
  }

  Future<Either<Failure, void>> updateTrackingCoordinate({
    required int jobId,
    required double latitude,
    required double longitude,
  }) {
    return _repository.updateTrackingCoordinate(
      jobId: jobId,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
