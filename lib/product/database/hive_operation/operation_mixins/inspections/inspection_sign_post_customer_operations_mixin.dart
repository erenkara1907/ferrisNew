part of hive_storage_manager;

mixin InspectionSignPostCustomerOperationsMixin {
  static const String _keyInspectionSignCustomerPostOperationsMixin =
      'inspectionSignPostCustomerOperationsMixin';

  /// Returns the Hive box for the job working on.

  /// LazyBox instance for the expenses box.
  LazyBox<InspectionCustomerSignPostModel>?
      _inspectionsSignCustomerPostOperations;

  /// Returns the expenses box. Creates it if it doesn't exist.
  Future<LazyBox<InspectionCustomerSignPostModel>>
      get _inspectionsSignCustomerBox async {
    return _inspectionsSignCustomerPostOperations ??=
        await Hive.openLazyBox<InspectionCustomerSignPostModel>(
            _keyInspectionSignCustomerPostOperationsMixin);
  }

  /// Saves the given job as the job working on.
  /// If [job] is null, it will remove the job working on
  Future<void> setSignCustomerPostModel(
      InspectionCustomerSignPostModel data, int inspectionsId) async {
    final box = await _inspectionsSignCustomerBox;
    return box.put(inspectionsId, data);
  }

  /// Returns the job working on. If there is no job working on, it will return null.
  Future<InspectionCustomerSignPostModel?> getSignCustomerPostModel(
      int inspectionsId) async {
    final box = await _inspectionsSignCustomerBox;

    final keys = box.keys.toList();
    for (final key in keys) {
      final future = box.get(key);
      if (key == inspectionsId) {
        return future;
      }
    }

    return null;
  }

  Future<void> clearAllSignCustomerPostModels() async {
    // Use the already opened box
    final box = await _inspectionsSignCustomerBox;
    await box.clear();
  }
}
