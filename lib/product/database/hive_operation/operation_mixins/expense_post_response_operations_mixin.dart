part of hive_storage_manager;

mixin ExpensePostResponseOperationsMixin {
  static final _expensePostResponseBox = Hive.box<ExpensesResponseModelItem>(
      HiveDatabaseConstants.expensePostResponse);

  /// Replace all inspection condition images in the Hive box with new data.
  ///

  Future<void> replaceExpensePostResponsesTable(
      ExpensesResponseModelItem data) async {
    final List<ExpensesResponseModelItem> expensePostResponseList = [];

    final jsonList = _expensePostResponseBox.values.toList();

    final List<ExpensesResponseModelItem> results = [];

    for (final image in jsonList) {
      results.add(image);
    }

    if (results.isEmpty) {
      expensePostResponseList.add(data);
      await _expensePostResponseBox.put(data.jobId, data);
    } else {
      for (final image in results) {
        expensePostResponseList.add(image);
      }
      expensePostResponseList.add(data);
      await _expensePostResponseBox.clear();
      for (final image in expensePostResponseList) {
        await _expensePostResponseBox.put(image.jobId, image);
      }
    }
  }

  Future<List<ExpensesResponseModelItem>> getExpensePostResponses() async {
    final keys = _expensePostResponseBox.keys.toList();
    final List<ExpensesResponseModelItem?> futures = [];
    for (final key in keys) {
      final future = _expensePostResponseBox.get(key);
      futures.add(future);
    }
    return futures.whereType<ExpensesResponseModelItem>().toList();
  }

  Future<List<ExpensesResponseModelItem>> setExpensePostResponses(
      List<ExpensesResponseModelItem> data) async {
    await _expensePostResponseBox.clear();
    for (final item in data) {
      await _expensePostResponseBox.put(item.jobId, item);
    }
    // print('setExpensePostResponses: $data');
    return data;
  }

  Future<void> deleteExpensePostResponses() async {
    await _expensePostResponseBox.clear();
  }
}
