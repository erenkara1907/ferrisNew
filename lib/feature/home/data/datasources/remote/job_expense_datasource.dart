import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expense_categories_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expense_patch_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expenses_response_model_item.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/manager/network/core/product_service_path.dart';
import 'package:ferrisfwt/product/manager/network/manager/network_client.dart';
import 'package:ferrisfwt/product/mixin/handle_request_mixin.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_post_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

abstract interface class JobExpenseRemoteDataSource {
  Future<List<ExpensesResponseModelItem>> jobExpenses({
    required int jobId,
  });

  Future<ExpensesResponseModelItem> postExpense({
    required ExpensePostModel data,
  });
  Future<ExpensePatchResponseModel> patchExpense({
    required ExpensePatchModel data,
  });

  Future<List<ExpenseCategoriesResponseModelItem>> getExpenseCategories();
}

final class JobExpenseRemoteDataSourceImpl
    with HandleRequestMixin
    implements JobExpenseRemoteDataSource {
  JobExpenseRemoteDataSourceImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  final NetworkClient _networkClient;

  @override
  Future<List<ExpensesResponseModelItem>> jobExpenses({
    required int jobId,
  }) async {
    try {
      final response = await _networkClient.get(
        "${ServicePath.jobExpenses.value}?jobId=$jobId",
        options: Options(headers: {
          'Accept': 'application/json',
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
      print('productData1: $productData');
      return productData
          .map((e) => ExpensesResponseModelItem.fromMap(e))
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
  Future<ExpensesResponseModelItem> postExpense({
    required ExpensePostModel data,
  }) async {
    try {
      final formData = FormData(); // Create a FormData instance
      formData.fields.add(MapEntry('categoryId', data.categoryId.toString()));
      formData.fields.add(MapEntry('price', data.price.toString()));
      formData.fields.add(MapEntry('jobId', data.jobId.toString()));
      data.reasonNoReceipt != null
          ? formData.fields
              .add(MapEntry('reasonNoReceipt', data.reasonNoReceipt!))
          : null;
      if (data.receipt != null) {
        final documentPath = (await getApplicationDocumentsDirectory()).path;
        int documentsIndex = data.receipt!.path.indexOf("Documents/");
        String result =
            data.receipt!.path.substring(documentsIndex + "Documents/".length);

        final path = '$documentPath/$result';
        formData.files.add(MapEntry(
          'receipt',
          MultipartFile.fromFileSync(path),
        ));
      }
      final response = await _networkClient.post(
        ServicePath.jobExpenses.value,
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
      return ExpensesResponseModelItem.fromMap(response.data["data"]);
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
  Future<ExpensePatchResponseModel> patchExpense({
    required ExpensePatchModel data,
  }) async {
    try {
      final formData = FormData(); // Create a FormData instance
      formData.fields.add(MapEntry('categoryId', data.categoryId.toString()));
      formData.fields.add(MapEntry('price', data.price.toString()));
      data.reasonNoReceipt != null
          ? formData.fields
              .add(MapEntry('reasonNoReceipt', data.reasonNoReceipt!))
          : null;
      if (data.receipt != null) {
        final documentPath = (await getApplicationDocumentsDirectory()).path;
        int documentsIndex = data.receipt!.path.indexOf("Documents/");
        String result =
            data.receipt!.path.substring(documentsIndex + "Documents/".length);

        final path = '$documentPath/$result';
        formData.files.add(MapEntry(
          'receipt',
          MultipartFile.fromFileSync(path),
        ));
      }

      final response = await _networkClient.post(
        "${ServicePath.jobExpenses.value}/${data.expenseId}",
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
      return ExpensePatchResponseModel.fromMap(response.data["data"]);
    } on DioException catch (e) {
      if (e.response?.data["message"] == "Not authenticated") {
        ProductStateItems.hiveDatabaseManager.deleteUserToken();
        ProductStateItems
            .appRouter.router.routerDelegate.navigatorKey.currentContext
            ?.go('/sign_in_page');
      }
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print('Error: $e, StackTrace: $stackTrace');
      throw UnknownException();
    }
  }

  @override
  Future<List<ExpenseCategoriesResponseModelItem>>
      getExpenseCategories() async {
    try {
      final response = await _networkClient.get(
        ServicePath.jobExpenseCategories.value,
        options: Options(headers: {
          'Content-Type': 'application/json',
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
      final List<dynamic> productData = response.data["data"];
      return productData
          .map((e) => ExpenseCategoriesResponseModelItem.fromMap(e))
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
}
