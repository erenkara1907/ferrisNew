part of hive_storage_manager;

mixin ExpenseCategoriesOperationsMixin {
  static final _expenseCategoriesBox =
      Hive.box<ExpenseCategoriesResponseModelItem>(
          HiveDatabaseConstants.jobExpenseBox);

  /// Saves the list of expense categories to the Hive box.
  Future<void> setExpenseCategories(
      List<ExpenseCategoriesResponseModelItem> categoryList) async {
    for (final post in categoryList) {
      await _expenseCategoriesBox.put(post.id, post);
    }
  }

  /// Retrieves the list of expense categories from the Hive box.
  Future<List<ExpenseCategoriesResponseModelItem>?>
      getExpenseCategories() async {
    final jsonList = _expenseCategoriesBox.values.toList();
    return jsonList;
  }
}
