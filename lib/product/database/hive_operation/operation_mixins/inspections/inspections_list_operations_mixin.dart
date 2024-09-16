part of hive_storage_manager;

mixin InspectionsListOperationsMixin {
  static const String _keyJobInspectionsList = 'job_inspections_list';

  /// Returns the Hive box for the job working on.

  /// LazyBox instance for the expenses box.
  LazyBox<JobInspectionResponseModelItem>? _inspectionsListBoxInstance;

  /// Returns the expenses box. Creates it if it doesn't exist.
  Future<LazyBox<JobInspectionResponseModelItem>> get _jobInspectionsBox async {
    return _inspectionsListBoxInstance ??=
        await Hive.openLazyBox<JobInspectionResponseModelItem>(_keyJobInspectionsList);
  }

  /// Saves the given job as the job working on.
  /// If [job] is null, it will remove the job working on
  Future<void> setInspectionsListModel(List<JobInspectionResponseModelItem?> data) async {
    final box = await _jobInspectionsBox;

    await box.clear();

    // Yeni job'u kaydet
    for (final inspection in data) {
      if (inspection != null) {
        await box.put(inspection.id, inspection);
      }
    }
  }

  Future<void> updateInspectionsListModel(List<JobInspectionResponseModelItem?> data) async {
    final box = await _jobInspectionsBox;

    // Yeni job'u kaydet veya mevcut olanı güncelle
    for (final inspection in data) {
      if (inspection != null) {
        // Eğer mevcutsa güncelle, değilse ekle
        await box.put(inspection.id, inspection);
      }
    }
  }

  // Future<void> updateInspectionsListModel(
  //     JobInspectionResponseModelItem data) async {
  //       List<JobInspectionResponseModelItem?> currentJobInspection = await getInspectionsListModel();
  //   final box = await _jobInspectionsBox;

  //   await box.put(data.id, data);
  // }

  Future<void> updateInspectionsListModelGrade(JobInspectionResponseModelItem data) async {
    // Mevcut job inspection listesini al
    List<JobInspectionResponseModelItem?> currentJobInspection = await getInspectionsListModel();

    final box = await _jobInspectionsBox;

    // Mevcut listedeki öğeyi bulup güncelle
    for (int i = 0; i < currentJobInspection.length; i++) {
      if (currentJobInspection[i]?.id == data.id) {
        // Güncellenmiş öğeyi elde et
        final updatedItem = currentJobInspection[i]!.copyWith(
          gradleItem: GradeId(
            id: data.gradleItem?.id ?? 0,
            name: "${data.gradleItem?.name ?? 0}",
            order: data.gradleItem?.order ?? 0,
          ),
        );

        // Listede ilgili öğeyi güncelle
        currentJobInspection[i] = updatedItem;

        break;
      }
    }

    // Güncellenmiş listeyi geri kutuya kaydet
    for (final item in currentJobInspection) {
      if (item != null) {
        await box.put(item.id, item); // Her bir öğeyi kutuya geri koy
      }
    }
  }

  /// Returns the job working on. If there is no job working on, it will return null.
  Future<List<JobInspectionResponseModelItem?>> getInspectionsListModel() async {
    final box = await _jobInspectionsBox;
    final keys = box.keys.toList();
    final List<Future<JobInspectionResponseModelItem?>> futures = [];
    for (final key in keys) {
      final future = box.get(key);
      futures.add(future);
    }
    return Future.wait(futures);
  }

  Future<JobInspectionResponseModelItem?> getInspectionById(int inspectionId) async {
    final box = await _jobInspectionsBox; // _jobInspectionsBox'tan veriyi al
    final keys = box.keys.toList(); // Box'taki tüm anahtarları al

    for (final key in keys) {
      final jobInspection = await box.get(key); // Her bir anahtara göre JobInspection öğesini al
      if (jobInspection?.id == inspectionId) {
        // Eğer inspectionId ile eşleşen öğe varsa
        return jobInspection; // O öğeyi döndür
      }
    }

    return null; // Eğer eşleşen bir öğe bulunamazsa null döndür
  }

  Future<void> deleteInspectionListModel(int inspectionId) async {
    final box = await _jobInspectionsBox;
    await box.delete(inspectionId);
  }

  Future<void> deleteAllInspectionListModel() async {
    final box = await _jobInspectionsBox;
    await box.clear();
  }
}
