part of hive_storage_manager;

mixin InspectionSignOperationsMixin {
  static const String _boxNameInspectionSign = 'inspection_sign';

  /// LazyBox instance for the inspection sign box.
  LazyBox<InspectionSign>? _inspectionSignBoxInstance;

  /// Returns the inspection sign box. Creates it if it doesn't exist.
  Future<LazyBox<InspectionSign>> get _inspectionSignBox async {
    return _inspectionSignBoxInstance ??=
        await Hive.openLazyBox<InspectionSign>(_boxNameInspectionSign);
  }

  /// Adds the given inspection sign to the inspection sign box.
  Future<void> addInspectionSign(InspectionSign inspectionSign) async {
    final box = await _inspectionSignBox;
    await box.put(inspectionSign.inspectionId, inspectionSign);
  }

  /// Updates the given inspection sign in the inspection sign box.
  Future<void> updateInspectionSign(InspectionSign inspectionSign) async {
    final box = await _inspectionSignBox;
    await box.put(inspectionSign.inspectionId, inspectionSign);
  }

  Future<InspectionSign?> getInspectionSign(int id) async {
    final box = await _inspectionSignBox;
    final sign = await box.get(id);
    return sign;
  }

  /// Deletes the inspection sign with the given id from the inspection sign box.
  Future<void> deleteInspectionSign(int id) async {
    final box = await _inspectionSignBox;
    await box.delete(id);
  }

  /// Returns a list of all inspection signs in the inspection sign could not be
  /// synced.
  Future<List<InspectionSign>> getInspectionSignNotSynced({
    required int inspectionId,
  }) async {
    final box = await _inspectionSignBox;
    final List<InspectionSign> result = [];
    for (int id in box.keys) {
      final sign = await box.get(id);
      if (sign == null) throw Exception('InspectionSign is null');
      if (sign.inspectionId != inspectionId) continue;
      if (!sign.isSyncedCompletely) {
        result.add(sign);
      }
    }
    return result;
  }
  Future<void> clearAllInspectionSigns() async {
  final box = await _inspectionSignBox;
  await box.clear();
}
}
