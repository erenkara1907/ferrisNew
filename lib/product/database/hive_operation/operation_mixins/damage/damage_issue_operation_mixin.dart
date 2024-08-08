part of hive_storage_manager;

mixin DamageIssueOperationMixin {
  static final _damageIssue =
      Hive.box<DamagesIssue>(HiveDatabaseConstants.damageIssueBox);

  /// Replace all damage issues in the Hive box with new data.
  /// Returns true if the operation is successful.
  Future<void> replaceDamageIssuesTable(List<DamagesIssue> data) async {
    final box = _damageIssue;

    for (final post in data) {
      await box.put(post.id, post);
    }
  }

  /// Get all damage issues related to a partId.
  Future<List<DamagesIssue>?> getDamageIssues(int partId) async {
    final box = _damageIssue;

    final jsonList = box.values.toList();

    final List<DamagesIssue> results = [];

    for (final issue in jsonList) {
      if (issue.partId == partId) {
        results.add(issue);
      }
    }
    return results;
  }

  /// Get a damage issue by its issueId.
  Future<void> deleteDamageIssues() async {
    final box = _damageIssue;
    await box.delete(HiveDatabaseConstants.damageIssueBox);
  }
}
