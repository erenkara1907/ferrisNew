import 'package:equatable/equatable.dart';

class GeneralResponse<T> extends Equatable {
  final bool status;
  final String message;
  final String? newAccessToken;
  final T? data;

  GeneralResponse({
    required this.status,
    required this.message,
    this.newAccessToken,
    this.data,
  });

  @override
  List<Object?> get props => [status, message, newAccessToken, data];

  factory GeneralResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic json) fromJsonT) {
    return GeneralResponse(
      status: json['status'],
      message: json['message'],
      newAccessToken: json['newAccessToken'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'newAccessToken': newAccessToken,
      'data': data,
    };
  }
}
