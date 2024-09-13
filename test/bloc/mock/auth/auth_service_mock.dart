import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/auth/data/models/login_response_model.dart';
import 'package:ferrisfwt/feature/auth/data/models/otp_response_model.dart';
import 'package:ferrisfwt/feature/auth/data/models/user_response_model.dart';
import 'package:ferrisfwt/feature/auth/domain/usecases/uc_get_auth.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:mockito/mockito.dart';

final class AuthServiceMock extends Mock implements UCGetAuth {
  @override
  Future<Either<Failure, LoginResponseModel>> login(
      {required String email, required String password}) {
    if (email == "test@gmail.com" && password == "123") {
      // Başarılı login yanıtı
      final loginResponse = LoginResponseModel(token: 'mockToken', userId: 1);
      return Future.value(Right(loginResponse)); // Future ile asenkron döndürme
    } else {
      // Başarısız login durumu
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, String>> logout({required String deviceToken}) {
    if (deviceToken == "testDeviceToken") {
      // Başarılı login yanıtı
      return Future.value(const Right("OKAY")); // Future ile asenkron döndürme
    } else {
      // Başarısız login durumu
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, OtpResponseModel>> verifyOtp(
      {required int userId, required String token, required String code}) {
    if (userId == 1 && token == "testToken" && code == "testCode") {
      // Başarılı login yanıtı
      return Future.value(Right(OtpResponseModel(
          accessToken: "testAccessToken"))); // Future ile asenkron döndürme
    } else {
      // Başarısız login durumu
      return Future.value(Left(NullResponseFailure()));
    }
  }

  @override
  Future<Either<Failure, UserResponseModel>> getUserInfo() {
    return Future.value(const Right(UserResponseModel(id: 1)));
  }
}
