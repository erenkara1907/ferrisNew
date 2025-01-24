// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_update_response_model.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/manager/network/index.dart';
import 'package:ferrisfwt/product/mixin/handle_request_mixin.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_post_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../../../../product/utility/error_handler/sentry_error_handler.dart';

abstract interface class JobInspectionsDamagesRemoteDataSource {
  Future<DamageResponseModel> postDamage({
    required InspectionDamagePostModel data,
  });

  Future<List<DamageResponseModel>> getDamages({
    required int jobInspectionId,
  });

  Future<DamageUpdateResponseModel> patchDamage({
    required int damageId,
    required InspectionDamagePatchModel data,
  });

  Future<void> deleteRecordedDamage({
    required int damageId,
  });
}

class JobInspectionsDamagesRemoteDataSourceImpl
    with HandleRequestMixin
    implements JobInspectionsDamagesRemoteDataSource {
  JobInspectionsDamagesRemoteDataSourceImpl({required Dio networkClient}) : _networkClient = networkClient;

  final Dio _networkClient;

  final headers = {
    'Accept': 'application/json',
    'Content-Type': 'multipart/form-data',
    'Authorization': 'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
  };

  @override
  Future<DamageResponseModel> postDamage({
    required InspectionDamagePostModel data,
  }) async {
    print("will post damage with data: $data");
    print("damage image path: ${data.damageImage?.path}");
    print("context image path: ${data.contextImage?.path}");
    try {
      final formData = FormData(); // Create a FormData instance
      formData.fields.add(MapEntry('jobInspectionId', data.jobInspectionId.toString()));
      formData.fields.add(MapEntry('categoryId', data.categoryId.toString()));
      formData.fields.add(MapEntry('partId', data.partId.toString()));
      formData.fields.add(MapEntry('issueId', data.issueId.toString()));
      formData.fields.add(MapEntry('failureId', data.failureId.toString()));
      formData.fields.add(MapEntry('repairId', data.repairId.toString()));

      final documentPath = (await getApplicationDocumentsDirectory()).path;
      int documentsIndex = data.contextImage!.path.indexOf("Documents/");
      String result = data.contextImage!.path.substring(documentsIndex + "Documents/".length);

      // final _path = '$documentPath/$result';
      final _path = data.contextImage!.path;

      formData.files.add(MapEntry(
        'contextImage',
        MultipartFile.fromFileSync(_path),
      ));

      if (data.damageImage != null) {
        int documentsIndex = data.damageImage!.path.indexOf("Documents/");
        String result = data.damageImage!.path.substring(documentsIndex + "Documents/".length);

        // final path = '$documentPath/$result';
        final path = data.damageImage!.path;
        formData.files.add(MapEntry(
          'damageImage',
          MultipartFile.fromFileSync(path),
        ));
      }

      final response = await _networkClient.post(
        "https://fwtsolutions.co.uk/api/v1/damages",
        options: Options(headers: headers),
        data: formData,
      );

      if (response.data == null) {
        throw NullResponseException();
      }

      print("response: ${response.data}");

      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager.setToken(response.data['newAccessToken']);
      }

      return DamageResponseModel.fromMap(response.data["data"]);
    } on DioException catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      // BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print("Caught an unknown error: $e");
      print("Stack trace: $stackTrace");
      await SentryErrorHandler.instance.capture(e, stackTrace: stackTrace);
      throw UnknownException('An unknown error occurred: $e');
    }
  }

  @override
  Future<List<DamageResponseModel>> getDamages({
    required int jobInspectionId,
  }) async {
    try {
      final response = await _networkClient.get(
        "https://fwtsolutions.co.uk/api/v1/damages",
        options: Options(headers: headers),
        queryParameters: {
          'jobInspectionId': jobInspectionId.toString(),
        },
      );

      if (response.data == null) {
        throw NullResponseException();
      }

      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager.setToken(response.data['newAccessToken']);
      }

      // List<DamageResponseModel> responseList = [];
      // for (var item in response.data["data"]) {
      //   responseList.add(DamageResponseModel.fromMap(item));
      // }

      // return responseList;

      final List<dynamic> productData = response.data["data"];

      return productData.map((e) => DamageResponseModel.fromMap(e)).toList();
    } on DioException catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      // BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      await SentryErrorHandler.instance.capture(e, stackTrace: stackTrace);
      throw UnknownException();
    }
  }

  @override
  Future<void> deleteRecordedDamage({
    required int damageId,
  }) async {
    print("will delete damage with id: $damageId");
    try {
      final response = await http.delete(
        Uri.parse("https://fwtsolutions.co.uk/api/v1/damages/$damageId"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
        },
      );
      // final response = await http.delete(
      //   "${ServicePath.damageDelete.value}/$damageId",
      //   options: Options(headers: headers),
      // );

      final responseData = jsonDecode(response.body);

      if (responseData == null || responseData == null) {
        throw NullResponseException();
      }

      if (responseData['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager.setToken(responseData['newAccessToken']);
      }

      print("deleted image : $responseData");

      return;
    } on DioException catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      // BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      await SentryErrorHandler.instance.capture(e, stackTrace: stackTrace);
      throw UnknownException();
    }
  }

  @override
  Future<DamageUpdateResponseModel> patchDamage({
    required int damageId,
    required InspectionDamagePatchModel data,
  }) async {
    try {
      final response = await _networkClient.post("${ServicePath.jobInspectionsDamages.value}/$damageId",
          options: Options(headers: headers), data: FormData.fromMap(data.toMap(), ListFormat.multiCompatible));
      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager.setToken(response.data['newAccessToken']);
      }
      return DamageUpdateResponseModel.fromMap(response.data);
    } on DioException catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      // BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      await SentryErrorHandler.instance.capture(e, stackTrace: stackTrace);
      throw UnknownException();
    }
  }
}
