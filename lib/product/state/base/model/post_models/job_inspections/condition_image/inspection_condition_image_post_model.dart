import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';
import 'package:hive/hive.dart';

part 'inspection_condition_image_post_model.g.dart';

@HiveType(typeId: 192)
class InspectionConditionImagePostModel extends INetworkSentDataModel {
  @HiveField(0)
  int? jobInspectionId;
  @HiveField(1)
  File image;

  InspectionConditionImagePostModel({
    required this.jobInspectionId,
    required this.image,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'jobInspectionId': jobInspectionId,
      'image': convertToMultipartFile(image)
    };
  }

  MultipartFile? convertToMultipartFile(File evidencePath) {
    try {
      // Verify if the file exists
      File file = File(evidencePath.path);
      if (!file.existsSync()) {
        print('File not found at path: $evidencePath');
        return null;
      }

      // Read file contents

      // Create MultipartFile object
      MultipartFile multipartFile = MultipartFile.fromFileSync(
        file.path,
        filename: file.path.split('/').last,
      );

      return multipartFile;
    } catch (e) {
      print('Error processing file at path: $evidencePath');
      print(e.toString());
      return null;
    }
  }

  @override
  String toString() => toMap().toString();
}
