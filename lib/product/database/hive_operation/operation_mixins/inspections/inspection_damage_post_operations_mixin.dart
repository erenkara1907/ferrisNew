part of hive_storage_manager;

mixin InspectionDamagePostOperationsMixin {
  static const String _keyInspectionDamagePostOperationsMixin =
      'inspectionDamagePost';

  /// Returns the Hive box for the job working on.

  /// LazyBox instance for the expenses box.
  LazyBox<InspectionDamagePostModel>? _inspectionsDamagePostOperations;

  /// Returns the expenses box. Creates it if it doesn't exist.
  Future<LazyBox<InspectionDamagePostModel>> get _inspectionsDamageBox async {
    return _inspectionsDamagePostOperations ??=
        await Hive.openLazyBox<InspectionDamagePostModel>(
            _keyInspectionDamagePostOperationsMixin);
  }

  /// Saves the given job as the job working on.
  /// If [job] is null, it will remove the job working on
  // Future<void> setDamagePostModel(
  //   InspectionDamagePostModel data,
  // ) async {
  //   final box = await _inspectionsDamageBox;

  //   return box.put(data.jobInspectionId, data);
  // }

  Future<void> setDamagePostModel(InspectionDamagePostModel data) async {
    final box = await _inspectionsDamageBox;
    final keys = box.keys.toList();

    // Mevcut verilerin sayısını belirle
    int count = 0;
    for (final key in keys) {
      final inspectionDetailsPostModel = await box.get(key);
      if (inspectionDetailsPostModel?.jobInspectionId == data.jobInspectionId) {
        count++;
      }
    }

    // Yeni veriyi, benzersiz bir anahtar ile sakla
    final newKey = '${data.jobInspectionId}_$count';
    await box.put(newKey, data);
  }

  /// Returns the job working on. If there is no job working on, it will return null.
  Future<List<InspectionDamagePostModel?>> getDamagePostModel(
      int inspectionsId) async {
    final box = await _inspectionsDamageBox;
    final inspectionDetails = <InspectionDamagePostModel?>[];
    final keys = box.keys.toList();
    for (final key in keys) {
      final inspectionDetailsPostModel = await box.get(key);
      if (inspectionDetailsPostModel?.jobInspectionId == inspectionsId) {
        inspectionDetails.add(inspectionDetailsPostModel);
      }
    }
    return inspectionDetails;
  }

  Future<InspectionDamagePostModel?> getDamagePostModelById(
      int inspectionsId) async {
    final box = await _inspectionsDamageBox;
    final keys = box.keys.toList();
    for (final key in keys) {
      final inspectionDetailsPostModel = await box.get(key);
      if (inspectionDetailsPostModel?.jobInspectionId == inspectionsId) {
        return inspectionDetailsPostModel;
      }
    }
    return null;
  }

  Future<void> deleteDamagePostModel(int inspectionsId) async {
    final box = await _inspectionsDamageBox;
    final keys = box.keys.toList();
    for (final key in keys) {
      final inspectionDetailsPostModel = await box.get(key);
      if (inspectionDetailsPostModel?.jobInspectionId == inspectionsId) {
        await box.delete(key);
      }
    }
  }

  Future<void> clearAllDamagePostModels() async {
    final box = await _inspectionsDamageBox;
    await box.clear();
  }
}
