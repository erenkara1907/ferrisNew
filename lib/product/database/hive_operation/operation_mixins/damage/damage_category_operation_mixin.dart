part of hive_storage_manager;

mixin DamageCategoryOperationMixin {
  static final _damageCategory =
      Hive.box<DamagesCategory>(HiveDatabaseConstants.damageCategoryBox);

  /// Replace all damage categories in the Hive box with new data.
  /// Returns true if the operation is successful.
  Future<void> replaceDamageCategoriesTable(List<DamagesCategory> data) async {
    final box = _damageCategory;

    for (final post in data) {
      await box.put(post.id, post);
    }
  }

  /// Get all damage categories from the Hive box.
  Future<List<DamagesCategory?>> getDamageCategories() async {
    final box = _damageCategory;
    final keys = box.keys.toList();

    for (final key in keys) {
      box.get(key);
    }
    return keys.map((key) => box.get(key)).toList();
  }

  Future<DamagesCategory?> getDamageCategoryById(int categoryId) async {
    final box = _damageCategory;
    final keys = box.keys.toList();

    for (final key in keys) {
      final damageCategory = box.get(key);
      if (damageCategory!.id == categoryId) {
        return damageCategory;
      }
    }

    return null;
  }

  /// Get a damage category by its categoryId.
  Future<void> deleteDamageCategories() async {
    final box = _damageCategory;
    await box.delete(HiveDatabaseConstants.damageCategoryBox);
  }
}
