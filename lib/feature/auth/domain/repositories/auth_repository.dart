import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/auth/data/models/login_response_model.dart';
import 'package:ferrisfwt/feature/auth/data/models/otp_response_model.dart';
import 'package:ferrisfwt/feature/auth/data/models/user_response_model.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, LoginResponseModel>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, OtpResponseModel>> verifyOtp({
    required int userId,
    required String token,
    required String code,
  });

  Future<Either<Failure, String>> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<Either<Failure, String>> logout({
    required String deviceToken,
  });

  Future<Either<Failure, String>> setDeviceId({
    required String deviceId,
  });

  Future<Either<Failure, UserResponseModel>> getUserInfo();
}
