import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationServiceManager {
  Stream<LocationData>? _locationDataStream;

  /// Starts the location service. Returns true if the service is started
  /// successfully.
  Future<bool> startService() async {
    final result = await PlatformConstants.methodChannel.invokeMethod(
          PlatformConstants.funcStartService,
        ) ==
        null;
    return result;
  }

  /// Resumes the location service. Returns true if the service is resumed
  /// successfully.
  resumeService() async {
    final result = await PlatformConstants.methodChannel.invokeMethod(
      PlatformConstants.funcResumeService,
    );
    return result;
  }

  /// Pauses the location service. Returns true if the service is paused
  /// successfully.
  pauseService() async {
    final result = await PlatformConstants.methodChannel.invokeMethod(
      PlatformConstants.funcPauseService,
    );
    return result;
  }

  /// Stops the location service. Returns true if the service is stopped
  /// successfully.
  stopService() async {
    final result = await PlatformConstants.methodChannel.invokeMethod(
      PlatformConstants.funcStopService,
    );
    return result;
  }

  /// Returns true if the service is started. Returns false if the service is
  /// not working at all.
  Future<bool> isServiceStarted() async {
    final result = await PlatformConstants.methodChannel.invokeMethod<bool>(
      PlatformConstants.funcIsServiceStarted,
    );
    return result ?? false;
  }

  /// Returns true if the service is running. Returns false if the service is
  /// not resumed.
  Future<bool> isServiceRunning() async {
    final result = await PlatformConstants.methodChannel.invokeMethod<bool>(
      PlatformConstants.funcIsServiceRunning,
    );
    return result ?? false;
  }

  /// Returns the location data stream.
  Stream<LocationData> onLocationData() {
    return _locationDataStream ??=
        PlatformConstants.eventChannel.receiveBroadcastStream().map((event) {
      final originalAsMap = event as Map<dynamic, dynamic>;
      final casted = originalAsMap.cast<String, dynamic>();
      return LocationData.fromMap(casted);
    });
  }

  // singleton
  static final LocationServiceManager _instance =
      LocationServiceManager._internal();

  factory LocationServiceManager() => _instance;

  LocationServiceManager._internal();
}

abstract class PlatformConstants {
  static const MethodChannel methodChannel =
      MethodChannel('com.ferris.method_channel');
  static const EventChannel eventChannel =
      EventChannel('com.ferris.event_channel');

  // location service
  static const String funcStartService = 'start_location_service';
  static const String funcResumeService = 'resume_location_service';
  static const String funcPauseService = 'pause_location_service';
  static const String funcStopService = 'stop_location_service';
  static const String funcIsServiceStarted = 'is_location_service_started';
  static const String funcIsServiceRunning = 'is_location_service_running';
  static const String funcGetPathNodes = 'get_path_nodes';
  static const String funcClearPathNodes = 'clear_path_nodes';

  // network credentials
  static const String funcSetToken = 'set_token';
  static const String funcSetJobId = 'set_job_id';
  static const String funcSetLocationPostUrl = 'set_location_post_url';

  // new access token
  static const String funcGetNewAccessToken = 'get_new_access_token';
  static const String funcDeleteNewAccessToken = 'delete_new_access_token';
  static const EventChannel tokenEventChannel =
      EventChannel('com.ferris.token_event_channel');
}
