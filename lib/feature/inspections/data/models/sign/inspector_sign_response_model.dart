import 'dart:convert';

import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:ferrisfwt/product/state/base/model/i_response_model.dart';
import 'package:hive/hive.dart';

part 'inspector_sign_response_model.g.dart';

@HiveType(typeId: TypeIds.modelIdInspectorSignResponse)
class InspectorSignResponseModel implements IResponseModel {
  @HiveField(0)
  final String inspectorSignatureImg;

  @HiveField(1)
  final String inspectorSignerName;

  @HiveField(2)
  final String inspectorSignLatitude;

  @HiveField(3)
  final String inspectorSignLongitude;

  @HiveField(4)
  final String date;

  InspectorSignResponseModel({
    required this.inspectorSignatureImg,
    required this.inspectorSignerName,
    required this.inspectorSignLatitude,
    required this.inspectorSignLongitude,
    required this.date,
  });

  factory InspectorSignResponseModel.fromJson(String json) {
    return InspectorSignResponseModel.fromMap(jsonDecode(json));
  }

  factory InspectorSignResponseModel.fromMap(Map<String, dynamic> map) {
    return InspectorSignResponseModel(
      inspectorSignatureImg: map['inspectorSignatureImg'],
      inspectorSignerName: map['inspectorSignerName'],
      inspectorSignLatitude: map['inspectorSignLatitude'],
      inspectorSignLongitude: map['inspectorSignLongitude'],
      date: map['date'],
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'inspectorSignatureImg': inspectorSignatureImg,
      'inspectorSignerName': inspectorSignerName,
      'inspectorSignLatitude': inspectorSignLatitude,
      'inspectorSignLongitude': inspectorSignLongitude,
      'date': date,
    };
  }
}
