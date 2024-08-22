import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';

import '../../../../../../utility/error_handler/sentry_error_handler.dart';

class InspectionDamagePatchModel extends INetworkSentDataModel {
  final int? categoryId;
  final int? partId;
  final int? issueId;
  final int? failureId;
  final int? repairId;
  final File? damageImage;
  final bool? deleteDamageImage;
  final File? contextImage;
  final bool? deleteContextImage;
  final int? damageId;

  InspectionDamagePatchModel({
    this.categoryId,
    this.partId,
    this.issueId,
    this.failureId,
    this.repairId,
    this.damageImage,
    this.deleteDamageImage,
    this.contextImage,
    this.deleteContextImage,
    this.damageId,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      if (categoryId != null) 'categoryId': categoryId,
      if (partId != null) 'partId': partId,
      if (issueId != null) 'issueId': issueId,
      if (failureId != null) 'failureId': failureId,
      if (repairId != null) 'repairId': repairId,
      if (damageImage != null)
        'damageImage': convertToMultipartFile(damageImage!),
      if (contextImage != null)
        'contextImage': convertToMultipartFile(contextImage!),
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
}
