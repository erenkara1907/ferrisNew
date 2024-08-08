import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:ferrisfwt/feature/auth/data/models/login_response_model.dart';
import 'package:ferrisfwt/feature/auth/data/models/otp_response_model.dart';
import 'package:ferrisfwt/feature/auth/data/models/user_response_model.dart';
import 'package:ferrisfwt/feature/auth/domain/repositories/auth_repository.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final AuthRemoteDataSource _dataSource;
  @override
  Future<Either<Failure, LoginResponseModel>> login(
      {required String email, required String password}) async {
    try {
      final response =
          await _dataSource.login(email: email, password: password);
      return right(response);
    } on DioException {
      return left(NetworkFailure());
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, OtpResponseModel>> verifyOtp(
      {required int userId,
      required String token,
      required String code}) async {
    try {
      final response = await _dataSource.verifyOtp(
        userId: userId,
        token: token,
        code: code,
      );
      return right(response);
    } on DioException {
      return left(NetworkFailure());
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, String>> changePassword(
      {required String oldPassword, required String newPassword}) async {
    try {
      final response = await _dataSource.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return right(response);
    } on DioException {
      return left(NetworkFailure());
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, String>> logout({required String deviceToken}) async {
    try {
      final response = await _dataSource.logout(deviceToken: deviceToken);
      return right(response);
    } on DioException {
      return left(NetworkFailure());
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, String>> setDeviceId(
      {required String deviceId}) async {
    try {
      final response = await _dataSource.setDeviceId(deviceId: deviceId);
      return right(response);
    } on DioException {
      return left(NetworkFailure());
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, UserResponseModel>> getUserInfo() async {
    try {
      final response = await _dataSource.getUserInfo();
      return right(response);
    } on DioException {
      return left(NetworkFailure());
    } on NullResponseException {
      return left(NullResponseFailure());
    } catch (e) {
      return left(UnknownFailure());
    }
  }
}
