import 'dart:convert';

import 'package:ferrisfwt/feature/home/data/models/expenses/expense_categories_response_model_item.dart';
import 'package:ferrisfwt/product/database/hive_operation/models/_type_ids.dart';
import 'package:ferrisfwt/product/database/hive_operation/models/expense/expense.dart';
import 'package:hive/hive.dart';
import 'package:ferrisfwt/product/state/base/model/i_response_model.dart';

part 'expenses_response_model_item.g.dart';

/// Response model for a single expense.
@HiveType(typeId: TypeIds.modelIdExpenseResponseModel)
class ExpensesResponseModelItem implements IResponseModel {
  static const String nameReceiptPath = 'receiptPath';

  @HiveField(0)
  final int id;

  @HiveField(1)
  final int jobId;

  @HiveField(2)
  final ExpenseCategoriesResponseModelItem? categoryId;

  @HiveField(3)
  final double? price;

  @HiveField(4)
  final String reasonNoReceipt;

  @HiveField(5)
  final List<String> receiptPath;

  const ExpensesResponseModelItem({
    required this.id,
    required this.jobId,
    required this.categoryId,
    required this.price,
    required this.reasonNoReceipt,
    required this.receiptPath,
  });

  factory ExpensesResponseModelItem.fromMap(Map<String, dynamic> map) {
    return ExpensesResponseModelItem(
      id: map[Expense.nameId] as int,
      jobId: map[Expense.nameJobId] is! int ? map['jobId']['id'] : map['jobId'],
      categoryId: map[Expense.nameCategoryId] == null
          ? null
          : ExpenseCategoriesResponseModelItem.fromMap(
              map[Expense.nameCategoryId]),
      price: (map[Expense.namePrice] as num).toDouble(),
      receiptPath: (map[nameReceiptPath] is List)
          ? (map[nameReceiptPath] as List).cast<String>()
          : <String>[
              if (map[nameReceiptPath] != null) map[nameReceiptPath] as String,
            ],
      reasonNoReceipt: map[Expense.nameReasonNoReceipt] as String? ?? '',
    );
  }

  factory ExpensesResponseModelItem.formJson(String json) {
    return ExpensesResponseModelItem.fromMap(jsonDecode(json));
  }

  Map<String, dynamic> toMap() {
    return {
      Expense.nameId: id,
      Expense.nameJobId: jobId,
      Expense.nameCategoryId: categoryId?.toMap(),
      Expense.namePrice: price,
      Expense.nameReasonNoReceipt: reasonNoReceipt,
      nameReceiptPath: receiptPath,
    };
  }

  bool isEmpty() {
    return categoryId == null &&
        price == 0 &&
        reasonNoReceipt.isEmpty &&
        receiptPath.isEmpty;
  }
}
