import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/auth/data/models/login_response_model.dart';
import 'package:ferrisfwt/feature/auth/data/models/otp_response_model.dart';
import 'package:ferrisfwt/feature/auth/data/models/user_response_model.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/manager/network/core/product_service_path.dart';
import 'package:ferrisfwt/product/manager/network/manager/network_client.dart';
import 'package:ferrisfwt/product/mixin/handle_request_mixin.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';

import '../../../../../product/utility/error_handler/sentry_error_handler.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  Future<OtpResponseModel> verifyOtp({
    required int userId,
    required String token,
    required String code,
  });

  Future<String> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<UserResponseModel> getUserInfo();

  Future<String> logout({
    required String deviceToken,
  });

  Future<String> setDeviceId({
    required String deviceId,
  });
}

class AuthRemoteDataSourceImpl
    with HandleRequestMixin
    implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  final NetworkClient _networkClient;

  final headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
  };

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _networkClient.post(
        ServicePath.login.value,
        queryParameters: {
          "email": email,
          "password": password,
        },
        options: Options(
          headers: {'Accept': 'application/json'},
        ),
      );
      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }

      final data = response.data['data'] as Map<String, dynamic>;

      return LoginResponseModel.fromJson(data);
    } on DioException catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      await SentryErrorHandler.instance.capture(e, stackTrace: stackTrace);
      throw UnknownException();
    }
  }

  @override
  Future<OtpResponseModel> verifyOtp({
    required int userId,
    required String token,
    required String code,
  }) async {
    final data = {
      'userId': userId,
      'token': token,
      'code': code,
    };
    return handleRequest<OtpResponseModel>(
      _networkClient.post(ServicePath.verifyOtp.value,
          data: data,
          options: Options(headers: {
            'Content-Type': 'application/json',
          })),
      OtpResponseModel.fromJson,
      manipulateData: (p0) => p0['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<String> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final data = {
      'password': oldPassword,
      'password_confirmation': newPassword,
      'token': ProductStateItems.hiveDatabaseManager.getUserModel()?.token,
    };
    return handleRequest<String>(
      _networkClient.post(ServicePath.changePassword.value,
          data: data,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
          })),
      (json) => json['message'],
    );
  }

  @override
  Future<UserResponseModel> getUserInfo() async {
    return handleRequest<UserResponseModel>(
      _networkClient.post(ServicePath.getUser.value,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
          })),
      UserResponseModel.fromJson,
      manipulateData: (p0) => p0['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<String> logout({
    required String deviceToken,
  }) async {
    final data = {
      'deviceToken': deviceToken,
    };
    return handleRequest<String>(
      _networkClient.post(ServicePath.logout.value,
          data: data,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
          })),
      (json) => json['message'],
    );
  }

  @override
  Future<String> setDeviceId({
    required String deviceId,
  }) async {
    final data = {
      'deviceToken': deviceId,
    };
    return handleRequest<String>(
      _networkClient.post(ServicePath.setDeviceToken.value,
          data: data,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
          })),
      (json) => json['message'],
    );
  }
}
