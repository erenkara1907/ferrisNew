import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';
import 'package:hive/hive.dart';

import '../../../../../utility/error_handler/sentry_error_handler.dart';

part 'expense_patch_model.g.dart';

@HiveType(typeId: 222)
class ExpensePatchModel extends INetworkSentDataModel {
  @HiveField(0)
  final int? expenseId;
  @HiveField(1)
  final int? categoryId;
  @HiveField(2)
  final double? price;
  @HiveField(3)
  final String? reasonNoReceipt;
  @HiveField(4)
  final File? receipt;

  ExpensePatchModel({
    this.categoryId,
    this.price,
    this.reasonNoReceipt,
    this.receipt,
    this.expenseId,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      if (categoryId != null) 'categoryId': categoryId,
      if (price != null) 'price': price,
      if (reasonNoReceipt != null) 'reasonNoReceipt': reasonNoReceipt,
      if (receipt != null)
        'receipt': receipt == null ? null : convertToMultipartFile(receipt!),
    };
  }

  MultipartFile? convertToMultipartFile(File evidencePath) {
    try {
      // Verify if the file exists

      final file = File(evidencePath.path);

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
