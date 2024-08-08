import 'dart:convert';

import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:ferrisfwt/product/state/base/model/i_response_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'stop_categories_response_model_item.g.dart';

@immutable
@HiveType(typeId: TypeIds.modelIdStopCategory)
class StopCategoriesResponseModelItem extends IResponseModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  StopCategoriesResponseModelItem({
    required this.id,
    required this.name,
  });

  factory StopCategoriesResponseModelItem.fromJson(String json) {
    return StopCategoriesResponseModelItem.fromMap(jsonDecode(json));
  }

  factory StopCategoriesResponseModelItem.fromMap(Map<String, dynamic> map) {
    return StopCategoriesResponseModelItem(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  @override
  String toString() => '$runtimeType(${toMap()})';

  @override
  bool operator ==(Object other) {
    if (other is StopCategoriesResponseModelItem) {
      return id == other.id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;
}
