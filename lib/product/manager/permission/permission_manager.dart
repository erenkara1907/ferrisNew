import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerManager {
  Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted || status.isLimited || status.isRestricted) {
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
    print(result.authorizationStatus == AuthorizationStatus.provisional ||
        result.authorizationStatus == AuthorizationStatus.authorized);
    return result.authorizationStatus == AuthorizationStatus.provisional ||
        result.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<bool> checkLocationAlways() async {
    return await Permission.locationAlways.isGranted;
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
