import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/inspections/data/models/condition_image/condition_image_response_model.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/manager/network/index.dart';
import 'package:ferrisfwt/product/manager/network/manager/network_client.dart';
import 'package:ferrisfwt/product/mixin/handle_request_mixin.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/condition_image/inspection_condition_image_post_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../product/utility/error_handler/sentry_error_handler.dart';
import 'package:http/http.dart' as http;

abstract interface class JobInspectionsConditionImagesRemoteDataSource {
  Future<ConditionImageResponseModel> postConditionImage({
    int? jobInspectionId,
    required ConditionImageResponseModel data,
  });

  Future<String> deleteConditionImage({
    required int imageId,
  });
}

class JobInspectionsConditionImagesRemoteDataSourceImpl
    with HandleRequestMixin
    implements JobInspectionsConditionImagesRemoteDataSource {
  JobInspectionsConditionImagesRemoteDataSourceImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  final NetworkClient _networkClient;

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
  };

  @override
  Future<ConditionImageResponseModel> postConditionImage({
    int? jobInspectionId,
    required ConditionImageResponseModel data,
  }) async {
    try {
      final formData = FormData(); // Create a FormData instance
      formData.fields.add(MapEntry('jobInspectionId', jobInspectionId.toString()));

      final documentPath = (await getApplicationDocumentsDirectory()).path;
      int documentsIndex = data.imageFile!.path.indexOf("Documents/");
      String result = data.imageFile!.path.substring(documentsIndex + "Documents/".length);

      final path = '$documentPath/$result';
      formData.files.add(MapEntry(
        'image',
        MultipartFile.fromFileSync(path),
      ));

      final response = await _networkClient.post(
        ServicePath.jobConditionImage.value,
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
        }),
        data: formData,
      );
      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }

      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager.setToken(response.data['newAccessToken']);
      }

      return ConditionImageResponseModel.fromMap(response.data["data"]);
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
  Future<String> deleteConditionImage({
    required int imageId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse("https://staging.fwtsolutions.co.uk/api/v1/job-inspection-condition-images/$imageId"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
        },
      );
      // final response = await _networkClient.delete(
      //   "${ServicePath.jobConditionImage.value}/$imageId",
      //   options: Options(headers: headers),
      // );

      final responseData = jsonDecode(response.body);

      if (responseData == null || responseData == null) {
        throw NullResponseException();
      }
      if (responseData['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager.setToken(responseData['newAccessToken']);
      }
      return responseData['message'];
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
