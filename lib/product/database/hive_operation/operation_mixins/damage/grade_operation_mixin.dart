part of hive_storage_manager;

mixin GradeOperationMixin {
  static final _grade = Hive.box<GradeModel>(HiveDatabaseConstants.gradeBox);

  /// Replace all damage categories in the Hive box with new data.
  /// Returns true if the operation is successful.

  Future<void> addGradeToTable(List<GradeModel> data) async {
    final box = _grade;

    for (final post in data) {
      await box.put(post.id, post);
    }
  }

  /// Get all damage categories from the Hive box.
  Future<List<GradeModel?>> getGrades() async {
    final box = _grade;

    final keys = box.keys.toList();

    for (final key in keys) {
      box.get(key);
    }
    return keys.map((key) => box.get(key)).toList();
  }

  Future<List<GradeModel>> getGradeByIds(List<int> standardIds) async {
    final box = _grade;
    final keys = box.keys.toList();
    List<GradeModel> matchingAssets = [];

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
  Future<void> deleteGrade() async {
    final box = _grade;
    await box.delete(HiveDatabaseConstants.gradeBox);
  }

  /// Set a specific GradeModel's gradeId by its ID.
  Future<void> setGradeId(String id, String gradeId) async {
    final box = _grade;
    final grade = box.get(id);

    if (grade != null) {
      // Create a new instance of GradeModel with the updated gradeId.
      final updatedGrade = grade.copyWith(gradeId: gradeId);
      await box.put(id, updatedGrade);
    }
  }
}
