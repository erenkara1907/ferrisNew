import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';

import 'package:hive/hive.dart';

part 'inspection_inspector_sign_post_model.g.dart';

@HiveType(typeId: 196)
class InspectionInspectorSignPostModel extends INetworkSentDataModel {
  @HiveField(0)
  final File inspectorSignatureImg;
  @HiveField(1)
  final String inspectorSignerName;
  @HiveField(2)
  final String inspectorSignLatitude;
  @HiveField(3)
  final String inspectorSignLongitude;
  @HiveField(4)
  final String date;

  InspectionInspectorSignPostModel({
    required this.inspectorSignatureImg,
    required this.inspectorSignerName,
    required this.inspectorSignLatitude,
    required this.inspectorSignLongitude,
    required this.date,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'inspectorSignatureImg': convertToMultipartFile(inspectorSignatureImg),
      'inspectorSignerName': inspectorSignerName,
      'inspectorSignLatitude': inspectorSignLatitude,
      'inspectorSignLongitude': inspectorSignLongitude,
      'date': date,
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
}
