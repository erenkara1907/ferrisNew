part of hive_storage_manager;

mixin InspectionDamageOperationsMixin {
  static const String _boxNameInspectionDamage = 'inspection_damage';

  /// LazyBox instance for the inspection damage box.
  LazyBox<InspectionDamage>? _inspectionDamageBoxInstance;

  /// Returns the inspection damage box. Creates it if it doesn't exist.
  Future<LazyBox<InspectionDamage>> get _inspectionDamageBox async {
    return _inspectionDamageBoxInstance ??=
        await Hive.openLazyBox<InspectionDamage>(_boxNameInspectionDamage);
  }

  /// Adds or updates the given inspection damage to the inspection damage box.
  Future<void> putInspectionDamage(InspectionDamage inspectionDamage) async {
    final box = await _inspectionDamageBox;
    await box.put(inspectionDamage.id, inspectionDamage);
  }

  /// Returns a list of all inspection damages in the inspection damage saved.
  /// If [inspectionId] is provided, only the inspection damages with the given
  /// inspection id are returned.
  Future<List<InspectionDamage>> getInspectionDamages({
    int? inspectionId,
  }) async {
    final box = await _inspectionDamageBox;
    final List<InspectionDamage> result = [];
    for (String id in box.keys) {
      final damage = await box.get(id);
      if (damage == null) throw Exception('InspectionDamage is null');
      if (inspectionId != null && damage.inspectionId != inspectionId) continue;
      result.add(damage);
    }
    return result;
  }

  Future<InspectionDamage?> getInspectionDamage(String id) async {
    final box = await _inspectionDamageBox;
    return await box.get(id);
  }

  /// Deletes the inspection damage with the given id from the inspection damage box.
  Future<void> deleteInspectionDamage(String id) async {
    final box = await _inspectionDamageBox;
    await box.delete(id);
  }

  Future<List<InspectionDamage>> getInspectionDamagesNotSynced({
    required int inspectionId,
  }) async {
    final box = await _inspectionDamageBox;
    final List<InspectionDamage> result = [];
    for (String id in box.keys) {
      final damage = await box.get(id);
      if (damage == null) throw Exception('InspectionDamage is null');
      if (damage.inspectionId == inspectionId && !damage.synced) {
        result.add(damage);
      }
    }
    return result;
  }

  Future<void> clearAllInspectionDamages() async {
    final box = await _inspectionDamageBox;
    await box.clear();
  }
}
