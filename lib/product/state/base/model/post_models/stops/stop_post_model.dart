import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../utility/error_handler/sentry_error_handler.dart';

part 'stop_post_model.g.dart';

@HiveType(typeId: 171)
class StopPostModel extends INetworkSentDataModel {
  @HiveField(0)
  final int jobId;
  @HiveField(1)
  final String? reason;
  @HiveField(2)
  final int? categoryId;
  @HiveField(3)
  final double latitude;
  @HiveField(4)
  final double longitude;
  @HiveField(5)
  final List<File> evidences;

  StopPostModel({
    required this.jobId,
    this.reason, //todo remove this in the future
    this.categoryId, // todo make this required in the future
    required this.latitude,
    required this.longitude,
    required this.evidences, // Değişiklik
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      if (reason != null) 'reason': reason,
      if (categoryId != null) 'categoryId': categoryId,
      'latitude': latitude,
      'longitude': longitude,
      'evidences': convertToMultipartFileList(evidences),
    };
  }

  @override
  String toString() => toMap().toString();

  List<MultipartFile> convertToMultipartFileList(List<File> evidencePaths) {
    List<MultipartFile> multipartFiles = [];

    for (File path in evidencePaths) {
      try {
        // Create MultipartFileRecreatable object
        if (path.existsSync()) {
          // File exists, proceed with file operations
          // Example: Create MultipartFile object
          MultipartFileRecreatable multipartFile =
              MultipartFileRecreatable.fromBytes(
            path.readAsBytesSync(),
            filename: path.path.split('/').last,
          );
          multipartFiles.add(multipartFile);
        } else {}

        // Add the MultipartFile to the list
      } catch (e, s) {
        SentryErrorHandler.instance.capture(e, stackTrace: s);

        // Handle the error as needed
      }
    }

    return multipartFiles;
  }
}
