part of hive_storage_manager;

mixin JobWorkingOnOperationsMixin {
  static const String _keyJobWorkingOn = 'job_working_on';

  /// Returns the Hive box for the job working on.

  /// LazyBox instance for the expenses box.
  LazyBox<JobsResponseModelItem>? _workingBoxInstance;

  /// Returns the expenses box. Creates it if it doesn't exist.
  Future<LazyBox<JobsResponseModelItem>> get _jobWorkingBox async {
    return _workingBoxInstance ??=
        await Hive.openLazyBox<JobsResponseModelItem>(_keyJobWorkingOn);
  }

  /// Saves the given job as the job working on.
  /// If [job] is null, it will remove the job working on
  Future<void> setJobWorkingOn(JobsResponseModelItem data) async {
    final box = await _jobWorkingBox;

    final JobsResponseModelItem? previousJob = await getJobWorkingOn();

    if (previousJob != null) {
      await box.delete(previousJob.id);
    }

    // Yeni job'u kaydet
    await box.put(data.id, data);
  }

  Future deleteJobUpdate() async {
    final box = await _jobWorkingBox;
    await box.clear();
  }

  Future<JobsResponseModelItem?> getJobWorkingOnModel(int id) async {
    final box = await _jobWorkingBox;
    return await box.get(id);
  }

  /// Returns the job working on. If there is no job working on, it will return null.
  Future<JobsResponseModelItem?> getJobWorkingOn() async {
    final box = await _jobWorkingBox;
    return await box.get(_keyJobWorkingOn);
  }
}
