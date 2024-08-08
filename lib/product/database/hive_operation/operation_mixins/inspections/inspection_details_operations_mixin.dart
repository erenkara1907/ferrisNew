part of hive_storage_manager;

mixin InspectionDetailsOperationsMixin {
  static const String _boxNameInspectionDetails = 'inspection_details';

  /// LazyBox instance for the inspection details box.
  LazyBox<InspectionDetailsPostModel>? _inspectionDetailsBoxInstance;

  /// Returns the inspection details box. Creates it if it doesn't exist.
  Future<LazyBox<InspectionDetailsPostModel>> get _inspectionDetailsBox async {
    return _inspectionDetailsBoxInstance ??=
        await Hive.openLazyBox<InspectionDetailsPostModel>(
            _boxNameInspectionDetails);
  }

  /// Adds or updates the given inspection details to the inspection details box.
  Future<void> putInspectionDetails(
    InspectionDetailsPostModel inspectionDetails,
  ) async {
    final box = await _inspectionDetailsBox;

    return box.put(inspectionDetails.inspectionId, inspectionDetails);
  }

  /// Returns the inspection details with the given id from the inspection
  /// details box.
  Future<List<InspectionDetailsPostModel?>> getInspectionDetails(
      int inspectionsId) async {
    final box = await _inspectionDetailsBox;
    final inspectionDetails = <InspectionDetailsPostModel?>[];
    final keys = box.keys.toList();
    for (final key in keys) {
      final inspectionDetailsPostModel = await box.get(key);
      if (inspectionDetailsPostModel?.inspectionId == inspectionsId) {
        inspectionDetails.add(inspectionDetailsPostModel);
      }
    }
    return inspectionDetails;
  }

  /// Deletes the inspection details with the given id from the inspection details box.
  Future<void> removeInspectionDetailsRecord(int inspectionId) async {
    final box = await _inspectionDetailsBox;
    final keys = box.keys.toList();
    for (final key in keys) {
      await box.delete(key);
    }
  }

  Future<void> clearAllInspectionDetails() async {
    final box = await _inspectionDetailsBox;
    await box.clear();
  }
}
