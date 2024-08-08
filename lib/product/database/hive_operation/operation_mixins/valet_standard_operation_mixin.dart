part of hive_storage_manager;

mixin ValetStandardOperationMixin {
  static final _valetStandardBox = Hive.box<ValetStandardResponseModelItem>(
      HiveDatabaseConstants.jobValetStandardBox);

  /// Set valet standards in the Hive box.
  Future<void> setValetStandards(
      List<ValetStandardResponseModelItem> list) async {
    for (final post in list) {
      await _valetStandardBox.put(post.id, post);
    }
  }

  /// Get valet standards from the Hive box.
  Future<List<ValetStandardResponseModelItem>?> getValetStandards() async {
    final jsonList = _valetStandardBox.values.toList();
    return jsonList;
  }
}
