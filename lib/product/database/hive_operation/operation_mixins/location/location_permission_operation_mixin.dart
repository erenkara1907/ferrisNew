part of hive_storage_manager;

mixin LocationPermissionOperationMixin {
  static final _location = Hive.box(HiveDatabaseConstants.locationPermission);

  Future<void> addLocationPermission(bool isGranted) async {
    await _location.put('location_permission', isGranted);
  }

  Future<bool> getLocationPermission() async {
    return _location.get('location_permission', defaultValue: false);
  }
}
