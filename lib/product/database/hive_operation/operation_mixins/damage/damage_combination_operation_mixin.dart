part of hive_storage_manager;

mixin DamageCombinationOperationMixin {
  static final _damageCombination = Hive.box<DamageCombinationModel>(
      HiveDatabaseConstants.damageCombinationBox);

  /// Replace all damage categories in the Hive box with new data.
  /// Returns true if the operation is successful.

  Future<void> addDamageCombinationToTable(
      List<DamageCombinationModel> data) async {
    final box = _damageCombination;

    for (final post in data) {
      await box.put(post.id, post);
    }
  }

  /// Get all damage categories from the Hive box.
  Future<List<DamageCombinationModel?>> getDamageCombination() async {
    final box = _damageCombination;

    final keys = box.keys.toList();

    for (final key in keys) {
      box.get(key);
    }
    return keys.map((key) => box.get(key)).toList();
  }

  Future<List<DamageCombinationModel>> getDamageCombinationByIds(
      List<int> standardIds) async {
    final box = _damageCombination;
    final keys = box.keys.toList();
    List<DamageCombinationModel> matchingAssets = [];

    for (final key in keys) {
      final damageCombination = box.get(key);
      if (damageCombination != null &&
          standardIds.contains(damageCombination.id)) {
        matchingAssets.add(damageCombination);
      }
    }

    return matchingAssets;
  }

  /// Get a damage category by its categoryId.
  Future<void> deleteDamageCombination() async {
    final box = _damageCombination;
    await box.delete(HiveDatabaseConstants.damageCombinationBox);
  }
}
