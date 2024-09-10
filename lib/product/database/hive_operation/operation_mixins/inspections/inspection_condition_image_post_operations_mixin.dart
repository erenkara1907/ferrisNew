part of hive_storage_manager;

mixin InspectionConditionImagePostOperationsMixin {
  static const String _keyInspectionConditionImagePostOperationsMixin =
      'inspections_condition_image_post_async';
  static const String _keyDeletedConditionImageCacheOperationsMixin =
      'deleted_condition_image_cache';

  /// Returns the Hive box for the job working on.

  /// LazyBox instance for the expenses box.
  LazyBox<ConditionImageResponseModel>? _inspectionsConditionsPostOperations;
  LazyBox<ConditionImageResponseModel>? _deletedConditionImageCacheOperations;

  // final List<int> _deletedConditionImageIds = [];

  /// Returns the expenses box. Creates it if it doesn't exist.
  Future<LazyBox<ConditionImageResponseModel>>
      get _inspectionsConditionImage async {
    return _inspectionsConditionsPostOperations ??=
        await Hive.openLazyBox<ConditionImageResponseModel>(
            _keyInspectionConditionImagePostOperationsMixin);
  }

  /// Returns the cache box for deleted condition image ids. Creates it if it doesn't exist.
  Future<LazyBox<ConditionImageResponseModel>>
      get _deletedConditionImageCache async {
    return _deletedConditionImageCacheOperations ??=
        await Hive.openLazyBox<ConditionImageResponseModel>(
            _keyDeletedConditionImageCacheOperationsMixin);
  }

  /// Saves the given job as the job working on.
  /// If [job] is null, it will remove the job working on
  // Future<void> setConditionImagePostModel(
  //   ConditionImageResponseModel data,
  // ) async {
  //   final box = await _inspectionsConditionImage;
  //   return box.put(data.jobInspectionId, data);
  // }

  Future<void> setConditionImagePostModel(
      ConditionImageResponseModel data) async {
    final box = await _inspectionsConditionImage;
    final keys = box.keys.toList();

    // Mevcut verilerin sayısını belirle
    int count = 0;
    for (final key in keys) {
      final conditionImage = await box.get(key);
      if (conditionImage?.jobInspectionId == data.jobInspectionId) {
        count++;
      }
    }

    // Yeni veriyi, benzersiz bir anahtar ile sakla
    final newKey = '${data.jobInspectionId}_$count';
    await box.put(newKey, data);
  }

  /// Returns the job working on. If there is no job working on, it will return null.
  Future<List<ConditionImageResponseModel?>> getConditionImagePostModel(
      int inspectionsId) async {
    final box = await _inspectionsConditionImage;
    final inspectionDetails = <ConditionImageResponseModel?>[];
    final keys = box.keys.toList();
    for (final key in keys) {
      final inspectionDetailsPostModel = await box.get(key);
      if (inspectionDetailsPostModel?.jobInspectionId == inspectionsId) {
        inspectionDetails.add(inspectionDetailsPostModel);
      }
    }
    return inspectionDetails;
  }

  Future<void> deleteConditionImagePostModel(int id) async {
    final box = await _inspectionsConditionImage;
    final keys = box.keys.toList();
    for (final key in keys) {
      final conditionPostModel = await box.get(key);
      if (conditionPostModel?.id == id) {
        await box.delete(key);
      }
    }
  }

  Future<void> storeDeletedId(ConditionImageResponseModel data) async {
    final cacheBox = await _deletedConditionImageCache;
    final keys = cacheBox.keys.toList();

    // Mevcut verilerin sayısını belirle
    int count = 0;
    for (final key in keys) {
      final cachedModel = await cacheBox.get(key);
      if (cachedModel?.jobInspectionId == data.jobInspectionId) {
        count++;
      }
    }

    // Yeni veriyi, benzersiz bir anahtar ile sakla
    final newKey = '${data.jobInspectionId}_$count';
    await cacheBox.put(newKey, data);
  }

  Future<List<ConditionImageResponseModel?>> getDeletedConditionImagesFromCache(
      int jobInspectionId) async {
    // Cache box'tan verileri al
    final cacheBox = await _deletedConditionImageCache;
    final deletedImages = <ConditionImageResponseModel?>[];

    // Cache'deki tüm anahtarları al
    final keys = cacheBox.keys.toList();

    // Her bir anahtarı gezerek modele eriş ve jobInspectionId'ye göre filtrele
    for (final key in keys) {
      final model = await cacheBox.get(key);
      if (model?.jobInspectionId == jobInspectionId) {
        deletedImages.add(model);
      }
    }

    return deletedImages;
  }

  Future<void> deleteIdFromCache(int conditionImageId) async {
    // Cache box'u aç
    final cacheBox = await _deletedConditionImageCache;

    // Cache'deki tüm anahtarları al
    final keys = cacheBox.keys.toList();

    // Anahtarları gezerek, cache'deki silinmiş id'yi bul
    for (final key in keys) {
      final model = await cacheBox.get(key);
      if (model?.id == conditionImageId) {
        // Eşleşen id'yi bulduğunda cache'den sil
        await cacheBox.delete(key);
      }
    }
  }

  Future<void> clearAllConditionImagePostModels() async {
    final box = await _inspectionsConditionImage;
    await box.clear();
  }
}
