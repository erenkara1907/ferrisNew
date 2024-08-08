part of hive_storage_manager;

mixin DamageOperationMixin {
  static final recordedDamagesBox = Hive.box<InspectionDamagePostModel>(
      HiveDatabaseConstants.recordedDamages);

  /// Get valet standards from the Hive box.
  InspectionDamagePostModel? getRecordedDamage() {
    return recordedDamagesBox.get(HiveDatabaseConstants.recordedDamages);
  }

  Future<void> setRecordedDamage(InspectionDamagePostModel userModel) async {
    await recordedDamagesBox.put(userModel.categoryId, userModel);
  }

  List<InspectionDamagePostModel> getAllRecordedDamage() {
    List<InspectionDamagePostModel> allRecordedDamage =
        recordedDamagesBox.values.toList();
    return allRecordedDamage;
  }

  InspectionDamagePostModel? getRecordedDamageById(
      {required int id, required int inspectionsId}) {
    List<InspectionDamagePostModel> allRecordedDamage =
        recordedDamagesBox.values.toList();

    for (var i = 0; i < allRecordedDamage.length; i++) {
      if (allRecordedDamage[i].categoryId == id &&
          allRecordedDamage[i].jobInspectionId == inspectionsId) {
        return allRecordedDamage[i];
      }
    }
  }

  deleteRecordedDamage(int inspectionId, int damageId) async {
    final damage = recordedDamagesBox.values.firstWhere(
      (damage) =>
          damage.jobInspectionId == inspectionId &&
          damage.categoryId == damageId,
    );
    if (damage != null) {
      await recordedDamagesBox.delete(damage.categoryId);
    }
  }

  Future<void> deleteAllRecordedDamage() async {
    await recordedDamagesBox.clear();
  }
}
