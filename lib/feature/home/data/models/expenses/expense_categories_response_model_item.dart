import 'dart:convert';

import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';

import 'package:ferrisfwt/product/state/base/model/i_response_model.dart';
import 'package:hive/hive.dart';

part 'expense_categories_response_model_item.g.dart';

@HiveType(typeId: TypeIds.modelIdExpenseCategory)
class ExpenseCategoriesResponseModelItem implements IResponseModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  ExpenseCategoriesResponseModelItem({
    required this.id,
    required this.name,
  });

  factory ExpenseCategoriesResponseModelItem.fromJson(String json) {
    return ExpenseCategoriesResponseModelItem.fromMap(jsonDecode(json));
  }

  factory ExpenseCategoriesResponseModelItem.fromMap(Map<String, dynamic> map) {
    return ExpenseCategoriesResponseModelItem(
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
  String toString() => 'ExpenseCategory($toMap)';

  @override
  bool operator ==(Object other) {
    if (other is ExpenseCategoriesResponseModelItem) {
      return id == other.id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;
}
