part of hive_storage_manager;

mixin ItemChecklistOperationMixin {
  static final _jopUpdateBox = Hive.box<InspectionChecklistPostModel>(
      HiveDatabaseConstants.itemcheckListBox);

  /// Get checklist from the Hive box using inspectionId as the key.
  InspectionChecklistPostModel? getItemCheckList(int inspectionId) {
    return _jopUpdateBox.get(inspectionId);
  }

  /// Save checklist to the Hive box using inspectionId as the key.
  Future<void> setItemCheckList(InspectionChecklistPostModel model) async {
    if (_jopUpdateBox.containsKey(model.jobInspectionId)) {
      await _jopUpdateBox.delete(model.jobInspectionId);
    }

    // Add the new entry
    await _jopUpdateBox.put(model.jobInspectionId, model);
  }

  Future<void> deleteItemCheckList(int inspectionId) async {
    await _jopUpdateBox.delete(inspectionId);
  }

  Future<void> clearItemCheckList() async {
    await _jopUpdateBox.clear();
  }
}
