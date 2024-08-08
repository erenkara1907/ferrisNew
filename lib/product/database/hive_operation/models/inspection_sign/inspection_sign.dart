import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:ferrisfwt/product/manager/utils/util/app_extensions.dart';
import 'package:ferrisfwt/product/manager/utils/util/multipart_file_mixin.dart';
import 'package:ferrisfwt/feature/inspections/data/models/sign/customer_sign_response_model.dart';
import 'package:ferrisfwt/feature/inspections/data/models/sign/inspector_sign_response_model.dart';
import 'package:hive/hive.dart';

part 'inspection_sign.g.dart';

@HiveType(typeId: TypeIds.modelIdInspectionSign)
class InspectionSign with MultipartFileMixin {
  @HiveField(0)
  final int inspectionId;

  @HiveField(1)
  final String? customerSignatureImgPath;

  @HiveField(2)
  final String? customerSignerName;

  @HiveField(3)
  final int? customerDateInMilliseconds;

  @HiveField(4)
  final CustomerSignResponseModel? customerSignResponseModel;

  @HiveField(5)
  final String? inspectorSignatureImgPath;

  @HiveField(6)
  final String? inspectorSignerName;

  @HiveField(7)
  final int? inspectorDateInMilliseconds;

  @HiveField(8)
  final InspectorSignResponseModel? inspectorSignResponseModel;

  @HiveField(9)
  final double? latitude;

  @HiveField(10)
  final double? longitude;

  @HiveField(11)
  final bool isCustomerSignSynced;

  @HiveField(12)
  final bool isInspectorSignSynced;

  InspectionSign({
    required this.inspectionId,
    this.customerSignatureImgPath,
    this.customerSignerName,
    this.customerDateInMilliseconds,
    this.customerSignResponseModel,
    this.inspectorSignatureImgPath,
    this.inspectorSignerName,
    this.inspectorDateInMilliseconds,
    this.inspectorSignResponseModel,
    this.latitude,
    this.longitude,
    required this.isCustomerSignSynced,
    required this.isInspectorSignSynced,
  });

  bool get isSyncedCompletely {
    return isCustomerSignSynced && isInspectorSignSynced;
  }

  bool get isValid {
    return isCustomerSignValid && isInspectorSignValid;
  }

  bool get isCustomerSignValid {
    return customerSignatureImgPath != null &&
        customerSignerName != null &&
        customerDateInMilliseconds != null;
  }

  bool get isInspectorSignValid {
    return inspectorSignatureImgPath != null &&
        inspectorSignerName != null &&
        latitude != null &&
        longitude != null &&
        inspectorDateInMilliseconds != null;
  }

  bool get syncedCompletely {
    return isCustomerSignSynced && isInspectorSignSynced;
  }

  InspectionSign copyWith({
    int? inspectionId,
    String? customerSignatureImgPath,
    String? customerSignerName,
    int? customerDateInMilliseconds,
    CustomerSignResponseModel? customerSignResponseModel,
    String? inspectorSignatureImgPath,
    String? inspectorSignerName,
    int? inspectorDateInMilliseconds,
    InspectorSignResponseModel? inspectorSignResponseModel,
    double? latitude,
    double? longitude,
    bool? isCustomerSignSynced,
    bool? isInspectorSignSynced,
  }) {
    return InspectionSign(
      inspectionId: inspectionId ?? this.inspectionId,
      customerSignatureImgPath:
          customerSignatureImgPath ?? this.customerSignatureImgPath,
      customerSignerName: customerSignerName ?? this.customerSignerName,
      customerDateInMilliseconds:
          customerDateInMilliseconds ?? this.customerDateInMilliseconds,
      customerSignResponseModel:
          customerSignResponseModel ?? this.customerSignResponseModel,
      inspectorSignatureImgPath:
          inspectorSignatureImgPath ?? this.inspectorSignatureImgPath,
      inspectorSignerName: inspectorSignerName ?? this.inspectorSignerName,
      inspectorDateInMilliseconds:
          inspectorDateInMilliseconds ?? this.inspectorDateInMilliseconds,
      inspectorSignResponseModel:
          inspectorSignResponseModel ?? this.inspectorSignResponseModel,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isCustomerSignSynced: isCustomerSignSynced ?? this.isCustomerSignSynced,
      isInspectorSignSynced:
          isInspectorSignSynced ?? this.isInspectorSignSynced,
    );
  }

  @override
  String toString() =>
      'InspectionSign(inspectionId: $inspectionId, customerSignatureImgPath: $customerSignatureImgPath, customerSignerName: $customerSignerName, customerDateInMilliseconds: $customerDateInMilliseconds, customerSignResponseModel: $customerSignResponseModel, inspectorSignatureImgPath: $inspectorSignatureImgPath, inspectorSignerName: $inspectorSignerName, inspectorDateInMilliseconds: $inspectorDateInMilliseconds, inspectorSignResponseModel: $inspectorSignResponseModel, latitude: $latitude, longitude: $longitude, isCustomerSignSynced: $isCustomerSignSynced, isInspectorSignSynced: $isInspectorSignSynced)';
}
