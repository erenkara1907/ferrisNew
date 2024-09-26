import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';

import 'package:ferrisfwt/feature/inspections/data/models/checklist/checklist_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/checklist/checklist_update_response_model.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/manager/network/core/product_service_path.dart';
import 'package:ferrisfwt/product/manager/network/manager/network_client.dart';
import 'package:ferrisfwt/product/mixin/handle_request_mixin.dart';

import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/checklist/inspection_checklist_post_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';

import '../../../../../product/utility/error_handler/sentry_error_handler.dart';

abstract interface class JobInspectionsCheckListRemoteDataSource {
  Future<List<ChecklistResponseModelItem>> getChecklists({
    required int? inspectionId,
  });

  Future<String> postChecklist({
    required InspectionChecklistPostModel data,
  });

  Future<ChecklistUpdateResponseModel> patchChecklist({
    required InspectionChecklistPostModel data,
    required int checklistId,
  });
}

class JobInspectionsCheckListRemoteDataSourceImpl
    with HandleRequestMixin
    implements JobInspectionsCheckListRemoteDataSource {
  JobInspectionsCheckListRemoteDataSourceImpl({required NetworkClient networkClient}) : _networkClient = networkClient;

  final NetworkClient _networkClient;

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
  };

  @override
  Future<List<ChecklistResponseModelItem>> getChecklists({
    required int? inspectionId,
  }) async {
    print("inspectionId: $inspectionId");
    try {
      final response = await _networkClient.get(
        "${ServicePath.jobInspectionsCheckList.value}?jobInspectionId=$inspectionId",
        queryParameters: {
          'inspectionId': inspectionId,
        },
        options: Options(headers: headers),
      );

      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }

      print("response.data: ${response.data}");

      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager.setToken(response.data['newAccessToken']);
      }

      final List<dynamic> productData = response.data["data"];

      return productData.map((e) => ChecklistResponseModelItem.fromMap(e)).toList();
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
  Future<String> postChecklist({
    required InspectionChecklistPostModel data,
  }) async {
    try {
      final response = await _networkClient.post(
        ServicePath.jobInspectionsCheckList.value,
        options: Options(headers: headers),
        data: data.toMap(),
      );

      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager.setToken(response.data['newAccessToken']);
      }
      return response.data['message'];
    } on DioException catch (e, s) {
      await SentryErrorHandler.instance.capture(e.response?.data['message'], stackTrace: s);
      BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.response?.data['message']);
    } catch (e, stackTrace) {
      await SentryErrorHandler.instance.capture(e, stackTrace: stackTrace);
      throw UnknownException();
    }
  }

  @override
  Future<ChecklistUpdateResponseModel> patchChecklist({
    required InspectionChecklistPostModel data,
    required int checklistId,
  }) async {
    print("checkListId: $checklistId");
    try {
      final response = await _networkClient.post(
        "${ServicePath.jobInspectionsCheckList.value}/$checklistId",
        options: Options(headers: headers),
        data: data.toMap(),
      );

      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }

      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager.setToken(response.data['newAccessToken']);
      }
      return ChecklistUpdateResponseModel.fromMap(response.data["data"]);
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
