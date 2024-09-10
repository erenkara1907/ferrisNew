import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_assets/damage_assets_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_categories/damage_category.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_combination/damage_combination_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_failures/damage_failure.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_issues/damage_issue.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_parts/damage_part.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_repairs/damage_repair.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade/grade_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade_rule/grade_rule_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/grade_rule_uplift/grade_rule_uplift_model.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/manager/network/core/product_service_path.dart';
import 'package:ferrisfwt/product/manager/network/manager/network_client.dart';
import 'package:ferrisfwt/product/mixin/handle_request_mixin.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../../product/utility/error_handler/sentry_error_handler.dart';

abstract interface class JobDamageRemoteDataSource {
  // Future<List<DamagesCategory>> getDamageCategories(
  //     {required int inspectionId});

  // Future<List<DamagesFailure>> getDamageFailures(
  //     {required int inspectionId, required int issueId});

  // Future<List<DamagesIssue>> getDamageIssues(
  //     {required int inspectionId, required int partId});

  // Future<List<DamagesPart>> getDamageParts(
  //     {required int inspectionId, required int categoryId});

  // Future<List<DamagesRepair>> getDamageRepairs(
  //     {required int inspectionId, required int failureId});

  Future<List<DamageAssetsModel>> getAllDamageAssets();

  Future<List<DamageCombinationModel>> getAllDamageCombination();
  Future<List<GradeModel>> getAllGrade();
  Future<List<GradeRuleModel>> getAllGradeRule();
  Future<List<GradeRuleUpliftModel>> getAllGradeRuleUplift();
}

final class JobDamageRemoteDataSourceImpl
    with HandleRequestMixin
    implements JobDamageRemoteDataSource {
  JobDamageRemoteDataSourceImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  final NetworkClient _networkClient;

  @override
  Future<List<DamageAssetsModel>> getAllDamageAssets() async {
    try {
      final response = await _networkClient.get(
        ServicePath.getAllDamageAssets.value,
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

      return productData.map((e) => DamageAssetsModel.fromJson(e)).toList();
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
  Future<List<DamageCombinationModel>> getAllDamageCombination() async {
    try {
      final response = await _networkClient.get(
        ServicePath.getAllDamageCombination.value,
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

      return productData.map((e) => DamageCombinationModel.fromMap(e)).toList();
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
  Future<List<GradeModel>> getAllGrade() async {
    try {
      final response = await _networkClient.get(
        ServicePath.getAllGrade.value,
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

      return productData.map((e) => GradeModel.fromMap(e)).toList();
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
  Future<List<GradeRuleModel>> getAllGradeRule() async {
    try {
      final response = await _networkClient.get(
        ServicePath.getAllGradeRule.value,
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

      return productData.map((e) => GradeRuleModel.fromMap(e)).toList();
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
  Future<List<GradeRuleUpliftModel>> getAllGradeRuleUplift() async {
    try {
      final response = await _networkClient.get(
        ServicePath.getAllGradeRuleUplift.value,
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

      return productData.map((e) => GradeRuleUpliftModel.fromMap(e)).toList();
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
