import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:ferrisfwt/product/state/base/model/i_response_model.dart';
import 'package:hive/hive.dart';

part 'condition_image_response_model.g.dart';

@HiveType(typeId: TypeIds.modelIdInspectionConditionImageResponse)
class ConditionImageResponseModel implements IResponseModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int jobInspectionId;

  @HiveField(2)
  final String imagePath;

  ConditionImageResponseModel({
    required this.id,
    required this.jobInspectionId,
    required this.imagePath,
  });

  factory ConditionImageResponseModel.fromMap(Map<String, dynamic> map) {
    return ConditionImageResponseModel(
      id: map['id'],
      jobInspectionId: map['jobInspectionId'],
      imagePath: map['imagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobInspectionId': jobInspectionId,
      'imagePath': imagePath,
    };
  }

  @override
  String toString() => toMap().toString();
}
