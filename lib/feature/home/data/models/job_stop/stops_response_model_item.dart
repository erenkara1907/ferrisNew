import 'dart:convert';

import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:ferrisfwt/product/state/base/model/i_response_model.dart';
import 'package:hive/hive.dart';

import 'stop_categories_response_model_item.dart';
import 'stop_evidence_model.dart';

part 'stops_response_model_item.g.dart';

@HiveType(typeId: TypeIds.modelIdStopResponseModel)
class StopsResponseModelItem implements IResponseModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int? jobId;

  /// outdated. use category instead
  @HiveField(2)
  String? reason;

  @HiveField(3)
  double? longitude;

  @HiveField(4)
  double? latitude;

  @HiveField(6)
  List<StopEvidenceModel> evidences;

  @HiveField(7)
  StopCategoriesResponseModelItem? categoryId;

  StopsResponseModelItem({
    this.id,
    this.jobId,
    this.reason,
    this.longitude,
    this.latitude,
    required this.evidences,
    this.categoryId,
  });

  factory StopsResponseModelItem.fromJson(String json) {
    return StopsResponseModelItem.fromMap(jsonDecode(json));
  }

  factory StopsResponseModelItem.fromMap(Map<String, dynamic> map) {
    return StopsResponseModelItem(
      id: map['id'] as int?,
      jobId: map['jobId'] is int? ? map['jobId'] as int? : map['jobId']['id'],
      reason: map['reason'] as String?,
      longitude: map['longitude'] != null
          ? double.parse(map['longitude'].toString())
          : null,
      latitude: map['latitude'] != null
          ? double.parse(map['latitude'].toString())
          : null,
      evidences: (map['evidences'] as List<dynamic>?)
              ?.map((e) => StopEvidenceModel.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      categoryId: map['categoryId'] is Map
          ? StopCategoriesResponseModelItem.fromMap(map['categoryId'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobId': jobId,
      'reason': reason,
      'longitude': longitude,
      'latitude': latitude,
      'evidences': evidences.map((e) => e.toMap()).toList(),
      'categoryId': categoryId?.toMap(),
    };
  }
}
