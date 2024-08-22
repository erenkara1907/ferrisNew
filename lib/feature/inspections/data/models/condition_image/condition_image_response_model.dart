import 'dart:io';

import 'package:dio/dio.dart';

import 'package:ferrisfwt/product/state/base/model/i_response_model.dart';
import 'package:hive/hive.dart';

import '../../../../../product/utility/error_handler/sentry_error_handler.dart';

part 'condition_image_response_model.g.dart';

@HiveType(typeId: 192)
class ConditionImageResponseModel implements IResponseModel {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final int jobInspectionId;

  @HiveField(2)
  final String? imagePath;

  final File? imageFile;

  ConditionImageResponseModel({
    this.id,
    required this.jobInspectionId,
    this.imagePath,
    this.imageFile,
  });

  factory ConditionImageResponseModel.fromMap(Map<String, dynamic> map) {
    return ConditionImageResponseModel(
      id: map['id'],
      jobInspectionId: map['jobInspectionId'],
      imagePath: map['imagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobInspectionId': jobInspectionId,
      'image': convertToMultipartFile(imageFile!)
    };
  }

  MultipartFile? convertToMultipartFile(File evidencePath) {
    try {
      // Verify if the file exists
      File file = File(evidencePath.path);
      if (!file.existsSync()) {
        // print('File not found at path: $evidencePath');
        return null;
      }

      // Read file contents

      // Create MultipartFile object
      MultipartFile multipartFile = MultipartFile.fromFileSync(
        file.path,
        filename: file.path.split('/').last,
      );

      return multipartFile;
    } catch (e, s) {
      SentryErrorHandler.instance.capture(e, stackTrace: s);
      // print('Error processing file at path: $evidencePath');

      return null;
    }
  }

  @override
  String toString() => toMap().toString();
}
