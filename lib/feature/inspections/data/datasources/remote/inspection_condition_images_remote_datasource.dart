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

abstract interface class JobInspectionsConditionImagesRemoteDataSource {
  Future<ConditionImageResponseModel> postConditionImage({
    int? jobInspectionId,
    required InspectionConditionImagePostModel data,
  });

  Future<String> deleteConditionImage({
    required int imageId,
  });
}

class JobInspectionsConditionImagesRemoteDataSourceImpl
    with HandleRequestMixin
    implements JobInspectionsConditionImagesRemoteDataSource {
  JobInspectionsConditionImagesRemoteDataSourceImpl(
      {required NetworkClient networkClient})
      : _networkClient = networkClient;

  final NetworkClient _networkClient;

  final headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
  };

  @override
  Future<ConditionImageResponseModel> postConditionImage({
    int? jobInspectionId,
    required InspectionConditionImagePostModel data,
  }) async {
    try {
      final formData = FormData(); // Create a FormData instance
      formData.fields
          .add(MapEntry('jobInspectionId', jobInspectionId.toString()));

      final documentPath = (await getApplicationDocumentsDirectory()).path;
      int documentsIndex = data.image.path.indexOf("Documents/");
      String result =
          data.image.path.substring(documentsIndex + "Documents/".length);

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
          'Authorization':
              'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
        }),
        data: formData,
      );
      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }

      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }
      print('****** condition formadata ******* $formData');
      print('****** condition formadata files ******* ${formData.files}');
      return ConditionImageResponseModel.fromMap(response.data["data"]);
    } on DioException catch (e) {
      BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print('Error: $e, StackTrace: $stackTrace');
      throw UnknownException();
    }
  }

  @override
  Future<String> deleteConditionImage({
    required int imageId,
  }) async {
    try {
      final response = await _networkClient.delete(
        "${ServicePath.jobConditionImage.value}/$imageId",
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
}
