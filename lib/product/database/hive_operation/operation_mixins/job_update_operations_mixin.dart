part of hive_storage_manager;

mixin JobUpdateOperationsMixin {
  static const String _boxNameJobUpdate = 'local_job_update';

  /// LazyBox instance for the job updates box.
  LazyBox<UpdateJobStatusPostModel>? _jobUpdateBoxInstance;
  static final Uuid _uuid = Uuid();

  /// Returns the job update box. Creates it if it doesn't exist.
  Future<LazyBox<UpdateJobStatusPostModel>> get _jobUpdateBox async {
    return _jobUpdateBoxInstance ??=
        await Hive.openLazyBox<UpdateJobStatusPostModel>(_boxNameJobUpdate);
  }

  /// saves give [data] with given [uuid]. if [uuid] already exists in storage,
  /// updates the the already saved data.
  Future insertJobUpdate(UpdateJobStatusPostModel data) async {
    final box = await _jobUpdateBox;
    final key = _uuid.v4(); // Benzersiz anahtar oluştur
    return box.put(key, data);
  }

  Future<List<UpdateJobStatusPostModel?>> getJobUpdate() async {
    final box = await _jobUpdateBox;
    final keys = box.keys.toList();
    final List<Future<UpdateJobStatusPostModel?>> futures = [];
    for (final key in keys) {
      final future = box.get(key);
      futures.add(future);
    }
    return Future.wait(futures);
  }

  Future deleteJobUpdates() async {
    final box = await _jobUpdateBox;
    await box.clear();
  }
}
