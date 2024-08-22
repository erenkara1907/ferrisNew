part of hive_storage_manager;

mixin GradeRuleOperationMixin {
  static final _gradeRule =
      Hive.box<GradeRuleModel>(HiveDatabaseConstants.gradeRuleBox);

  /// Replace all damage categories in the Hive box with new data.
  /// Returns true if the operation is successful.

  Future<void> addGradeRuleToTable(List<GradeRuleModel> data) async {
    final box = _gradeRule;

    for (final post in data) {
      await box.put(post.id, post);
    }
  }

  /// Get all damage categories from the Hive box.
  Future<List<GradeRuleModel?>> getGradeRules() async {
    final box = _gradeRule;

    final keys = box.keys.toList();

    for (final key in keys) {
      box.get(key);
    }
    return keys.map((key) => box.get(key)).toList();
  }

  Future<List<GradeRuleModel>> getGradeRuleByIds(List<int> standardIds) async {
    final box = _gradeRule;
    final keys = box.keys.toList();
    List<GradeRuleModel> matchingAssets = [];

    for (final key in keys) {
      final damageCombination = box.get(key);
      if (damageCombination != null &&
          standardIds.contains(damageCombination.gradeId)) {
        matchingAssets.add(damageCombination);
      }
    }

    return matchingAssets;
  }

  /// Get a damage category by its categoryId.
  Future<void> deleteGradeRule() async {
    final box = _gradeRule;
    await box.delete(HiveDatabaseConstants.gradeRuleBox);
  }
}
