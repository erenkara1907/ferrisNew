import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:ferrisfwt/product/errors/exceptions/exceptions.dart';
import 'package:flutter/material.dart';

import '../utility/error_handler/sentry_error_handler.dart';

mixin HandleRequestMixin {
  Future<T> handleRequest<T>(
    Future<Response> request,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic> Function(Map<String, dynamic>)? manipulateData,
  }) async {
    try {
      final response = await request;
      return _handleResponse(response, fromJson, manipulateData);
    } on DioException catch (e, s) {
      // BotToast.showText(text: e.response?.data['message'].toString() ?? '');
      throw DioException(requestOptions: e.requestOptions, message: e.message);
    } catch (e, stackTrace) {
      print("Error : ${e.toString()} , StackTrace: $stackTrace");
      throw UnknownException();
    }
  }

  Future<T> _handleResponse<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic> Function(Map<String, dynamic>)? manipulateData,
  ) {
    if (response.data == null) {
      throw NullResponseException();
    }

    if (response.data['status'] == false) {
      if (response.data['message'] != null) {
        // BotToast.showText(text: response.data['message'].toString());
      }
    }

    final dataToConvert = manipulateData != null
        ? manipulateData(response.data as Map<String, dynamic>)
        : response.data as Map<String, dynamic>;

    return Future.value(fromJson(dataToConvert));
  }
}
