import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/home/data/models/job_tracking_coordinates/tracking_coordinates_response_model_item.dart';
import 'package:ferrisfwt/feature/home/domain/usecases/uc_get_job_tracking_coordinates.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:mockito/mockito.dart';

final class TrackingCoordinatesServiceMock extends Mock
    implements UCGetJobTrackingCoordinates {
  @override
  Future<Either<Failure, List<TrackingCoordinatesResponseModelItem>>>
      getJobTrackingCoordinatess({required int jobId}) {
    List<TrackingCoordinatesResponseModelItem> r = [
      TrackingCoordinatesResponseModelItem(
        id: 1,
        jobId: jobId,
        addedTime: 1,
        latitude: 10.0,
        longitude: 20.0,
      ),
      TrackingCoordinatesResponseModelItem(
        id: 2,
        jobId: jobId,
        addedTime: 2,
        latitude: 10.0,
        longitude: 20.0,
      ),
      TrackingCoordinatesResponseModelItem(
        id: 3,
        jobId: jobId,
        addedTime: 3,
        latitude: 10.0,
        longitude: 20.0,
      ),
    ];
    if (jobId == 1) {
      return Future.value(Right(r));
    } else {
      return Future.value(Left(UnknownFailure()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTrackingCoordinate(
      {required int jobId,
      required double latitude,
      required double longitude}) {
    if (jobId == 1 && latitude == 20.0 && longitude == 20.0) {
      // Başarılı durumda Right birim değeri döndürülür
      return Future.value(const Right(
          null)); // void türünde bir sonuç döndürmek için 'null' kullanılır
    } else {
      // Hata durumunda Left ile bir Failure döndürülür
      return Future.value(Left(
          NullResponseFailure())); // Hata nesnesi olarak uygun bir Failure tipi döndürün
    }
  }

  @override
  Future<Either<Failure, void>> updateTrackingCoordinateBulk(
      {required int jobId, required List<Map<String, dynamic>> cordinates}) {
    if (jobId == 1) {
      // Başarılı durumda Right birim değeri döndürülür
      return Future.value(const Right(
          null)); // void türünde bir sonuç döndürmek için 'null' kullanılır
    } else {
      // Hata durumunda Left ile bir Failure döndürülür
      return Future.value(Left(
          NullResponseFailure())); // Hata nesnesi olarak uygun bir Failure tipi döndürün
    }
  }
}
