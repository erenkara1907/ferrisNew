import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/i_network_sent_data_model.dart';
import 'package:hive/hive.dart';

import '../../../../../../utility/error_handler/sentry_error_handler.dart';

part 'inspection_customer_sign_post_model.g.dart';

@HiveType(typeId: 195)
class InspectionCustomerSignPostModel extends INetworkSentDataModel {
  @HiveField(0)
  final File customerSignatureImg;
  @HiveField(1)
  final String customerSignerName;
  @HiveField(2)
  final String customerSignLatitude;
  @HiveField(3)
  final String customerSignLongitude;
  @HiveField(4)
  final String date;

  // final bool conditionImagesSynced;
  // final bool damageRepairIds;
  // final List<int> repairIds;
  // final double? repairsTotalPrice;
  // final double odometer;
  // final MultipartFile formSnapshot;

  InspectionCustomerSignPostModel({
    required this.customerSignatureImg,
    required this.customerSignerName,
    required this.customerSignLatitude,
    required this.customerSignLongitude,
    required this.date,
    // required this.conditionImagesSynced,
    // required this.damageRepairIds,
    // required this.repairIds,
    // required this.repairsTotalPrice,
    // required this.odometer,
    // required this.formSnapshot,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'customerSignatureImg': convertToMultipartFile(customerSignatureImg),
      'customerSignerName': customerSignerName,
      'customerSignLatitude': customerSignLatitude,
      'customerSignLongitude': customerSignLongitude,
      'date': date,
      // 'condition_images_synced': conditionImagesSynced,
      // 'damage_repair_ids': damageRepairIds,
      // 'repair_ids': repairIds,
      // 'repairs_total_price': repairsTotalPrice,
      // 'odometer': odometer,
      // 'form_snapshot': formSnapshot,
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
