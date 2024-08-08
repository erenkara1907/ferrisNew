import 'package:ferrisfwt/product/manager/utils/util/multipart_file_mixin.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expense_categories_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expenses_response_model_item.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/expenses/expense_post_model.dart';
import 'package:ferrisfwt/product/utility/constants/app_defaults.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart' as uuid;

import '../_type_ids.dart';

part 'expense.g.dart';

@HiveType(typeId: TypeIds.modelIdExpense)
@immutable
class Expense with MultipartFileMixin {
  static const String nameId = 'id';
  static const String nameJobId = 'jobId';
  static const String nameCategoryId = 'categoryId';
  static const String namePrice = 'price';
  static const String nameReasonNoReceipt = 'reasonNoReceipt';
  static const String nameReceiptPathsLocal = 'receiptPathsLocal';
  static const String nameSyncedExpense = 'syncedExpense';
  static const String nameSynced = 'synced';

  const Expense({
    required this.id,
    required this.jobId,
    this.categoryId,
    this.price,
    required this.reasonNoReceipt,
    required this.receiptPathsLocal,
    this.syncedExpense,
    required this.synced,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final int jobId;

  @HiveField(2)
  final ExpenseCategoriesResponseModelItem? categoryId;

  @HiveField(3)
  final double? price;

  @HiveField(4)
  final String reasonNoReceipt;

  @HiveField(5)
  final List<String> receiptPathsLocal;

  @HiveField(6)
  final ExpensesResponseModelItem? syncedExpense;

  @HiveField(7)
  final bool synced;

  Map<String, dynamic> toMap() {
    return {
      nameId: id,
      nameJobId: jobId,
      namePrice: price,
      nameReasonNoReceipt: reasonNoReceipt,
      nameCategoryId: categoryId?.toMap(),
      nameSyncedExpense: syncedExpense?.toMap(),
      nameReceiptPathsLocal: receiptPathsLocal,
      nameSynced: synced,
    };
  }

  /// Creates an empty expense with the given job id.
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map[nameId],
      jobId: map[nameJobId],
      categoryId:
          ExpenseCategoriesResponseModelItem.fromMap(map[nameCategoryId]),
      price: map[namePrice],
      reasonNoReceipt: map[nameReasonNoReceipt] ?? '',
      receiptPathsLocal: map[nameReceiptPathsLocal],
      syncedExpense: map[nameSyncedExpense] != null
          ? ExpensesResponseModelItem.fromMap(map[nameSyncedExpense])
          : null,
      synced: map[nameSynced],
    );
  }

  /// Creates an expense from the given [data].
  /// [id] is the id of the expense in the local storage.
  /// [receiptPathsLocal] is the list of the names of the images in the local
  /// file system.
  /// [isSynced] is true if the expense is synced with the server.
  /// other properties of the expense comes from the [data].
  factory Expense.fromResponseModel(
    ExpensesResponseModelItem data, {
    required String id,
    required List<String> receiptPathsLocal,
    isSynced = true,
  }) {
    final map = data.toMap();
    map[nameSyncedExpense] = {...map}; // deep copy
    map[nameId] = id;
    map[nameSynced] = isSynced;
    map[nameReceiptPathsLocal] = receiptPathsLocal;
    return Expense.fromMap(map);
  }

  /// Creates an empty expense with the given job inspection id.
  factory Expense.empty(int jobId) {
    return Expense(
      id: const uuid.Uuid().v4(),
      jobId: jobId,
      categoryId: null,
      price: null,
      reasonNoReceipt: '',
      receiptPathsLocal: const [],
      syncedExpense: null,
      synced: false,
    );
  }

  String get displayName {
    return '£${price?.toStringAsFixed(2) ?? 'no price'} - ${categoryId?.name ?? 'no category'}';
  }

  /// Returns a post model for this expense with the given inputs. use this
  /// function when you want to upload a new expense (not update).

  /// Returns a patch model for this expense with the given inputs.
  /// inputImages should be only the name of the image files. eg. filename.jpg
  /// Returns true if this expense has a difference with the other expense.
  bool hasDiff(Expense other) {
    final bool jobIdChanged = jobId != other.jobId;
    final bool priceChanged = price != other.price;
    final bool reasonNoReceiptChanged =
        reasonNoReceipt != other.reasonNoReceipt;

    final bool receiptPathsLocalSizeChanged =
        receiptPathsLocal.length != other.receiptPathsLocal.length;
    final bool receiptPathsLocalChanged = receiptPathsLocal
        .any((image) => !other.receiptPathsLocal.contains(image));

    return jobIdChanged ||
        priceChanged ||
        reasonNoReceiptChanged ||
        receiptPathsLocalSizeChanged ||
        receiptPathsLocalChanged;
  }

  /// Returns true if this expense is empty.
  bool isEmpty({bool checkForSyncedData = false, int? defaultCategoryId}) {
    if (defaultCategoryId == null) {
      if (categoryId != null) return false;
    } else if (categoryId != null) {
      if (categoryId!.id != defaultCategoryId) return false;
    }
    return price == null &&
        reasonNoReceipt.isEmpty &&
        receiptPathsLocal.isEmpty &&
        (!checkForSyncedData || syncedExpense == null);
  }

  bool isSynced() {
    if (syncedExpense == null) return false;
    return synced;
  }

  @override
  String toString() {
    return 'Expense: ${toMap()}';
  }
}
