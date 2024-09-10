import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';
import 'package:hive/hive.dart';

import '../../../../../../utility/error_handler/sentry_error_handler.dart';

part 'inspection_damage_post_model.g.dart';

@HiveType(typeId: 193)
class InspectionDamagePostModel extends INetworkSentDataModel {
  @HiveField(0)
  final int jobInspectionId;
  @HiveField(1)
  final int categoryId;
  @HiveField(2)
  final int partId;
  @HiveField(3)
  final int issueId;
  @HiveField(4)
  final int failureId;
  @HiveField(5)
  final int repairId;
  @HiveField(6)
  final File? damageImage;
  @HiveField(7)
  final File? contextImage;
  @HiveField(8)
  final int? damageId;

  InspectionDamagePostModel({
    required this.jobInspectionId,
    required this.categoryId,
    required this.partId,
    required this.issueId,
    required this.failureId,
    required this.repairId,
    required this.damageId,
    this.damageImage,
    this.contextImage,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'jobInspectionId': jobInspectionId,
      'categoryId': categoryId,
      'partId': partId,
      'issueId': issueId,
      'failureId': failureId,
      'repairId': repairId,
      'damageImage': damageImage != null
          ? MultipartFile.fromFileSync(damageImage!.path)
          : null,
      'contextImage': contextImage != null
          ? MultipartFile.fromFileSync(contextImage!.path)
          : null,
    };
  }

  MultipartFile? convertToMultipartFile(File evidencePath) {
    try {
      // Verify if the file exists
      File file = File(evidencePath.path);
      if (!file.existsSync()) {
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

      return null;
    }
  }
}
