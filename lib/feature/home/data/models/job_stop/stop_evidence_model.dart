import 'dart:convert';

import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:ferrisfwt/product/state/base/model/i_response_model.dart';
import 'package:hive/hive.dart';

part 'stop_evidence_model.g.dart';

@HiveType(typeId: TypeIds.modelIdStopEvidence)
class StopEvidenceModel implements IResponseModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int jobStopId;

  @HiveField(2)
  final String path;

  @HiveField(3)
  final int? addedBy;

  StopEvidenceModel({
    required this.id,
    required this.jobStopId,
    required this.path,
    this.addedBy,
  });

  factory StopEvidenceModel.fromJson(String json) {
    return StopEvidenceModel.fromMap(jsonDecode(json));
  }

  factory StopEvidenceModel.fromMap(Map<String, dynamic> map) {
    return StopEvidenceModel(
      id: map['id'] as int,
      jobStopId: map['jobStopId'] as int,
      path: map['path'] as String,
      addedBy: map['addedBy'] is int? ? map['addedBy'] : map['addedBy']['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobStopId': jobStopId,
      'path': path,
      'addedBy': addedBy,
    };
  }

  @override
  String toString() => '$runtimeType(${toMap()})';
}
