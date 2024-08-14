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

abstract interface class JobInspectionsDamagesRemoteDataSource {
  Future<DamageResponseModel> postDamage({
    required InspectionDamagePostModel data,
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
  JobInspectionsDamagesRemoteDataSourceImpl({required Dio networkClient})
      : _networkClient = networkClient;

  final Dio _networkClient;

  final headers = {
    'Accept': 'application/json',
    'Content-Type': 'multipart/form-data',
    'Authorization':
        'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
  };

  @override
  Future<DamageResponseModel> postDamage({
    required InspectionDamagePostModel data,
  }) async {
    try {
      final formData = FormData(); // Create a FormData instance
      formData.fields
          .add(MapEntry('jobInspectionId', data.jobInspectionId.toString()));
      formData.fields.add(MapEntry('categoryId', data.categoryId.toString()));
      formData.fields.add(MapEntry('partId', data.partId.toString()));
      formData.fields.add(MapEntry('issueId', data.issueId.toString()));
      formData.fields.add(MapEntry('failureId', data.failureId.toString()));
      formData.fields.add(MapEntry('repairId', data.repairId.toString()));

      final documentPath = (await getApplicationDocumentsDirectory()).path;
      int documentsIndex = data.contextImage!.path.indexOf("Documents/");
      String result = data.contextImage!.path
          .substring(documentsIndex + "Documents/".length);

      final _path = '$documentPath/$result';

      formData.files.add(MapEntry(
        'contextImage',
        MultipartFile.fromFileSync(_path),
      ));

      if (data.damageImage != null) {
        int documentsIndex = data.damageImage!.path.indexOf("Documents/");
        String result = data.damageImage!.path
            .substring(documentsIndex + "Documents/".length);

        final path = '$documentPath/$result';
        formData.files.add(MapEntry(
          'damageImage',
          MultipartFile.fromFileSync(path),
        ));
      }

      final response = await _networkClient.post(
        "https://dev.fwtsolutions.co.uk/api/v1/damages",
        options: Options(headers: headers),
        data: formData,
      );

      print(
          "POST DATA ITEM : ${response.data["data"]['jobInspectionId']['gradeId']}");

      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }

      return DamageResponseModel.fromMap(response.data["data"]);
    } on DioException catch (e) {
      print("HATA : ${e.message}");
      print("DioException Detayları: ");
      print("Response Data: ${e.response?.data}");
      print("Response Data 2: ${e.response?.data["data"]}");
      print("Request Path: ${e.requestOptions.path}");
      print("Error Type: ${e.type}");
      print("Error: ${e.error}");
      BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print('Error: $e, StackTrace: $stackTrace');
      throw UnknownException();
    }
  }

  @override
  Future<void> deleteRecordedDamage({
    required int damageId,
  }) async {
    try {
      final response = await _networkClient.delete(
        "${ServicePath.damageDelete.value}/$damageId",
        options: Options(headers: headers),
      );

      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }

      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }

      // Veri dönüşümünü burada yaparak, modelinizin doğru şekilde oluşturulduğundan emin olun.
      return;
    } on DioException catch (e) {
      BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print('Error: $e, StackTrace: $stackTrace');
      throw UnknownException();
    }
  }

  @override
  Future<DamageUpdateResponseModel> patchDamage({
    required int damageId,
    required InspectionDamagePatchModel data,
  }) async {
    try {
      final response = await _networkClient.post(
          "${ServicePath.jobInspectionsDamages.value}/$damageId",
          options: Options(headers: headers),
          data: FormData.fromMap(data.toMap(), ListFormat.multiCompatible));
      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }
      return DamageUpdateResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print('Error: $e, StackTrace: $stackTrace');
      throw UnknownException();
    }
  }
}
