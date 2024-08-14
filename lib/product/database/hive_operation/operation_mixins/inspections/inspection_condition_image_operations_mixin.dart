part of hive_storage_manager;

mixin InspectionConditionImageOperationsMixin {
  static final _inspectionConditionImageBox =
      Hive.box<ConditionImageResponseModel>(
          HiveDatabaseConstants.conditionImagesBox);

  /// Replace all inspection condition images in the Hive box with new data.
  ///

  Future<void> replaceInspectionConditionImagesTable(
      ConditionImageResponseModel data) async {
    await _inspectionConditionImageBox.add(data);
  }

  Future<List<ConditionImageResponseModel>> getInspectionConditionImages(
      int inspectionId) async {
    // print('inspectionId123: $inspectionId');
    final jsonList = _inspectionConditionImageBox.values.toList();
    final List<ConditionImageResponseModel> results = [];

    for (final image in jsonList) {
      if (image.jobInspectionId == inspectionId) {
        results.add(image);
      }
    }

    return results;
  }

  Future<void> updateInspectionConditionImage(
      int imageId, ConditionImageResponseModel updatedData) async {
    final key = _inspectionConditionImageBox.keys.firstWhere(
      (k) {
        final image = _inspectionConditionImageBox.get(k);
        return image?.id == imageId;
      },
      orElse: () => null,
    );

    if (key != null) {
      await _inspectionConditionImageBox.put(key, updatedData);
    }
  }

  Future<void> deleteInspectionConditionImage(int imageId) async {
    await _inspectionConditionImageBox.delete(imageId);
  }

  Future<void> clearAllInspectionConditionImages() async {
    await _inspectionConditionImageBox.clear();
  }
}
