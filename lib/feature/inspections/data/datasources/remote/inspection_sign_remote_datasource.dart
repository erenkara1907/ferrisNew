import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/manager/network/core/product_service_path.dart';
import 'package:ferrisfwt/product/manager/network/manager/network_client.dart';
import 'package:ferrisfwt/product/mixin/handle_request_mixin.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_customer_sign_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_inspector_sign_post_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';

abstract interface class JobInspectionsSignRemoteDataSource {
  Future<String> postCustomerSign({
    required int inspectionId,
    required InspectionCustomerSignPostModel data,
  });

  Future<String> postInspectorSign({
    required int inspectionId,
    required InspectionInspectorSignPostModel data,
  });

  Future<String> patchCustomerSign({
    required InspectionCustomerSignPostModel data,
  });

  Future<String> patchInspectorSign({
    required InspectionInspectorSignPostModel data,
  });
}

class JobInspectionsSignRemoteDataSourceImpl
    with HandleRequestMixin
    implements JobInspectionsSignRemoteDataSource {
  JobInspectionsSignRemoteDataSourceImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  final NetworkClient _networkClient;

  final headers = {
    'Accept': 'application/json',
    'Content-Type': 'multipart/form-data',
    'Authorization':
        'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
  };

  @override
  Future<String> postCustomerSign({
    required int inspectionId,
    required InspectionCustomerSignPostModel data,
  }) async {
    try {
      final response = await _networkClient.post(
        "${ServicePath.jobInspectionsCustomerSign.value}/$inspectionId",
        data: FormData.fromMap(data.toMap(), ListFormat.multiCompatible),
        options: Options(headers: headers),
      );
      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }
      return response.data['message'];
    } on DioException catch (e) {
      BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print('Error: $e, StackTrace: $stackTrace');
      throw UnknownException();
    }
  }

  @override
  Future<String> postInspectorSign({
    required int inspectionId,
    required InspectionInspectorSignPostModel data,
  }) async {
    try {
      final response = await _networkClient.post(
        "${ServicePath.jobInspectionsInspectorSign.value}/$inspectionId",
        data: FormData.fromMap(data.toMap(), ListFormat.multiCompatible),
        options: Options(headers: headers),
      );
      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }
      print('******* sign response data: ${response.data}');
      return response.data['message'];
    } on DioException catch (e) {
      BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print('Error: $e, StackTrace: $stackTrace');
      throw UnknownException();
    }
  }

  @override
  Future<String> patchCustomerSign({
    required InspectionCustomerSignPostModel data,
  }) async {
    try {
      final response = await _networkClient.patch(
        "${ServicePath.jobInspectionsCustomerSign.value}",
        data: data,
        options: Options(headers: {'Accept': 'application/json'}),
      );
      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }
      return response.data['message'];
    } on DioException catch (e) {
      BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print('Error: $e, StackTrace: $stackTrace');
      throw UnknownException();
    }
  }

  @override
  Future<String> patchInspectorSign({
    required InspectionInspectorSignPostModel data,
  }) async {
    try {
      final response = await _networkClient.patch(
        "${ServicePath.jobInspectionsInspectorSign.value}",
        data: data,
        options: Options(headers: {'Accept': 'application/json'}),
      );
      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }
      return response.data['message'];
    } on DioException catch (e) {
      BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print('Error: $e, StackTrace: $stackTrace');
      throw UnknownException();
    }
  }
}
