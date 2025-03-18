// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// class PermissionHandlerManager {
//   // Future<bool> requestLocationPermission() async {
//   //   PermissionStatus status = await Permission.location.request();
//   //   if (status.isGranted || status.isLimited || status.isRestricted) {
//   //     return true;
//   //   } else {
//   //     return false;
//   //   }
//   // }

//   Future<bool> requestLocationPermission(BuildContext context) async {
//     // İlk önce location izni isteyin (when in use).
//     PermissionStatus status = await Permission.locationWhenInUse.request();

//     if (status.isGranted || status.isLimited || status.isRestricted) {
//       print("Acceptded");
//       // Eğer izin verildiyse, always iznini istemek için bir kontrol yapın.
//       return await requestLocationAlwaysPermission();
//     } else {
//       print("Denied");
//       return false;
//     }
//   }

//   Future<bool> requestLocationAlwaysPermission() async {
//     // Always izni isteyin.
//     PermissionStatus status = await Permission.locationAlways.request();

//     if (status.isGranted) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<bool> requestCameraPermission() async {
//     PermissionStatus status = await Permission.camera.request();
//     if (status.isGranted || status.isLimited || status.isRestricted) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<bool> requestNotification() async {
//     final result = await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     return result.authorizationStatus == AuthorizationStatus.provisional ||
//         result.authorizationStatus == AuthorizationStatus.authorized;
//   }

//   Future<bool> checkLocationAlways() async {
//     PermissionStatus status = await Permission.locationAlways.request();

//     if (status.isGranted) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<bool> checkCamera() async {
//     return await Permission.camera.isGranted;
//   }

//   Future<bool> checkNotification() async {
//     final result = await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     return result.authorizationStatus == AuthorizationStatus.provisional ||
//         result.authorizationStatus == AuthorizationStatus.authorized;
//   }

//   static final PermissionHandlerManager _instance = PermissionHandlerManager._internal();

//   factory PermissionHandlerManager() => _instance;

//   PermissionHandlerManager._internal();
// }

import 'package:ferrisfwt/product/manager/permission/permission_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerManager {
  // Request location permission (when in use).
  // Future<bool> requestLocationPermission(BuildContext context) async {
  //   // First, request "location when in use" permission.
  //   PermissionStatus status = await Permission.locationWhenInUse.request();

  //   if (status.isGranted || status.isLimited || status.isRestricted) {
  //     if (kDebugMode) {
  //       print("Location permission granted (when in use).");
  //     }
  //     // If granted, check and request "always" permission.
  //     return await requestLocationAlwaysPermission();
  //   } else {
  //     if (kDebugMode) {
  //       print("Location permission denied.");
  //     }
  //     return false;
  //   }
  // }

  Future<bool> requestLocationPermission(BuildContext context) async {
    // Request "when in use" location permission.
    PermissionStatus status = await Permission.locationWhenInUse.request();

    if (status.isGranted || status.isLimited || status.isRestricted) {
      if (kDebugMode) {
        print("Location permission granted (when in use).");
      }

      // Check and request FOREGROUND_SERVICE_LOCATION permission.
      bool isForegroundServiceGranted = await PermissionUtils.isForegroundServiceLocationPermissionGranted();
      if (!isForegroundServiceGranted) {
        if (kDebugMode) {
          print("Foreground service location permission is not granted.");
        }
        return false;
      }

      // If granted, check and request "always" permission.
      return await requestLocationAlwaysPermission();
    } else {
      if (kDebugMode) {
        print("Location permission denied.");
      }
      return false;
    }
  }

  // Request "always" location permission.
  Future<bool> requestLocationAlwaysPermission() async {
    // Request "always" location permission.
    PermissionStatus status = await Permission.locationAlways.request();

    if (status.isGranted) {
      if (kDebugMode) {
        print("Location always permission granted.");
      }
      return true;
    } else {
      if (kDebugMode) {
        print("Location always permission denied.");
      }
      return false;
    }
  }

  // Request camera permission.
  Future<bool> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted || status.isLimited || status.isRestricted) {
      if (kDebugMode) {
        print("Camera permission granted.");
      }
      return true;
    } else {
      if (kDebugMode) {
        print("Camera permission denied.");
      }
      return false;
    }
  }

  // Request notification permission using Firebase Messaging.
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

  // Check if "always" location permission is granted.
  Future<bool> checkLocationAlways() async {
    PermissionStatus status = await Permission.locationAlways.status;
    return status.isGranted;
  }

  // Check if camera permission is granted.
  Future<bool> checkCamera() async {
    return await Permission.camera.isGranted;
  }

  // Check if notification permission is granted.
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

  // // Add support for FOREGROUND_SERVICE_LOCATION permission (required for Android 14).
  // Future<bool> requestForegroundServiceLocationPermission() async {
  //   if (await Permission.foregroundService.isDenied) {
  //     PermissionStatus status = await Permission.foregroundService.request();
  //     if (status.isGranted) {
  //       print("Foreground service location permission granted.");
  //       return true;
  //     } else {
  //       print("Foreground service location permission denied.");
  //       return false;
  //     }
  //   }
  //   return true; // Already granted.
  // }

  static final PermissionHandlerManager _instance = PermissionHandlerManager._internal();

  factory PermissionHandlerManager() => _instance;

  PermissionHandlerManager._internal();
}
