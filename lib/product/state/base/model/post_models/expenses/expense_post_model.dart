import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';
import 'package:hive/hive.dart';

import '../../../../../utility/error_handler/sentry_error_handler.dart';

part 'expense_post_model.g.dart';

@HiveType(typeId: 180)
class ExpensePostModel extends INetworkSentDataModel {
  @HiveField(0)
  final int jobId;
  @HiveField(1)
  final int categoryId;
  @HiveField(2)
  final double price;
  @HiveField(3)
  final String? reasonNoReceipt;
  @HiveField(4)
  final File? receipt;

  ExpensePostModel({
    required this.jobId,
    required this.categoryId,
    required this.price,
    this.reasonNoReceipt,
    this.receipt,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'categoryId': categoryId,
      'price': price,
      'reasonNoReceipt': reasonNoReceipt,
      'receipt': receipt == null ? null : convertToMultipartFile(receipt!),
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
