part of hive_storage_manager;

mixin GetDamageOperationMixin {
  static final _valetStandardBox = Hive.box<DamageResponseModel>(HiveDatabaseConstants.getDamage);
  static final _valetStandardBoxNew = Hive.box<DamageResponseModel>(HiveDatabaseConstants.getDamageNew);
  static final _deletedDamageCache = Hive.box<DamageResponseModel>(HiveDatabaseConstants.getDamageDelete);

  List<int> deletedDamageIds = [];
  List<int> oldIds = [];
  List<int> newIds = [];
  bool isDelete = false;

  /// Set valet standards in the Hive box.
  Future<void> setGetDamage(DamageResponseModel damage) async {
    // Using put instead of add to set with a specific key if necessary
    await _valetStandardBox.put(damage.id, damage);
  }

  Future<void> setGetDamageNew(DamageResponseModel damage) async {
    // Using put instead of add to set with a specific key if necessary
    await _valetStandardBoxNew.put(damage.id, damage);
  }

  void setDamageBoolValue(bool value) {
    isDelete = value;
  }

  /// Get valet standards from the Hive box.
  Future<List<DamageResponseModel>> getGetDamage(int inspectionId) async {
    final results = _valetStandardBox.values.where((damage) => damage.jobInspectionId == inspectionId).toList();
    // debugPrint('results: $results');
    return results;
  }

  Future<List<DamageResponseModel>> getGetDamageNew(int inspectionId) async {
    final results = _valetStandardBoxNew.values.where((damage) => damage.jobInspectionId == inspectionId).toList();
    // debugPrint('results: $results');
    return results;
  }

  Future<void> updateDamageId(int oldId, int newId) async {
    // Eski id ile mevcut kaydı getir
    final existingDamage = _valetStandardBox.get(oldId);

    if (existingDamage != null) {
      // Eski kaydı sil
      await _valetStandardBox.delete(oldId);

      // Yeni id ile kaydı tekrar ekle
      final updatedDamage = existingDamage.copyWith(id: newId);
      await _valetStandardBox.put(newId, updatedDamage);

      // oldId ve newId'yi ilgili listelere ekle
      oldIds.add(oldId);
      newIds.add(newId);
    } else {
      throw Exception("No damage found with id: $oldId");
    }
  }

  /// Delete a damage entry from the Hive box.
  Future<void> deleteGetDamage(int inspectionId, int damageId) async {
    try {
      // Find the key of the damage entry to delete
      final key = _valetStandardBox.keys.firstWhere(
        (key) {
          final damage = _valetStandardBox.get(key);
          return damage?.jobInspectionId == inspectionId && damage?.id == damageId;
        },
        orElse: () => null,
      );

      if (key != null) {
        await SentryErrorHandler.instance.capture("Deleting damage with id: $damageId and inspectionId: $inspectionId",
            stackTrace: StackTrace.current);
        // debugPrint(
        //     'Deleting damage with id: $damageId and inspectionId: $inspectionId');
        await _valetStandardBox.delete(key);

        deletedDamageIds.add(damageId);
      } else {
        await SentryErrorHandler.instance.capture("No damage found with id: $damageId and inspectionId: $inspectionId",
            stackTrace: StackTrace.current);
        // debugPrint(
        //     'No damage found with id: $damageId and inspectionId: $inspectionId');
      }
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      debugPrint('Error deleting damage: $e');
    }
  }

  Future<void> deleteGetDamageNew(int inspectionId, int damageId) async {
    try {
      // Find the key of the damage entry to delete
      final key = _valetStandardBoxNew.keys.firstWhere(
        (key) {
          final damage = _valetStandardBoxNew.get(key);
          return damage?.jobInspectionId == inspectionId && damage?.id == damageId;
        },
        orElse: () => null,
      );

      if (key != null) {
        await SentryErrorHandler.instance.capture("Deleting damage with id: $damageId and inspectionId: $inspectionId",
            stackTrace: StackTrace.current);
        // debugPrint(
        //     'Deleting damage with id: $damageId and inspectionId: $inspectionId');
        await _valetStandardBoxNew.delete(key);
      } else {
        await SentryErrorHandler.instance.capture("No damage found with id: $damageId and inspectionId: $inspectionId",
            stackTrace: StackTrace.current);
        // debugPrint(
        //     'No damage found with id: $damageId and inspectionId: $inspectionId');
      }
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      debugPrint('Error deleting damage: $e');
    }
  }

  List<int> getDeletedDamageIds() {
    // oldIds listesindeki her bir oldId'yi kontrol et ve newIds ile değiştir

    if (oldIds.isNotEmpty && newIds.isNotEmpty) {
      for (int i = 0; i < oldIds.length; i++) {
        int oldId = oldIds[i];
        int newId = newIds[i];

        // Eğer deletedDamageIds listesinde oldId varsa, onu newId ile değiştir
        final index = deletedDamageIds.indexOf(oldId);
        if (index != -1) {
          deletedDamageIds[index] = newId;
        }
      }
    }

    return deletedDamageIds;
  }

  void clearDeletedDamageIds() {
    deletedDamageIds.clear();
    newIds.clear();
    oldIds.clear();
  }

  // Silinen DamageResponseModel'ı cache'e ekle
  Future<void> storeDeletedDamageId(DamageResponseModel data) async {
    final cacheBox = _deletedDamageCache;
    final keys = cacheBox.keys.toList();

    // Mevcut verilerin sayısını belirle
    int count = 0;
    for (final key in keys) {
      final cachedModel = cacheBox.get(key);
      if (cachedModel?.jobInspectionId == data.jobInspectionId) {
        count++;
      }
    }

    // Yeni veriyi, benzersiz bir anahtar ile sakla
    final newKey = '${data.jobInspectionId}_$count';
    await cacheBox.put(newKey, data);
  }

  // Cache'den belirli jobInspectionId'ye göre silinen DamageResponseModel'ları getir
  Future<List<DamageResponseModel?>> getDeletedDamageFromCache(int jobInspectionId) async {
    final cacheBox = _deletedDamageCache;
    final deletedDamages = <DamageResponseModel?>[];

    // Cache'deki tüm anahtarları al
    final keys = cacheBox.keys.toList();

    // Her bir anahtarı gezerek modele eriş ve jobInspectionId'ye göre filtrele
    for (final key in keys) {
      final model = cacheBox.get(key);
      if (model?.jobInspectionId == jobInspectionId) {
        deletedDamages.add(model);
      }
    }

    return deletedDamages;
  }

  // Cache'den belirli damageId'yi sil
  Future<void> deleteDamageIdFromCache(int damageId) async {
    final cacheBox = _deletedDamageCache;

    // Cache'deki tüm anahtarları al
    final keys = cacheBox.keys.toList();

    // Anahtarları gezerek, cache'deki silinmiş id'yi bul
    for (final key in keys) {
      final model = cacheBox.get(key);
      if (model?.id == damageId) {
        // Eşleşen id'yi bulduğunda cache'den sil
        await cacheBox.delete(key);
      }
    }
  }
}
