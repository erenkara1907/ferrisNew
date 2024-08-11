import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_categories/damage_category.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_failures/damage_failure.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_issues/damage_issue.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_parts/damage_part.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_repairs/damage_repair.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/manager/network/core/product_service_path.dart';
import 'package:ferrisfwt/product/manager/network/manager/network_client.dart';
import 'package:ferrisfwt/product/mixin/handle_request_mixin.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:go_router/go_router.dart';

abstract interface class JobDamageRemoteDataSource {
  Future<List<DamagesCategory>> getDamageCategories(
      {required int inspectionId});

  Future<List<DamagesFailure>> getDamageFailures(
      {required int inspectionId, required int issueId});

  Future<List<DamagesIssue>> getDamageIssues(
      {required int inspectionId, required int partId});

  Future<List<DamagesPart>> getDamageParts(
      {required int inspectionId, required int categoryId});

  Future<List<DamagesRepair>> getDamageRepairs(
      {required int inspectionId, required int failureId});
}

final class JobDamageRemoteDataSourceImpl
    with HandleRequestMixin
    implements JobDamageRemoteDataSource {
  JobDamageRemoteDataSourceImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  final NetworkClient _networkClient;

  @override
  Future<List<DamagesCategory>> getDamageCategories(
      {required int inspectionId}) async {
    print("SERVICE : $inspectionId");
    try {
      final response = await _networkClient.get(
        "${ServicePath.damageCategories.value}/$inspectionId",
        // ServicePath.damageCategories.value,
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

      print("SERVICE DATA ${response.data["data"]}");
      final List<dynamic> productData = response.data["data"];

      return productData.map((e) => DamagesCategory.fromMap(e)).toList();
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
  Future<List<DamagesFailure>> getDamageFailures(
      {required int inspectionId, required int issueId}) async {
    try {
      final response = await _networkClient.get(
        "${ServicePath.damageFailures.value}/$inspectionId?issueId=$issueId",
        // ServicePath.damageFailures.value,
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
      return productData.map((e) => DamagesFailure.fromMap(e)).toList();
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
  Future<List<DamagesIssue>> getDamageIssues(
      {required int inspectionId, required int partId}) async {
    try {
      final response = await _networkClient.get(
        "${ServicePath.damageIssues.value}/$inspectionId?partId=$partId",
        // ServicePath.damageIssues.value,
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
      return productData.map((e) => DamagesIssue.fromMap(e)).toList();
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
  Future<List<DamagesPart>> getDamageParts(
      {required int inspectionId, required int categoryId}) async {
    print("SERVICE PART : $inspectionId");
    try {
      final response = await _networkClient.get(
        "${ServicePath.damageParts.value}/$inspectionId?categoryId=$categoryId",
        // ServicePath.damageParts.value,
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
      return productData.map((e) => DamagesPart.fromMap(e)).toList();
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
  Future<List<DamagesRepair>> getDamageRepairs(
      {required int inspectionId, required int failureId}) async {
    try {
      final response = await _networkClient.get(
        "${ServicePath.damageRepairs.value}/$inspectionId?failureId=$failureId",
        // ServicePath.damageRepairs.value,
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
      return productData.map((e) => DamagesRepair.fromMap(e)).toList();
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
