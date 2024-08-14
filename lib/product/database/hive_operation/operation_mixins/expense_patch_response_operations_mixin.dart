part of hive_storage_manager;

mixin ExpensePatchPostResponseOperationsMixin {
  static final _expensePatchPostResponseBox =
      Hive.box<ExpensePatchResponseModel>(
          HiveDatabaseConstants.expensePatchResponse);

  /// Replace all inspection condition images in the Hive box with new data.
  ///

  Future<void> replaceExpensePatchPostResponsesTable(
      ExpensePatchResponseModel data) async {
    await _expensePatchPostResponseBox.put(data.oldExpense.jobId, data);
  }

  Future<List<ExpensePatchResponseModel>> getExpensePatchPostResponses(
      int jobId) async {
    final jsonList = _expensePatchPostResponseBox.values.toList();
    final List<ExpensePatchResponseModel> results = [];

    for (final image in jsonList) {
      if (image.oldExpense.jobId == jobId) {
        results.add(image);
      }
    }

    return results;
  }

  Future<List<ExpensePatchResponseModel>> setExpensePatchPostResponses(
      List<ExpensePatchResponseModel> data) async {
    await _expensePatchPostResponseBox.clear();
    for (final item in data) {
      await _expensePatchPostResponseBox.put(item.oldExpense.jobId, item);
    }
    // print('setExpensePatchPostResponses: $data');
    return data;
  }

  Future<void> deleteExpensePatchPostResponses() async {
    await _expensePatchPostResponseBox.clear();
  }
}
