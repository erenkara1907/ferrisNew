import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerManager {
  // Future<bool> requestLocationPermission() async {
  //   PermissionStatus status = await Permission.location.request();
  //   if (status.isGranted || status.isLimited || status.isRestricted) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future<bool> requestLocationPermission() async {
    // İlk önce location izni isteyin (when in use).
    PermissionStatus status = await Permission.locationWhenInUse.request();

    if (status.isGranted || status.isLimited || status.isRestricted) {
      // Eğer izin verildiyse, always iznini istemek için bir kontrol yapın.
      return await requestLocationAlwaysPermission();
    } else {
      return false;
    }
  }

  Future<bool> requestLocationAlwaysPermission() async {
    print("Always izni isteniyor...");

    // Always izni isteyin.
    PermissionStatus status = await Permission.locationAlways.request();

    print("Always izni durumu: $status");

    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted || status.isLimited || status.isRestricted) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> requestNotification() async {
    final result = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // print(result.authorizationStatus == AuthorizationStatus.provisional ||
    //     result.authorizationStatus == AuthorizationStatus.authorized);
    return result.authorizationStatus == AuthorizationStatus.provisional ||
        result.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<bool> checkLocationAlways() async {
    print("Always Girdi");
    PermissionStatus status = await Permission.locationAlways.request();

    print("Always Girdi Status : $status");
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkCamera() async {
    return await Permission.camera.isGranted;
  }

  Future<bool> checkNotification() async {
    final result = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    return result.authorizationStatus == AuthorizationStatus.provisional ||
        result.authorizationStatus == AuthorizationStatus.authorized;
  }

  static final PermissionHandlerManager _instance =
      PermissionHandlerManager._internal();

  factory PermissionHandlerManager() => _instance;

  PermissionHandlerManager._internal();
}
