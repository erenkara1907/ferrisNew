part of hive_storage_manager;

mixin DamageAssetsOperationMixin {
  static final _damageAssets =
      Hive.box<DamageAssetsModel>(HiveDatabaseConstants.damageAssetsBox);

  /// Replace all damage categories in the Hive box with new data.
  /// Returns true if the operation is successful.

  Future<void> addDamageAssetsToTable(List<DamageAssetsModel> data) async {
    final box = _damageAssets;

    for (final post in data) {
      await box.put(post.id, post);
    }
  }

  /// Get all damage categories from the Hive box.
  Future<List<DamageAssetsModel?>> getDamageAssets() async {
    final box = _damageAssets;

    final keys = box.keys.toList();

    for (final key in keys) {
      box.get(key);
    }
    return keys.map((key) => box.get(key)).toList();
  }

  Future<List<DamageAssetsModel>> getDamageAssetsByIds(
      List<int> standardIds) async {
    final box = _damageAssets;
    final keys = box.keys.toList();
    List<DamageAssetsModel> matchingAssets = [];

    for (final key in keys) {
      final damageAssets = box.get(key);
      if (damageAssets != null && standardIds.contains(damageAssets.id)) {
        matchingAssets.add(damageAssets);
      }
    }

    return matchingAssets;
  }

  /// Get a damage category by its categoryId.
  Future<void> deleteDamageAssets() async {
    final box = _damageAssets;
    await box.delete(HiveDatabaseConstants.damageAssetsBox);
  }
}
