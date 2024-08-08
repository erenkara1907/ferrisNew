part of hive_storage_manager;

mixin GetDamageOperationMixin {
  static final _valetStandardBox =
      Hive.box<DamageResponseModel>(HiveDatabaseConstants.getDamage);

  /// Set valet standards in the Hive box.
  Future<void> setGetDamage(DamageResponseModel damage) async {
    // Using put instead of add to set with a specific key if necessary
    await _valetStandardBox.put(damage.id, damage);
  }

  /// Get valet standards from the Hive box.
  Future<List<DamageResponseModel>> getGetDamage(int inspectionId) async {
    final results = _valetStandardBox.values
        .where((damage) => damage.jobInspectionId == inspectionId)
        .toList();
    // debugPrint('results: $results');
    return results;
  }

  /// Delete a damage entry from the Hive box.
  Future<void> deleteGetDamage(int inspectionId, int damageId) async {
    try {
      // Find the key of the damage entry to delete
      final key = _valetStandardBox.keys.firstWhere(
        (key) {
          final damage = _valetStandardBox.get(key);
          return damage?.jobInspectionId == inspectionId &&
              damage?.id == damageId;
        },
        orElse: () => null,
      );

      if (key != null) {
        debugPrint(
            'Deleting damage with id: $damageId and inspectionId: $inspectionId');
        await _valetStandardBox.delete(key);
      } else {
        debugPrint(
            'No damage found with id: $damageId and inspectionId: $inspectionId');
      }
    } catch (e) {
      debugPrint('Error deleting damage: $e');
    }
  }
}
