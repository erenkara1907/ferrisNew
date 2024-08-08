part of hive_storage_manager;

mixin JobExpenseAsyncOperationsMixin {
  static const String _keyJobExpenseAsync = 'job_expense_async';

  /// Returns the Hive box for the job working on.
  static final Uuid _uuid = Uuid();

  /// LazyBox instance for the expenses box.
  LazyBox<ExpensePostModel>? _jobExpenseBoxInstance;

  /// Returns the expenses box. Creates it if it doesn't exist.
  Future<LazyBox<ExpensePostModel>> get _jobExpenseAsyncBox async {
    return _jobExpenseBoxInstance ??=
        await Hive.openLazyBox<ExpensePostModel>(_keyJobExpenseAsync);
  }

  /// Saves the given job as the job working on.
  /// If [job] is null, it will remove the job working on
  Future<void> setJobExpenseAsync(ExpensePostModel data) async {
    final box = await _jobExpenseAsyncBox;
    final key = _uuid.v4(); // Generate a unique key
    return box.put(key, data);
  }

  /// Returns the job working on. If there is no job working on, it will return null.
  Future<List<ExpensePostModel?>> getJobExpenseAsync() async {
    final box = await _jobExpenseAsyncBox;
    final keys = box.keys.toList();
    final List<Future<ExpensePostModel?>> futures = [];
    for (final key in keys) {
      final future = box.get(key);
      futures.add(future);
    }
    return Future.wait(futures);
  }

  /// Deletes the job working on.
  ///
  /// If [job] is null, it will remove the job working on
  Future<void> deleteJobExpenseAsync() async {
    final box = await _jobExpenseAsyncBox;
    box.clear();
  }

  /// Updates an existing job expense with matching criteria.
  /// If no matching job expense is found, it does nothing.
  Future<void> updateJobExpenseAsync(
      ExpensePostModel data, bool Function(ExpensePostModel) criteria) async {
    final box = await _jobExpenseAsyncBox;
    final keys = box.keys.toList();
    for (final key in keys) {
      final existingData = await box.get(key);
      if (existingData != null && criteria(existingData)) {
        await box.put(key, data);
        break;
      }
    }
  }
}
