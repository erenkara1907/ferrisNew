import 'dart:convert';
import 'package:go_router/go_router.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/home/data/models/job_tracking_coordinates/tracking_coordinates_response_model_item.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/manager/network/core/product_service_path.dart';
import 'package:ferrisfwt/product/manager/network/manager/network_client.dart';
import 'package:ferrisfwt/product/mixin/handle_request_mixin.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';

import '../../../../../product/utility/error_handler/sentry_error_handler.dart';

abstract interface class JobTrackingCoordinatesRemoteDataSource {
  Future<List<TrackingCoordinatesResponseModelItem>>
      getJobTrackingCoordinatess({
    required int jobId,
  });

  Future<TrackingCoordinatesResponseModelItem> getTrackingCoordinate({
    required int id,
  });

  Future<void> updateTrackingCoordinate({
    required int jobId,
    required double latitude,
    required double longitude,
  });

  Future<void> updateTrackingCoordinateBulk({
    required int jobId,
    required List<Map<String, dynamic>> cordinates,
  });
}

final class JobTrackingCoordinatesRemoteDataSourceImpl
    with HandleRequestMixin
    implements JobTrackingCoordinatesRemoteDataSource {
  JobTrackingCoordinatesRemoteDataSourceImpl(
      {required NetworkClient networkClient})
      : _networkClient = networkClient;

  final NetworkClient _networkClient;

  @override
  Future<List<TrackingCoordinatesResponseModelItem>>
      getJobTrackingCoordinatess({
    required int jobId,
  }) async {
    try {
      final response = await _networkClient.get(
        "${ServicePath.jobTrackings.value}/$jobId",
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
        }),
      );
      if (response.data == null || response.data == null) {
        throw Exception('No data found');
      }
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }
      final List<dynamic> productData = response.data["data"];
      return productData
          .map((e) => TrackingCoordinatesResponseModelItem.fromMap(e))
          .toList();
    } on DioException catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      if (e.response?.data["message"] == "Not authenticated") {
        ProductStateItems.hiveDatabaseManager.deleteUserToken();
        ProductStateItems
            .appRouter.router.routerDelegate.navigatorKey.currentContext
            ?.go('/sign_in_page');
      }
      // BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      await SentryErrorHandler.instance.capture(e, stackTrace: stackTrace);
      throw UnknownException();
    }
  }

  @override
  Future<TrackingCoordinatesResponseModelItem> getTrackingCoordinate({
    required int id,
  }) async {
    try {
      final response = await _networkClient.get(
        "${ServicePath.jobTrackings.value}?jobId=$id",
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
        }),
      );

      if (response.data == null) {
        throw Exception('No data found');
      }
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }
      final productData = response.data["data"];
      return TrackingCoordinatesResponseModelItem.fromMap(productData);
    } on DioException catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);

      if (e.response?.data["message"] == "Not authenticated") {
        ProductStateItems.hiveDatabaseManager.deleteUserToken();
        ProductStateItems
            .appRouter.router.routerDelegate.navigatorKey.currentContext
            ?.go('/sign_in_page');
      }
      // BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      await SentryErrorHandler.instance.capture(e, stackTrace: stackTrace);
      throw UnknownException();
    }
  }

  @override
  Future<void> updateTrackingCoordinate({
    required int jobId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final data = {
        "jobId": jobId,
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
      };
      final response = await _networkClient.post(
        ServicePath.jobTrackings.value,
        data: jsonEncode(data),
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
        }),
      );
      if (response.data == null || response.data == null) {
        throw Exception('No data found');
      }
    } on DioException catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      if (e.response?.data["message"] == "Not authenticated") {
        ProductStateItems.hiveDatabaseManager.deleteUserToken();
        ProductStateItems
            .appRouter.router.routerDelegate.navigatorKey.currentContext
            ?.go('/sign_in_page');
      }
      // BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: "HATA VAR");
    } catch (e, stackTrace) {
      await SentryErrorHandler.instance.capture(e, stackTrace: stackTrace);
      throw UnknownException();
    }
  }

  @override
  Future<void> updateTrackingCoordinateBulk(
      {required int jobId,
      required List<Map<String, dynamic>> cordinates}) async {
    try {
      final data = {
        "jobId": jobId,
        "cordinates": cordinates,
      };

      final response = await _networkClient.post(
        ServicePath.jobTrackingsBulk.value,
        data: jsonEncode(data),
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
        }),
      );

      if (response.data == null || response.data == null) {
        throw Exception('No data found');
      }
    } on DioException catch (e, s) {
      await SentryErrorHandler.instance.capture(e.message, stackTrace: s);
      if (e.response?.data["message"] == "Not authenticated") {
        ProductStateItems.hiveDatabaseManager.deleteUserToken();
        ProductStateItems
            .appRouter.router.routerDelegate.navigatorKey.currentContext
            ?.go('/sign_in_page');
      }
      // BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: "HATA VAR");
    } catch (e, stackTrace) {
      await SentryErrorHandler.instance.capture(e, stackTrace: stackTrace);
      throw UnknownException();
    }
  }
}
