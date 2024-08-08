import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/home/data/models/job_tracking_coordinates/tracking_coordinates_response_model_item.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';

abstract interface class JobTrackingCoordinatesRepository {
  Future<Either<Failure, List<TrackingCoordinatesResponseModelItem>>>
      getJobTrackingCoordinatess({
    required int jobId,
  });

  Future<Either<Failure, TrackingCoordinatesResponseModelItem>>
      getTrackingCoordinate({
    required int id,
  });

  Future<Either<Failure, void>> updateTrackingCoordinate({
    required int jobId,
    required double latitude,
    required double longitude,
  });
}
