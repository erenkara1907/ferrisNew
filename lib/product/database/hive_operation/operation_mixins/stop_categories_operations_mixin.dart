part of hive_storage_manager;

mixin StopCategoriesOperationsMixin {
  static final stopCategoryBox = Hive.box<StopCategoriesResponseModelItem>(
      HiveDatabaseConstants.jobStopCategoriesBox);

  /// Returns the Hive box for stop categories.

  /// Set stop categories in the Hive box.
  Future<void> setStopCategories(
      List<StopCategoriesResponseModelItem> stopCategories) async {
    for (final post in stopCategories) {
      await stopCategoryBox.put(post.id, post);
    }
  }

  /// Get stop categories from the Hive box.
  List<StopCategoriesResponseModelItem> getStopCategories() {
    final jsonList = stopCategoryBox.values.toList();
    return jsonList;
  }
}
