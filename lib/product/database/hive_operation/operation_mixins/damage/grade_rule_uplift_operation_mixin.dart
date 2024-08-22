part of hive_storage_manager;

mixin GradeRuleUpliftOperationMixin {
  static final _gradeRuleUplift =
      Hive.box<GradeRuleUpliftModel>(HiveDatabaseConstants.gradeRuleUpliftBox);

  /// Replace all damage categories in the Hive box with new data.
  /// Returns true if the operation is successful.

  Future<void> addGradeRuleUpliftToTable(
      List<GradeRuleUpliftModel> data) async {
    final box = _gradeRuleUplift;

    for (final post in data) {
      await box.put(post.gradeRuleId, post);
    }
  }

  /// Get all damage categories from the Hive box.
  Future<List<GradeRuleUpliftModel?>> getGradeRuleUplifts() async {
    final box = _gradeRuleUplift;

    final keys = box.keys.toList();

    for (final key in keys) {
      box.get(key);
    }
    return keys.map((key) => box.get(key)).toList();
  }

  Future<List<GradeRuleUpliftModel>> getGradeRuleUpliftByIds(
      List<int> standardIds) async {
    final box = _gradeRuleUplift;
    final keys = box.keys.toList();
    List<GradeRuleUpliftModel> matchingAssets = [];

    for (final key in keys) {
      final damageCombination = box.get(key);
      if (damageCombination != null &&
          standardIds.contains(damageCombination.gradeRuleId)) {
        matchingAssets.add(damageCombination);
      }
    }

    return matchingAssets;
  }

  /// Get a damage category by its categoryId.
  Future<void> deleteGradeRuleUplift() async {
    final box = _gradeRuleUplift;
    await box.delete(HiveDatabaseConstants.gradeRuleUpliftBox);
  }
}
