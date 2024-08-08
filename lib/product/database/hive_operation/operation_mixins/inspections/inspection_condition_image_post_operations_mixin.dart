part of hive_storage_manager;

mixin InspectionConditionImagePostOperationsMixin {
  static const String _keyInspectionConditionImagePostOperationsMixin =
      'inspections_condition_image_post_async';

  /// Returns the Hive box for the job working on.

  /// LazyBox instance for the expenses box.
  LazyBox<InspectionConditionImagePostModel>?
      _inspectionsConditionsPostOperations;

  /// Returns the expenses box. Creates it if it doesn't exist.
  Future<LazyBox<InspectionConditionImagePostModel>>
      get _inspectionsConditionImage async {
    return _inspectionsConditionsPostOperations ??=
        await Hive.openLazyBox<InspectionConditionImagePostModel>(
            _keyInspectionConditionImagePostOperationsMixin);
  }

  /// Saves the given job as the job working on.
  /// If [job] is null, it will remove the job working on
  Future<void> setConditionImagePostModel(
    InspectionConditionImagePostModel data,
  ) async {
    final box = await _inspectionsConditionImage;
    return box.put(data.jobInspectionId, data);
  }

  /// Returns the job working on. If there is no job working on, it will return null.
  Future<List<InspectionConditionImagePostModel?>> getConditionImagePostModel(
      int inspectionsId) async {
    final box = await _inspectionsConditionImage;
    final inspectionDetails = <InspectionConditionImagePostModel?>[];
    final keys = box.keys.toList();
    for (final key in keys) {
      final inspectionDetailsPostModel = await box.get(key);
      if (inspectionDetailsPostModel?.jobInspectionId == inspectionsId) {
        inspectionDetails.add(inspectionDetailsPostModel);
      }
    }
    return inspectionDetails;
  }

  Future<void> deleteConditionImagePostModel(int id) async {
    final box = await _inspectionsConditionImage;
    await box.delete(id);
  }
  Future<void> clearAllConditionImagePostModels() async {
    final box = await _inspectionsConditionImage;
    await box.clear();
  }
}
