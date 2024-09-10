part of hive_storage_manager;

mixin InspectionConditionImageOperationsMixin {
  static final _inspectionConditionImageBox =
      Hive.box<ConditionImageResponseModel>(
          HiveDatabaseConstants.conditionImagesBox);

  /// Replace all inspection condition images in the Hive box with new data.
  ///

  // Future<void> replaceInspectionConditionImagesTable(
  //     ConditionImageResponseModel data) async {
  //   await _inspectionConditionImageBox.put(data.id, data);
  // }

  Future<void> replaceInspectionConditionImagesTable(
      ConditionImageResponseModel data) async {
    final box = _inspectionConditionImageBox;
    final keys = box.keys.toList();

    // Mevcut verilerin sayısını belirle
    int count = 0;
    for (final key in keys) {
      final conditionImage = box.get(key);
      if (conditionImage?.jobInspectionId == data.jobInspectionId) {
        count++;
      }
    }

    // Yeni veriyi, benzersiz bir anahtar ile sakla
    final newKey = '${data.jobInspectionId}_$count';
    await box.put(newKey, data);
  }

  Future<List<ConditionImageResponseModel>> getInspectionConditionImages(
      int inspectionId) async {
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

  // Future<void> deleteInspectionConditionImage(int imageId) async {
  //   await _inspectionConditionImageBox.delete(imageId);
  // }

  Future<void> deleteInspectionConditionImage(
      {required int jobInspectionId, required int conditionId}) async {
    final box = _inspectionConditionImageBox;
    final keys = box.keys.toList();

    // İlgili conditionId ve jobInspectionId ile eşleşen veriyi sil
    for (final key in keys) {
      final conditionImage = box.get(key);
      if (conditionImage?.jobInspectionId == jobInspectionId &&
          conditionImage?.id == conditionId) {
        await box.delete(key);
        break; // Eşleşen ilk kaydı sildikten sonra döngüyü sonlandır
      }
    }
  }

  Future<void> clearAllInspectionConditionImages() async {
    await _inspectionConditionImageBox.clear();
  }
}
