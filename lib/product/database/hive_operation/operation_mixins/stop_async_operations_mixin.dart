part of hive_storage_manager;

mixin JobStopAsyncOperationsMixin {
  static const String _keyJobStopAsync = 'job_stop_async';

  /// Returns the Hive box for the job working on.
  static final Uuid _uuid = Uuid();

  /// LazyBox instance for the expenses box.
  LazyBox<StopPostModel>? _jobStopBoxInstance;

  /// Returns the expenses box. Creates it if it doesn't exist.
  Future<LazyBox<StopPostModel>> get _jobStopAsyncBox async {
    return _jobStopBoxInstance ??=
        await Hive.openLazyBox<StopPostModel>(_keyJobStopAsync);
  }

  /// Saves the given job as the job working on.
  /// If [job] is null, it will remove the job working on
  Future<void> setJobStopAsync(StopPostModel data) async {
    final box = await _jobStopAsyncBox;
    final key = _uuid.v4(); // Benzersiz anahtar oluştur
    return box.put(key, data);
  }

  /// Returns the job working on. If there is no job working on, it will return null.
  Future<List<StopPostModel?>> getJobStopAsync() async {
    final box = await _jobStopAsyncBox;
    final keys = box.keys.toList();
    final List<Future<StopPostModel?>> futures = [];
    for (final key in keys) {
      final future = box.get(key);
      futures.add(future);
    }
    return Future.wait(futures);
  }

  /// Removes the job working on.
  /// If [job] is null, it will remove the job working on
  ///

  Future<void> deleteJobStopAsync() async {
    final box = await _jobStopAsyncBox;
    box.clear();
  }
}
