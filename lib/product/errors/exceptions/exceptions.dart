import 'package:flutter/material.dart';

final class NullResponseException implements Exception {
  final String message;
  NullResponseException([this.message = "No response received."]);
}

final class UnknownException implements Exception {
  final String message;
  UnknownException([this.message = "An unknown error occurred."]);
}

void handleError(BuildContext context, Exception exception) {
  String message;
  if (exception is NullResponseException) {
    message = exception.message;
  } else if (exception is UnknownException) {
    message = exception.message;
  } else {
    message = "An unexpected error occurred.";
  }
  showErrorMessage(context, message);
}

void showErrorMessage(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
