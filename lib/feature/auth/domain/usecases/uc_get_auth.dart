import 'package:dartz/dartz.dart';
import 'package:ferrisfwt/feature/auth/data/models/login_response_model.dart';
import 'package:ferrisfwt/feature/auth/data/models/otp_response_model.dart';
import 'package:ferrisfwt/feature/auth/data/models/user_response_model.dart';
import 'package:ferrisfwt/feature/auth/domain/repositories/auth_repository.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';

final class UCGetAuth {
  UCGetAuth({required AuthRepository repository}) : _repository = repository;

  final AuthRepository _repository;

  Future<Either<Failure, LoginResponseModel>> login({
    required String email,
    required String password,
  }) {
    return _repository.login(
      email: email,
      password: password,
    );
  }

  Future<Either<Failure, OtpResponseModel>> verifyOtp({
    required int userId,
    required String token,
    required String code,
  }) {
    return _repository.verifyOtp(
      userId: userId,
      token: token,
      code: code,
    );
  }

  Future<Either<Failure, String>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) {
    return _repository.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  Future<Either<Failure, String>> logout({
    required String deviceToken,
  }) {
    return _repository.logout(
      deviceToken: deviceToken,
    );
  }

  Future<Either<Failure, String>> setDeviceId({
    required String deviceId,
  }) {
    return _repository.setDeviceId(
      deviceId: deviceId,
    );
  }

  Future<Either<Failure, UserResponseModel>> getUserInfo() {
    return _repository.getUserInfo();
  }
}
