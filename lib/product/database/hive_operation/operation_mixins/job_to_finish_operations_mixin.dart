part of hive_storage_manager;

mixin JobToFinishOperationsMixin {
  static const String _boxNameJobToFinish = 'job_for_finish';

  /// LazyBox instance for the jobs to finish box.
  LazyBox<EndJobPostModel>? _jobToFinishBoxInstance;

  /// Returns the job to finish box. Creates it if it doesn't exist.
  Future<LazyBox<EndJobPostModel>> get _jobToFinishBox async {
    return _jobToFinishBoxInstance ??=
        await Hive.openLazyBox<EndJobPostModel>(_boxNameJobToFinish);
  }

  /// If server could not sync the finish job request, it will save the job id,
  /// customer feedback and end time to finish. returns true if the job is
  /// successfully saved. false if the job is already saved.
  Future<void> saveJobToFinish(EndJobPostModel data) async {
    final box = await _jobToFinishBox;
    await box.clear();
    return await box.put(_boxNameJobToFinish, data);
  }

  /// updates the job data with given id field in the [data].
  Future<EndJobPostModel?> getJobToFinish() async {
    final box = await _jobToFinishBox;
    return box.get(_boxNameJobToFinish);
  }

  Future<bool> deleteJobToFinish() async {
    final box = await _jobToFinishBox;
    await box.clear();
    return true;

    /// updates the job data with given job id field in the [data].
  }
}
