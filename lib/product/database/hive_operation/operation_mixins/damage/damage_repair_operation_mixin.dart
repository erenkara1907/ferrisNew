part of hive_storage_manager;

mixin DamageRepairOperationMixin {
  static final _damageRepair =
      Hive.box<DamagesRepair>(HiveDatabaseConstants.damageRepairBox);

  /// Replace all damage repairs in the Hive box with new data.
  /// Returns true if the operation is successful.
  Future<void> replaceDamageRepairsTable(List<DamagesRepair> data) async {
    final box = _damageRepair;

    for (final post in data) {
      await box.put(post.id, post);
    }
  }

  /// Get all damage repairs related to a failureId.
  Future<List<DamagesRepair>?> getDamageRepairs(int failureId) async {
    final box = _damageRepair;

    final jsonList = box.values.toList();

    final List<DamagesRepair> results = [];

    for (final repair in jsonList) {
      if (repair.failureId == failureId) {
        results.add(repair);
      }
    }
    return results;
  }

  /// Get a damage repair by its repairId.
  Future<void> deleteDamageRepairs() async {
    final box = _damageRepair;
    await box.delete(HiveDatabaseConstants.damageRepairBox);
  }
}
