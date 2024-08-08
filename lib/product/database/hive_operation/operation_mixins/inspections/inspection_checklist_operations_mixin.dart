part of hive_storage_manager;

mixin InspectionChecklistOperationsMixin {
  static final _inspectionChecklistBox = Hive.box<ChecklistResponseModelItem>(
    HiveDatabaseConstants.checklistBox,
  );

  /// Adds or updates the given inspection checklist to the inspection checklist box.
  Future<void> putInspectionChecklist(
    List<ChecklistResponseModelItem> inspectionChecklist,
  ) async {
    for (final inspection in inspectionChecklist) {
      await _inspectionChecklistBox.put(inspection.id, inspection);
    }
  }

  /// Returns a list of all inspection checklists in the inspection checklist saved.
  /// If [inspectionId] is provided, only the inspection checklists with the given
  /// inspection id are returned.
  Future<List<ChecklistResponseModelItem>?> getInspectionChecklists() async {
    final inspectionChecklist = _inspectionChecklistBox.values.toList();
    return inspectionChecklist;
  }

  /// Deletes the inspection checklist with the given id from the inspection checklist box.
  Future<void> deleteInspectionChecklist() async {
    await _inspectionChecklistBox.clear();
  }
}
