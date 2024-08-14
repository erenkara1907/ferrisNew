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
    print("GİRDİ 1");
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
    } on DioException catch (e) {
      if (e.response?.data["message"] == "Not authenticated") {
        ProductStateItems.hiveDatabaseManager.deleteUserToken();
        ProductStateItems
            .appRouter.router.routerDelegate.navigatorKey.currentContext
            ?.go('/sign_in_page');
      }
      BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print('Error: $e, StackTrace: $stackTrace');
      throw UnknownException();
    }
  }

  @override
  Future<TrackingCoordinatesResponseModelItem> getTrackingCoordinate({
    required int id,
  }) async {
    try {
      final response = await _networkClient.get(
        "${ServicePath.jobTrackings.value}/$id",
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
        }),
      );

      print("GET JOB : ${response.data['data']}");

      if (response.data == null || response.data == null) {
        throw Exception('No data found');
      }
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }
      final productData = response.data["data"];
      return TrackingCoordinatesResponseModelItem.fromMap(productData);
    } on DioException catch (e) {
      print("HATA : ${e.message}");
      print("DioException Detayları: ");
      print("Response Data: ${e.response?.data}");
      print("Response Data 2: ${e.response?.data["data"]}");
      print("Request Path: ${e.requestOptions.path}");
      print("Error Type: ${e.type}");
      print("Error: ${e.error}");
      if (e.response?.data["message"] == "Not authenticated") {
        ProductStateItems.hiveDatabaseManager.deleteUserToken();
        ProductStateItems
            .appRouter.router.routerDelegate.navigatorKey.currentContext
            ?.go('/sign_in_page');
      }
      // BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print('Error: $e, StackTrace: $stackTrace');
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
    } on DioException catch (e) {
      if (e.response?.data["message"] == "Not authenticated") {
        ProductStateItems.hiveDatabaseManager.deleteUserToken();
        ProductStateItems
            .appRouter.router.routerDelegate.navigatorKey.currentContext
            ?.go('/sign_in_page');
      }
      BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: "HATA VAR");
    } catch (e, stackTrace) {
      print('Error: $e, StackTrace: $stackTrace');
      throw UnknownException();
    }
  }
}
