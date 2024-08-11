import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_abort_type_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_response_model_item.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/manager/network/core/product_service_path.dart';
import 'package:ferrisfwt/product/manager/network/manager/network_client.dart';
import 'package:ferrisfwt/product/mixin/handle_request_mixin.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';

abstract interface class JobInspectionsRemoteDataSource {
  Future<List<JobInspectionResponseModelItem>> getJobInspections({
    int? jobId,
    String? regNumber,
  });

  Future<List<JobInspectionAbortTypeItem>> getJobInspectionAbortTypes();

  Future<JobInspectionResponseModelItem> postDetails({
    required double odoReading,
    required int fuelLevel,
    required int inspectionId,
  });
}

class JobInspectionsRemoteDataSourceImpl
    with HandleRequestMixin
    implements JobInspectionsRemoteDataSource {
  JobInspectionsRemoteDataSourceImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  final NetworkClient _networkClient;

  final headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
  };

  @override
  Future<List<JobInspectionResponseModelItem>> getJobInspections({
    int? jobId,
    String? regNumber,
  }) async {
    try {
      final response = await _networkClient.get(
        ServicePath.jobInspections.value,
        queryParameters: {
          'jobId': jobId,
        },
        options: Options(headers: headers),
      );
      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }

      print("Access Token : ${response.data['newAccessToken']}");
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }

      final List<dynamic> productData = response.data["data"];

      return productData
          .map((e) => JobInspectionResponseModelItem.fromMap(e))
          .toList();
    } on DioException catch (e) {
      BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print('Error: $e, StackTrace: $stackTrace');
      throw UnknownException();
    }
  }

  @override
  Future<List<JobInspectionAbortTypeItem>> getJobInspectionAbortTypes() async {
    try {
      final response = await _networkClient.post(
        ServicePath.jobInspectionsAbortTypes.value,
        options: Options(headers: headers),
      );
      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }
      final List<dynamic> productData = response.data["data"];

      return productData
          .map((e) => JobInspectionAbortTypeItem.fromMap(e))
          .toList();
    } on DioException catch (e) {
      BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print('Error: $e, StackTrace: $stackTrace');
      throw UnknownException();
    }
  }

  @override
  Future<JobInspectionResponseModelItem> postDetails({
    required double odoReading,
    required int fuelLevel,
    required int inspectionId,
  }) async {
    try {
      final response = await _networkClient.post(
        "${ServicePath.jobInspectionsUpdate.value}/$inspectionId",
        data: {
          'odoReading': odoReading,
          'fuelLevel': fuelLevel,
        },
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
          'Authorization':
              'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
        }),
      );
      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }
      print(
          '******** inspection remote data source ********* ${response.data}');
      return JobInspectionResponseModelItem.fromMap(response.data);
    } on DioException catch (e) {
      BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print('Error: $e, StackTrace: $stackTrace');
      throw UnknownException();
    }
  }
}
