part of hive_storage_manager;

mixin InspectionSignPostInspectorOperationsMixin {
  static const String _keyInspectionSignPostInspectorOperationsMixin =
      'inspectionSignPostInspector';

  /// Returns the Hive box for the job working on.

  /// LazyBox instance for the expenses box.
  LazyBox<InspectionInspectorSignPostModel>?
      _inspectionSignPostInspectorOperationsMixin;

  /// Returns the expenses box. Creates it if it doesn't exist.
  Future<LazyBox<InspectionInspectorSignPostModel>>
      get _inspectionsSignPostInspectorBox async {
    return _inspectionSignPostInspectorOperationsMixin ??=
        await Hive.openLazyBox<InspectionInspectorSignPostModel>(
            _keyInspectionSignPostInspectorOperationsMixin);
  }

  /// Saves the given job as the job working on.
  /// If [job] is null, it will remove the job working on
  Future<void> setSignInspectorPostModel(
      InspectionInspectorSignPostModel data, int inspectionsId) async {
    final box = await _inspectionsSignPostInspectorBox;
    return box.put(inspectionsId, data);
  }

  /// Returns the job working on. If there is no job working on, it will return null.
  Future<InspectionInspectorSignPostModel?> getSignInspectorPostModel(
      int inspectionsId) async {
    final box = await _inspectionsSignPostInspectorBox;

    final keys = box.keys.toList();
    for (final key in keys) {
      final future = box.get(key);
      if (key == inspectionsId) {
        return future;
      }
    }

    return null;
  }

  Future<void> clearAllSignInspectorPostModels() async {
    final box = await _inspectionsSignPostInspectorBox;
    await box.clear();
  }
}
