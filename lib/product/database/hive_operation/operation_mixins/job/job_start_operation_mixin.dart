part of hive_storage_manager;

mixin JobStartOperationMixin {
  static final _job =
      Hive.box<JobStartModel>(HiveDatabaseConstants.jobStartModelBox);

  /// Replace all damage categories in the Hive box with new data.
  /// Returns true if the operation is successful.

  Future<void> addJobToTable(List<JobStartModel> data) async {
    final box = _job;

    for (final post in data) {
      await box.put(post.id, post);
    }
  }

  /// Get all damage categories from the Hive box.
  Future<List<JobStartModel?>> getJobs() async {
    final box = _job;

    final keys = box.keys.toList();

    for (final key in keys) {
      box.get(key);
    }
    return keys.map((key) => box.get(key)).toList();
  }

  Future<List<JobStartModel>> getJobByIds(List<int> standardIds) async {
    final box = _job;
    final keys = box.keys.toList();
    List<JobStartModel> matchingAssets = [];

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
  Future<void> deleteJob() async {
    final box = _job;
    await box.delete(HiveDatabaseConstants.jobStartModelBox);
  }

  /// Set a specific GradeModel's gradeId by its ID.
  // Future<void> setGradeId(String id, String gradeId) async {
  //   final box = _job;
  //   final grade = box.get(id);

  //   if (grade != null) {
  //     // Create a new instance of GradeModel with the updated gradeId.
  //     final updatedGrade = grade.copyWith(gradeId: gradeId);
  //     await box.put(id, updatedGrade);
  //   }
  // }
}
