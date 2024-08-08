part of hive_storage_manager;

mixin InspectionsListOperationsMixin {
  static const String _keyJobInspectionsList = 'job_inspections_list';

  /// Returns the Hive box for the job working on.

  /// LazyBox instance for the expenses box.
  LazyBox<JobInspectionResponseModelItem>? _inspectionsListBoxInstance;

  /// Returns the expenses box. Creates it if it doesn't exist.
  Future<LazyBox<JobInspectionResponseModelItem>> get _jobInspectionsBox async {
    return _inspectionsListBoxInstance ??=
        await Hive.openLazyBox<JobInspectionResponseModelItem>(
            _keyJobInspectionsList);
  }

  /// Saves the given job as the job working on.
  /// If [job] is null, it will remove the job working on
  Future<void> setInspectionsListModel(
      List<JobInspectionResponseModelItem?> data) async {
    final box = await _jobInspectionsBox;

    final List<JobInspectionResponseModelItem?> previousJob =
        await getInspectionsListModel();

    await box.clear();

    // Yeni job'u kaydet
    for (final inspection in data) {
      if (inspection != null) {
        await box.put(inspection.id, inspection);
      }
    }

    print('$data inspections saved.}');
  }

  Future<void> updateInspectionsListModel(
      JobInspectionResponseModelItem data) async {
    final box = await _jobInspectionsBox;

    await box.put(data.id, data);
  }

  /// Returns the job working on. If there is no job working on, it will return null.
  Future<List<JobInspectionResponseModelItem?>>
      getInspectionsListModel() async {
    final box = await _jobInspectionsBox;
    final keys = box.keys.toList();
    final List<Future<JobInspectionResponseModelItem?>> futures = [];
    for (final key in keys) {
      final future = box.get(key);
      futures.add(future);
    }
    return Future.wait(futures);
  }

  Future<void> deleteInspectionListModel(int inspectionId) async {
    final box = await _jobInspectionsBox;
    await box.delete(inspectionId);
  }

  Future<void> deleteAllInspectionListModel() async {
    final box = await _jobInspectionsBox;
    await box.clear();
  }
}
