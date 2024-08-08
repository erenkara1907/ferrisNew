part of hive_storage_manager;

mixin DamageFailureOperationMixin {
  static final _damageFailure =
      Hive.box<DamagesFailure>(HiveDatabaseConstants.damageFailureBox);

  /// Replace all damage failures in the Hive box with new data.
  /// Returns true if the operation is successful.
  Future<void> replaceDamageFailuresTable(List<DamagesFailure> data) async {
    final box = _damageFailure;

    for (final post in data) {
      await box.put(post.id, post);
    }
  }

  /// Get all damage failures related to an issueId.
  Future<List<DamagesFailure>?> getDamageFailures(int issueId) async {
    final box = _damageFailure;

    final jsonList = box.values.toList();

    final List<DamagesFailure> results = [];

    for (final failure in jsonList) {
      if (failure.issueId == issueId) {
        results.add(failure);
      }
    }
    return results;
  }

  /// Get a damage failure by its failureId.
  Future<void> deleteDamageFailures() async {
    final box = _damageFailure;
    await box.delete(HiveDatabaseConstants.damageFailureBox);
  }
}
