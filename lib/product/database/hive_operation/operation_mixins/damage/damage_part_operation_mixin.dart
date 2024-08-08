part of hive_storage_manager;

mixin DamagePartOperationMixin {
  static final _damagePart =
      Hive.box<DamagesPart>(HiveDatabaseConstants.damagePartBox);

  /// Replace all damage parts in the Hive box with new data.
  /// Returns true if the operation is successful.
  Future<void> replaceDamagePartsTable(List<DamagesPart> data) async {
    final box = _damagePart;

    for (final post in data) {
      await box.put(post.id, post);
    }
  }

  /// Get all damage parts related to a categoryId.
  Future<List<DamagesPart>?> getDamageParts(int categoryId) async {
    final box = _damagePart;

    // Retrieve the values (DamagesPart objects) instead of keys
    final jsonList = box.values.toList();

    final List<DamagesPart> results = [];
    for (final part in jsonList) {
      if (part.categoryId == categoryId) {
        results.add(part);
      }
    }

    return results;
  }

  /// Get a damage part by its partId.
  Future<void> deleteDamageParts() async {
    final box = _damagePart;
    await box.delete(HiveDatabaseConstants.damagePartBox);
  }
}
