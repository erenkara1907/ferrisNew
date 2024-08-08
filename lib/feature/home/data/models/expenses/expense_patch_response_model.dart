import 'dart:convert';
import 'package:ferrisfwt/product/state/base/model/i_response_model.dart';

import 'package:ferrisfwt/feature/home/data/models/expenses/expenses_response_model_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'expense_patch_response_model.g.dart';

@HiveType(typeId: 179)
class ExpensePatchResponseModel implements IResponseModel {
  @HiveField(0)
  final ExpensesResponseModelItem oldExpense;
  @HiveField(1)
  final ExpensesResponseModelItem newExpense;

  ExpensePatchResponseModel({
    required this.oldExpense,
    required this.newExpense,
  });

  factory ExpensePatchResponseModel.fromMap(Map<String, dynamic> map) {
    return ExpensePatchResponseModel(
      oldExpense: ExpensesResponseModelItem.fromMap(map['old']),
      newExpense: ExpensesResponseModelItem.fromMap(map['new']),
    );
  }

  factory ExpensePatchResponseModel.fromJson(String json) {
    return ExpensePatchResponseModel.fromMap(jsonDecode(json));
  }
}
