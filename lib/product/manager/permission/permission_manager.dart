import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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

  Future<bool> requestLocationPermission(BuildContext context) async {
    // İlk önce location izni isteyin (when in use).
    PermissionStatus status = await Permission.locationWhenInUse.request();

    if (status.isGranted || status.isLimited || status.isRestricted) {
      print("Acceptded");
      // Eğer izin verildiyse, always iznini istemek için bir kontrol yapın.
      return await requestLocationAlwaysPermission();
    } else {
      print("Denied");
      return false;
    }
  }

  Future<bool> requestLocationAlwaysPermission() async {
    // Always izni isteyin.
    PermissionStatus status = await Permission.locationAlways.request();

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
    return result.authorizationStatus == AuthorizationStatus.provisional ||
        result.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<bool> checkLocationAlways() async {
    PermissionStatus status = await Permission.locationAlways.request();

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

  static final PermissionHandlerManager _instance = PermissionHandlerManager._internal();

  factory PermissionHandlerManager() => _instance;

  PermissionHandlerManager._internal();
}
