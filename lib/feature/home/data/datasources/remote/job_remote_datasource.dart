import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/movement_type/feedback_input_availability.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/valet_standard/valet_standard_response_model_item.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:ferrisfwt/product/manager/network/core/product_service_path.dart';
import 'package:ferrisfwt/product/manager/network/manager/network_client.dart';
import 'package:ferrisfwt/product/mixin/handle_request_mixin.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/end_job_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/start_job_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/update_job_status_post_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract interface class JobRemoteDataSource {
  Future<List<JobsResponseModelItem>> getJob({
    String? date,
    String? status,
  });

  Future<JobsResponseModelItem> getJobShow({
    required String id,
  });
  Future<String> startJob({
    required StartJobPostModel data,
    required int jobId,
  });

  Future<String> endJob({
    required int jobId,
    required EndJobPostModel data,
  });

  Future<String> updateJob({
    required int jobId,
    required UpdateJobStatusPostModel updateJobStatusPostModel,
  });

  Future<List<ValetStandardResponseModelItem>> getJobValetStandards();

  Future<ValetStandardResponseModelItem> showJobValetStandards({
    required String id,
  });

  Future<String> confirmJob({
    required int jobId,
  });
}

final class JobRemoteDataSourceImpl
    with HandleRequestMixin
    implements JobRemoteDataSource {
  JobRemoteDataSourceImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  final NetworkClient _networkClient;

  @override
  Future<List<JobsResponseModelItem>> getJob({
    String? date,
    String? status,
  }) async {
    try {
      final response = await _networkClient.get(ServicePath.job.value,
          queryParameters: {
            'date': date,
            'status': status,
          },
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization':
                  'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
            },
          ));

      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }
      final List<dynamic> productData = response.data["data"];

      return productData.map((e) => JobsResponseModelItem.fromMap(e)).toList();
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
  Future<JobsResponseModelItem> getJobShow({
    required String id,
  }) async {
    try {
      final response = await _networkClient.get("${ServicePath.job.value}/$id",
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
          }));
      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }
      final productData = response.data["data"];
      return JobsResponseModelItem.fromMap(productData);
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
  Future<String> startJob({
    required StartJobPostModel data,
    required int jobId,
  }) async {
    try {
      final response = await _networkClient.post(
        "${ServicePath.job.value}/start/$jobId",
        data: data.toMap(),
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
      return response.data.toString();
    } on DioException catch (e) {
      if (e.response?.data["message"] == "Not authenticated") {
        ProductStateItems.hiveDatabaseManager.deleteUserToken();
        ProductStateItems
            .appRouter.router.routerDelegate.navigatorKey.currentContext
            ?.go('/sign_in_page');
      }
      final context = ProductStateItems
          .appRouter.router.routerDelegate.navigatorKey.currentContext;
      if (context != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Warning'),
              content: Text(e.response?.data['message'].toString() ?? ''),
              actions: [
                TextButton(
                  child: const Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print('Error: $e, StackTrace: $stackTrace');
      throw UnknownException();
    }
  }

  @override
  Future<String> endJob({
    required int jobId,
    required EndJobPostModel data,
  }) async {
    try {
      final response = await _networkClient.post(
        "${ServicePath.job.value}/end/$jobId",
        data: data.toMap(),
        options: Options(headers: {
          'Accept': 'application/json',
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
      return response.data.toString();
    } on DioException catch (e) {
      BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      final result =
          e.response?.data['message'].toString().contains(("feedback"));
      final result2 =
          e.response?.data['message'].toString().contains(("fuel/ev"));
      if (result == true) {
        final vehicle = e.response?.data['errors']['vehicleFeedback'] != null;
        final customer = e.response?.data['errors']['customerFeedback'] != null;
        ProductStateItems
            .appRouter.router.routerDelegate.navigatorKey.currentContext
            ?.push('/feedback_page', extra: {
          'feedbackInputAvailability': FeedbackInputAvailability(
            vehicle: vehicle
                ? FeedbackInputAvailabilityEnum.required
                : FeedbackInputAvailabilityEnum.optional,
            customer: customer
                ? FeedbackInputAvailabilityEnum.required
                : FeedbackInputAvailabilityEnum.optional,
          )
        });
      } else if (result2 == true) {
        ProductStateItems
            .appRouter.router.routerDelegate.navigatorKey.currentContext
            ?.push('/fuel_level_page', extra: {"jobId": jobId});
      }
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print('Error: $e, StackTrace: $stackTrace');
      throw UnknownException();
    }
  }

  @override
  Future<String> updateJob({
    required int jobId,
    required UpdateJobStatusPostModel updateJobStatusPostModel,
  }) async {
    try {
      final response = await _networkClient.post(
        "${ServicePath.job.value}/update/$jobId",
        data: updateJobStatusPostModel.toMap(),
        options: Options(headers: {
          'Accept': 'application/json',
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
      return response.data.toString();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        ProductStateItems.hiveDatabaseManager.deleteUserToken();
        ProductStateItems
            .appRouter.router.routerDelegate.navigatorKey.currentContext
            ?.go('/sign_in_page');
      }
      //TODO TOAST MESSAGE
      final context = ProductStateItems
          .appRouter.router.routerDelegate.navigatorKey.currentContext;
      if (context != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Warning'),
              content: Text(e.response?.data['message'].toString() ?? ''),
              actions: [
                TextButton(
                  child: const Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print('Error: $e, StackTrace: $stackTrace');
      throw UnknownException();
    }
  }

  @override
  Future<List<ValetStandardResponseModelItem>> getJobValetStandards() async {
    try {
      final response =
          await _networkClient.get(ServicePath.jobValetStandards.value,
              options: Options(headers: {
                'Content-Type': 'application/json',
                'Authorization':
                    'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
              }));
      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }
      final List<dynamic> productData = response.data["data"];
      return productData
          .map((e) => ValetStandardResponseModelItem.fromMap(e))
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
  Future<ValetStandardResponseModelItem> showJobValetStandards({
    required String id,
  }) async {
    try {
      final response =
          await _networkClient.get("${ServicePath.jobValetStandards.value}/$id",
              options: Options(headers: {
                'Content-Type': 'application/json',
                'Authorization':
                    'Bearer ${ProductStateItems.hiveDatabaseManager.getUserModel()?.token}',
              }));
      if (response.data == null || response.data == null) {
        throw NullResponseException();
      }
      if (response.data['newAccessToken'] != null) {
        ProductStateItems.hiveDatabaseManager
            .setToken(response.data['newAccessToken']);
      }
      final productData = response.data["data"];
      return ValetStandardResponseModelItem.fromMap(productData);
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
  Future<String> confirmJob({
    required int jobId,
  }) async {
    try {
      final response = await _networkClient.get(
        "${ServicePath.job.value}/confirm/$jobId",
        options: Options(headers: {
          'Accept': 'application/json',
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
      return response.data.toString();
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
