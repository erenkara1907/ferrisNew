part of hive_storage_manager;

mixin LocationOperationMixin {
  static final _location = Hive.box(HiveDatabaseConstants.location);

  Future<void> addLocationsToTable(List<Map<String, dynamic>> locations) async {
    final box = _location;

    for (final location in locations) {
      final id =
          box.length + 1; // Her yeni lokasyon için benzersiz bir ID oluştur
      await box.put(id, location);
    }
  }

  Future<List<Map<String, double>>> getLocationsFromTable() async {
    final box = _location;

    final keys = box.keys.toList();

    List<Map<String, double>> locations = [];

    for (final key in keys) {
      final location = box.get(key);
      if (location != null && location is Map<String, double>) {
        locations.add(location);
      }
    }

    return locations;
  }

  Future<void> clearLocationTable() async {
    final box = _location; // Veya uygun Hive kutusunun referansı

    // Tüm verileri temizleme
    await box.clear();
  }
}
