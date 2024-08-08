part of hive_storage_manager;

mixin TrackingCoordinateOperationsMixin {
  static const String _keyTrackingCoordinate = 'tracking_coordinate';

  LazyBox<TrackingCoordinatesResponseModelItem>? _trackingCoordinateBoxInstance;

  /// Returns the inspection damage box. Creates it if it doesn't exist.
  Future<LazyBox<TrackingCoordinatesResponseModelItem>>
      get _trackingCoordinateBox async {
    return _trackingCoordinateBoxInstance ??=
        await Hive.openLazyBox<TrackingCoordinatesResponseModelItem>(
            _keyTrackingCoordinate);
  }

  Future<bool> setTrackingCoordinate(
      TrackingCoordinatesResponseModelItem data) async {
    print(data);
    final box = await _trackingCoordinateBox;
    await box.put(_keyTrackingCoordinate, data);
    return true;
  }

  Future<TrackingCoordinatesResponseModelItem?>
      getTrackingCoordinateModel() async {
    final box = await _trackingCoordinateBox;
    final jsonList = await box.get(_keyTrackingCoordinate);
    if (jsonList == null) return null;
    return jsonList;
  }

  Future<void> deleteTrackingCoordinate() async {
    final box = await _trackingCoordinateBox;
    await box.clear();
  }
}
