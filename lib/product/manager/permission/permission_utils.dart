import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PermissionUtils {
  static const MethodChannel _channel = MethodChannel('permission_utils');

  // Check if FOREGROUND_SERVICE_LOCATION permission is granted.
  static Future<bool> isForegroundServiceLocationPermissionGranted() async {
    try {
      final bool result = await _channel.invokeMethod('isForegroundServiceLocationPermissionGranted');
      return result;
    } catch (e) {
      if (kDebugMode) {
        print("Error checking FOREGROUND_SERVICE_LOCATION permission: $e");
      }
      return false;
    }
  }
}
