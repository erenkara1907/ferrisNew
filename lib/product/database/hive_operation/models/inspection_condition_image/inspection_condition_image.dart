import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:ferrisfwt/product/manager/utils/util/multipart_file_mixin.dart';
import 'package:ferrisfwt/feature/inspections/data/models/condition_image/condition_image_response_model.dart';
import 'package:hive/hive.dart';

part 'inspection_condition_image.g.dart';

@HiveType(typeId: TypeIds.modelIdInspectionConditionImage)
class InspectionConditionImage with MultipartFileMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int inspectionId;

  @HiveField(3)
  final String? image;

  @HiveField(4)
  final ConditionImageResponseModel? conditionImageResponseModel;

  @HiveField(5)
  final bool markedForDeletion;

  InspectionConditionImage({
    required this.id,
    required this.inspectionId,
    required this.image,
    this.conditionImageResponseModel,
    this.markedForDeletion = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'inspectionId': inspectionId,
      'image': image,
      'conditionImageResponseModel': conditionImageResponseModel?.toMap(),
      'markedForDeletion': markedForDeletion,
    };
  }

  ConditionImageStatus get status {
    if (markedForDeletion) {
      return ConditionImageStatus.markedForDeletion;
    }
    if (conditionImageResponseModel != null) {
      return ConditionImageStatus.synced;
    }
    return ConditionImageStatus.notSynced;
  }

  bool get isUploaded => status == ConditionImageStatus.synced;

  InspectionConditionImage copyWith({
    String? id,
    int? inspectionId,
    String? image,
    ConditionImageResponseModel? conditionImageResponseModel,
    bool? markedForDeletion,
  }) {
    return InspectionConditionImage(
      id: id ?? this.id,
      inspectionId: inspectionId ?? this.inspectionId,
      image: image ?? this.image,
      conditionImageResponseModel:
          conditionImageResponseModel ?? this.conditionImageResponseModel,
      markedForDeletion: markedForDeletion ?? this.markedForDeletion,
    );
  }

  @override
  String toString() => toMap().toString();
}

enum ConditionImageStatus {
  synced,
  notSynced,
  markedForDeletion,
}
