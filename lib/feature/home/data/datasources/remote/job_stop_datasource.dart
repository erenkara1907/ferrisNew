import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/home/data/models/job_stop/stop_categories_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/job_stop/stops_response_model_item.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/manager/network/core/product_service_path.dart';
import 'package:ferrisfwt/product/manager/network/manager/network_client.dart';
import 'package:ferrisfwt/product/mixin/handle_request_mixin.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/stops/stop_post_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../product/utility/error_handler/sentry_error_handler.dart';

abstract interface class JobStopRemoteDataSource {
  Future<List<StopsResponseModelItem>> getJobStops({
    required int jobId,
  });

  Future<StopsResponseModelItem> postJobStops({
    required int jobId,
    required StopPostModel data,
  });
  Future<List<StopCategoriesResponseModelItem>> getStopCategories();
}

final class JobStopRemoteDataSourceImpl
    with HandleRequestMixin
    implements JobStopRemoteDataSource {
  JobStopRemoteDataSourceImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  final NetworkClient _networkClient;

  @override
  Future<List<StopsResponseModelItem>> getJobStops({
    required int jobId,
  }) async {
    try {
      final response = await _networkClient.get(
        ServicePath.jobStops.value,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
        }),
        queryParameters: {
          'job_id': jobId,
        },
      );
      if (response.data == null || response.data == null) {
        throw Exception('No data found');
      }
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }
      final List<dynamic> productData = response.data["data"];
      return productData.map((e) => StopsResponseModelItem.fromMap(e)).toList();
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
  Future<StopsResponseModelItem> postJobStops({
    required int jobId,
    required StopPostModel data,
  }) async {
    try {
      final formData = FormData(); // Create a FormData instance
      formData.fields.add(MapEntry('categoryId', data.categoryId.toString()));
      formData.fields.add(MapEntry('latitude', data.latitude.toString()));
      formData.fields.add(MapEntry('longitude', data.longitude.toString()));
      // formData.fields.add(MapEntry('reason', data.jobId.toString()));
      formData.fields.add(MapEntry('jobId', data.jobId.toString()));
      final documentPath = (await getApplicationDocumentsDirectory()).path;
      // for (var evidence in data.evidences) {
      //   int documentsIndex = evidence.path.indexOf("Documents/");
      //   String result =
      //       evidence.path.substring(documentsIndex + "Documents/".length);

      //   final path = '$documentPath/$result';
      //   formData.files.add(MapEntry(
      //     'evidences[]',
      //     MultipartFile.fromFileSync(path),
      //   ));
      // }

      // Verilen kodda tek bir dosyayı 'evidence' key ile API'ye gönderme
      if (data.evidences.isNotEmpty) {
        // Listenin ilk elemanını al
        var evidence = data.evidences.first;

        // Dosyanın yolunu al
        int documentsIndex = evidence.path.indexOf("Documents/");
        String result =
            evidence.path.substring(documentsIndex + "Documents/".length);

        final path = '$documentPath/$result';

        // Dosyayı 'evidence' key ile formData'ya ekle
        formData.files.add(MapEntry(
          'evidence',
          MultipartFile.fromFileSync(path),
        ));
      }

      final response = await _networkClient.post(
        ServicePath.jobStops.value,
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
          'Authorization':
              'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
        }),
        data: formData,
      );
      if (response.data == null || response.data == null) {
        throw Exception('No data found');
      }
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }

      print("DATA STOP : ${response.data["data"]}");
      return StopsResponseModelItem.fromMap(response.data["data"]);
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
  Future<List<StopCategoriesResponseModelItem>> getStopCategories() async {
    try {
      final response = await _networkClient.get(
        ServicePath.jobsStopCategories.value,
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
          .map((e) => StopCategoriesResponseModelItem.fromMap(e))
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
}
