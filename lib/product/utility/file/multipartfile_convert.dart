import 'dart:io';

import 'package:dio/dio.dart';

List<MultipartFile> convertToMultipartFileList(List<String> evidencePaths) {
  List<MultipartFile> multipartFiles = [];

  for (String path in evidencePaths) {
    try {
      // Verify if the file exists
      File file = File(path);
      if (!file.existsSync()) {
        print('File not found at path: $path');
        continue; // Skip this path and proceed to the next one
      }

      // Create MultipartFile object
      MultipartFile multipartFile = MultipartFile.fromFileSync(
        path,
        filename: path.split('/').last,
      );

      // Add the MultipartFile to the list
      multipartFiles.add(multipartFile);
    } catch (e) {
      print('Error processing file at path: $path');
      print(e.toString());
      // Handle the error as needed
    }
  }

  return multipartFiles;
}
