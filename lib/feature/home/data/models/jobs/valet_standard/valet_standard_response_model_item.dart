import 'dart:convert';

import 'package:ferrisfwt/product/state/base/model/i_response_model.dart';
import 'package:hive/hive.dart';

part 'valet_standard_response_model_item.g.dart';

@HiveType(typeId: 39)
class ValetStandardResponseModelItem implements IResponseModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;

  ValetStandardResponseModelItem({
    required this.id,
    required this.name,
  });

  factory ValetStandardResponseModelItem.fromJson(String json) {
    return ValetStandardResponseModelItem.fromMap(jsonDecode(json));
  }

  factory ValetStandardResponseModelItem.fromMap(Map<String, dynamic> map) {
    return ValetStandardResponseModelItem(
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
}
