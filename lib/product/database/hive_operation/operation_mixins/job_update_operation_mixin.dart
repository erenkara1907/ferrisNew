part of hive_storage_manager;

mixin JopUpdateOperationMixin {
  static final _jopUpdateBox =
      Hive.box<UpdateJobStatusPostModel>(HiveDatabaseConstants.jobUpdate);

  /// Get valet standards from the Hive box.
  UpdateJobStatusPostModel? getJopUpdatePage() {
    return _jopUpdateBox.get(HiveDatabaseConstants.jobUpdate);
  }

  Future<void> setJopUpdates(UpdateJobStatusPostModel userModel) async {
    await _jopUpdateBox.put(HiveDatabaseConstants.jobUpdate, userModel);
  }

  Future<void> deleteJopUpdates() async {
    await _jopUpdateBox.clear();
  }
}
