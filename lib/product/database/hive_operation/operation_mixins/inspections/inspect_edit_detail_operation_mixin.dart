part of hive_storage_manager;

mixin InspectEditDetail {
  static final _inspectEditDetailBox =
      Hive.box<JobInspectionResponseModelItem>(
          HiveDatabaseConstants.inspectEditDetail);

  /// Get all condition images for a specific jobInspectionId
  List<JobInspectionResponseModelItem> getInspectEditDetail(
      int jobInspectionId) {
    return _inspectEditDetailBox.values
        .where((model) => model.id == jobInspectionId)
        .toList();
  }

  /// Add a new condition image to the box
  Future<void> addInspectEditDetail(
      JobInspectionResponseModelItem model) async {
    if (model.id != null) {
      await _inspectEditDetailBox.put(HiveDatabaseConstants.inspectEditDetail, model);
    } else {
      throw ArgumentError('jobInspectionId cannot be null');
    }
  }

  Future<void> clearAllInspectEditDetail() async {
    await _inspectEditDetailBox.clear();
  }
}
