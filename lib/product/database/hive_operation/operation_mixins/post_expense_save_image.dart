part of hive_storage_manager;

mixin PostExpenseSaveImageOperationMixin {
  static final _postExpenseSaveImagesBox =
      Hive.box<ExpensePostModel>(HiveDatabaseConstants.postExpenseSaveImage);

  /// Get all condition images for a specific jobInspectionId
  ExpensePostModel? getPostExpenseSaveImage({
    required double price,
    required int categoryId,
  }) {
    try {
      final expense = _postExpenseSaveImagesBox.values.firstWhere(
        (element) => element.price == price && element.categoryId == categoryId,
      );
      return expense;
    } catch (e) {
      return null;
    }
  }

  /// Add a new condition image to the box
  Future<void> addPostExpenseSaveImage(ExpensePostModel userModel) async {
    await _postExpenseSaveImagesBox.add(userModel);
  }

  Future<void> updateLastPostExpenseSaveImage(
      {required double oldPrice,
      required int oldCategoryId,
      required ExpensePostModel newExpense}) async {
    final existingExpenseIndex = _postExpenseSaveImagesBox.values
        .toList()
        .indexWhere(
          (element) =>
              element.price == oldPrice && element.categoryId == oldCategoryId,
        );

    // If an existing expense is found, delete it
    if (existingExpenseIndex != -1) {
      final key = _postExpenseSaveImagesBox.keyAt(existingExpenseIndex);
      await _postExpenseSaveImagesBox.delete(key);
    }

    // Add the new expense
    await _postExpenseSaveImagesBox.add(newExpense);
  }

  Future<void> clearAllPostExpenseSaveImages() async {
    await _postExpenseSaveImagesBox.clear();
  }
}
