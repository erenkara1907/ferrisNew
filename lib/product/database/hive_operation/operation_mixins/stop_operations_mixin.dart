part of hive_storage_manager;

mixin StopOperationsMixin {
  static const String _boxNameStops = 'local_stops';

  /// LazyBox instance for the stops box.
  LazyBox<Stop>? _stopBoxInstance;

  /// Returns the stops box. Creates it if it doesn't exist.
  Future<LazyBox<Stop>> get _stopBox async {
    return _stopBoxInstance ??= await Hive.openLazyBox<Stop>(_boxNameStops);
  }

  /// Adds a stop to the stops box.
  Future addStop(Stop stop) async {
    final box = await _stopBox;
    await box.put(stop.id, stop);
  }

  /// Updates the stop with the given [oldId] to the given [newStop].
  Future updateStop(String oldId, Stop newStop) async {
    final box = await _stopBox;
    assert(box.keys.contains(oldId), 'Stop does not exist');
    await box.delete(oldId);
    await box.put(newStop.id, newStop);
  }

  /// deletes the stop with the given id, if it exists.
  Future deleteStop(String id) async {
    final box = await _stopBox;
    await box.delete(id);
  }

  /// Returns the stop with the given id if exists. Returns null
  /// otherwise.
  Future<Stop?> getStopById(String id) async {
    final box = await _stopBox;
    return box.get(id);
  }

  /// Returns a list of all the stops which are related to the job with the
  /// given id.
  Future<List<Stop>> getStops([int? jobId]) async {
    final box = await _stopBox;
    List<Stop> result = [];
    for (String key in box.keys) {
      final stop = await box.get(key);
      assert(stop != null);
      if (jobId == null || stop!.jobId == jobId) {
        result.add(stop!);
      }
    }
    return result;
  }

  /// Returns a list of all the stops which are not synced with the server.
  /// if [jobId] is not null, returns the stops which are related to the job
  /// with the given id. if [jobId] is null, returns all the stops which are
  /// not synced.
  Future<List<Stop>> getStopsNotSynced(int? jobId) async {
    final box = await _stopBox;
    List<Stop> result = [];
    for (String key in box.keys) {
      final stop = await box.get(key);
      assert(stop != null);
      if (jobId == null || stop!.jobId == jobId) {
        if (!stop!.isSynced()) result.add(stop);
      }
    }
    return result;
  }

  /// Removes all the stops from the stops box.
  clearStops() async {
    final box = await _stopBox;
    await box.clear();
  }

  /// Returns true if the stop with the given id exists in the database.
  /// Returns false otherwise.
  Future<bool> doesStopExist(String id) async {
    final box = await _stopBox;
    return box.containsKey(id);
  }
}
