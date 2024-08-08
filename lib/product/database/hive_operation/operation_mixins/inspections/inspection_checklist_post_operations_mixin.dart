part of hive_storage_manager;

mixin InspectionChecklistPostOperationsMixin {
  static const String _keyInspectionChecklistPostOperations =
      'inspection_checklist_post_async';

  /// Returns the Hive box for the job working on.

  /// LazyBox instance for the expenses box.
  LazyBox<InspectionChecklistPostModel>? _inspectionChecklistPostOperations;

  /// Returns the expenses box. Creates it if it doesn't exist.
  Future<LazyBox<InspectionChecklistPostModel>>
      get _inspectionsChecklistBox async {
    return _inspectionChecklistPostOperations ??=
        await Hive.openLazyBox<InspectionChecklistPostModel>(
            _keyInspectionChecklistPostOperations);
  }

  /// Saves the given job as the job working on.
  /// If [job] is null, it will remove the job working on
  Future<void> setChecklistPostModel(InspectionChecklistPostModel data) async {
    final box = await _inspectionsChecklistBox;
    await box.clear();
    return box.put(data.jobInspectionId, data);
  }

  /// Returns the job working on. If there is no job working on, it will return null.
  Future<List<InspectionChecklistPostModel?>> getChecklistPostModel(
      int inspectionsId) async {
    final box = await _inspectionsChecklistBox;
    final inspectionDetails = <InspectionChecklistPostModel?>[];
    final keys = box.keys.toList();
    for (final key in keys) {
      final inspectionDetailsPostModel = await box.get(key);
      if (inspectionDetailsPostModel?.jobInspectionId == inspectionsId) {
        inspectionDetails.add(inspectionDetailsPostModel);
      }
    }
    return inspectionDetails;
  }

  /// Deletes the job working on.

  Future<void> deleteChecklistPostModel(int inspectionsId) async {
    final box = await _inspectionsChecklistBox;
    final keys = box.keys.toList();
    for (final key in keys) {
      final inspectionDetailsPostModel = await box.get(key);
      if (inspectionDetailsPostModel?.jobInspectionId == inspectionsId) {
        await box.delete(key);
      }
    }
  }

  Future<void> clearAllChecklistPostModels() async {
    final box = await _inspectionsChecklistBox;
    await box.clear();
  }
}
