part of hive_storage_manager;

mixin ConditionImageOperationMixin {
  static final _conditionImagesBox = Hive.box<ConditionImageResponseModel>(
      HiveDatabaseConstants.conditionImage);

  /// Get all condition images for a specific jobInspectionId
  List<ConditionImageResponseModel> getConditionImages(int jobInspectionId) {
    return _conditionImagesBox.values
        .where((image) => image.jobInspectionId == jobInspectionId)
        .toList();
  }

  /// Add a new condition image to the box
  Future<void> addConditionImage(ConditionImageResponseModel userModel) async {
    await _conditionImagesBox.add(userModel);
  }

  /// Delete a condition image by jobInspectionId and model
  Future<void> deleteConditionImage(int jobInspectionId, int index) async {
    final result = _conditionImagesBox.values
        .where((image) => image.jobInspectionId == jobInspectionId)
        .toList();

    // Get the actual key of the item to delete
    final keyToDelete = _conditionImagesBox.keys
        .cast<int>()
        .elementAt(_conditionImagesBox.values.toList().indexOf(result[index]));

    // Delete the item from the box using the key
    await _conditionImagesBox.delete(keyToDelete);
  }

  /// Delete all condition images for a specific jobInspectionId
  Future<void> deleteAllConditionImages(int jobInspectionId) async {
    final keys = _conditionImagesBox.keys.cast<int>().toList();
    final images = _conditionImagesBox.values.toList();

    for (int i = 0; i < images.length; i++) {
      if (images[i].jobInspectionId == jobInspectionId) {
        await _conditionImagesBox.delete(keys[i]);
      }
    }
  }

  Future<void> clearAllConditionImages() async {
    await _conditionImagesBox.clear();
  }
}
