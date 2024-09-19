part of hive_storage_manager;

mixin DamageCombinationOperationMixin {
  static final _damageCombination = Hive.box<DamageCombinationModel>(HiveDatabaseConstants.damageCombinationBox);
  static final _damageCombinationScore = Hive.box<ScoreModel>(HiveDatabaseConstants.damageCombinationScoreBox);

  /// Replace all damage categories in the Hive box with new data.
  /// Returns true if the operation is successful.

  Future<void> addDamageCombinationToTable(List<DamageCombinationModel> data) async {
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

  Future<List<DamageCombinationModel>> getDamageCombinationByIds(List<int> standardIds) async {
    final box = _damageCombination;
    final keys = box.keys.toList();
    List<DamageCombinationModel> matchingAssets = [];

    for (final key in keys) {
      final damageCombination = box.get(key);
      if (damageCombination != null && standardIds.contains(damageCombination.id)) {
        matchingAssets.add(damageCombination);
      }
    }

    return matchingAssets;
  }

  // Future<void> addScore({
  //   required int score,
  //   required int inspectionId,
  // }) async {
  //   final box = _damageCombinationScore;

  //   // Create a unique key based on repairId and inspectionId
  //   final uniqueKey = '$inspectionId';

  //   // Retrieve the existing ScoreModel for the unique key
  //   final existingScoreModel = box.get(uniqueKey);

  //   print("add existingScoreModel: ${existingScoreModel?.score}");

  //   if (existingScoreModel != null) {
  //     // Update the existing ScoreModel's score
  //     final updatedScoreModel = existingScoreModel.copyWith(
  //       score: existingScoreModel.score + score,
  //     );

  //     // Store the updated ScoreModel in Hive
  //     await box.put(uniqueKey, updatedScoreModel);
  //   } else {
  //     // Create a new ScoreModel and store it
  //     final newScoreModel = ScoreModel(
  //       score: score,
  //       inspectionId: inspectionId,
  //     );

  //     print("add newScoreModel: ${newScoreModel.score}");

  //     await box.put(uniqueKey, newScoreModel);
  //   }
  // }

  Future<void> addScore({
    required int score,
    required int inspectionId,
  }) async {
    final box = _damageCombinationScore;

    // Create a unique key based on repairId and inspectionId
    final uniqueKey = '$inspectionId';

    // Retrieve the existing ScoreModel for the unique key
    final existingScoreModel = box.get(uniqueKey);

    if (existingScoreModel != null) {
      // Update the existing ScoreModel's score
      final updatedScoreModel = existingScoreModel.copyWith(
        score: existingScoreModel.score + score,
      );

      // Store the updated ScoreModel in Hive
      await box.put(uniqueKey, updatedScoreModel);
    } else {
      // Create a new ScoreModel and store it
      final newScoreModel = ScoreModel(
        score: score,
        inspectionId: inspectionId,
      );

      await box.put(uniqueKey, newScoreModel);
    }
  }

  Future<int?> getScore({
    required int inspectionId,
  }) async {
    final box = _damageCombinationScore;

    // Create a unique key based on repairId and inspectionId
    final uniqueKey = '$inspectionId';

    // Retrieve the ScoreModel for the unique key
    final scoreModel = box.get(uniqueKey);

    // Return the score if the ScoreModel is found, otherwise return null
    return scoreModel?.score;
  }

  Future<void> deleteScore({
    required int scoreToRemove,
    required int inspectionId,
  }) async {
    final box = _damageCombinationScore;

    // Create a unique key based on inspectionId
    final uniqueKey = '$inspectionId';

    // Retrieve the existing ScoreModel for the unique key
    final existingScoreModel = box.get(uniqueKey);

    if (existingScoreModel != null) {
      // Calculate the new score by subtracting the score to remove
      final newScore = existingScoreModel.score - scoreToRemove;

      // Ensure that the score does not drop below zero
      final updatedScore = newScore < 0 ? 0 : newScore;

      // Create an updated ScoreModel
      final updatedScoreModel = existingScoreModel.copyWith(
        score: updatedScore,
      );

      // Store the updated ScoreModel in Hive
      await box.put(uniqueKey, updatedScoreModel);

      print("Score updated to: ${updatedScoreModel.score}");
    } else {
      print("No ScoreModel found with key $uniqueKey.");
    }
  }

  Future<void> deleteAllScores() async {
    final box = _damageCombinationScore;
    await box.clear();
  }
}
