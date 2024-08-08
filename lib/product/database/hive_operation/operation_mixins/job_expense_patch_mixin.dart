part of hive_storage_manager;

mixin JobExpensePatchAsyncOperationsMixin {
  static const String _keyJobExpensePatchAsync = 'job_expense_patch_async';

  /// Returns the Hive box for the job working on.
  static final Uuid _uuid = Uuid();

  /// LazyBox instance for the expenses box.
  LazyBox<ExpensePatchModel>? _jobExpensePatchBoxInstance;

  /// Returns the expenses box. Creates it if it doesn't exist.
  Future<LazyBox<ExpensePatchModel>> get _jobExpensePatchAsyncBox async {
    return _jobExpensePatchBoxInstance ??=
        await Hive.openLazyBox<ExpensePatchModel>(_keyJobExpensePatchAsync);
  }

  /// Saves the given job as the job working on.
  /// If [job] is null, it will remove the job working on
  Future<void> setJobExpensePatchAsync(ExpensePatchModel data) async {
    final box = await _jobExpensePatchAsyncBox;
    final key = _uuid.v4(); // Benzersiz anahtar oluştur
    return box.put(key, data);
  }

  /// Returns the job working on. If there is no job working on, it will return null.
  Future<List<ExpensePatchModel?>> getJobExpensePatchAsync() async {
    final box = await _jobExpensePatchAsyncBox;
    final keys = box.keys.toList();
    final List<Future<ExpensePatchModel?>> futures = [];
    for (final key in keys) {
      final future = box.get(key);
      futures.add(future);
    }
    return Future.wait(futures);
  }

  /// Deletes the job working on.
  ///
  /// If [job] is null, it will remove the job working on
  ///

  Future<void> deleteJobExpensePatchAsync() async {
    final box = await _jobExpensePatchAsyncBox;
    box.clear();
  }
}
