// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
// import 'package:ferrisfwt/product/manager/permission/permission_manager.dart';
// import 'package:flutter/material.dart';

// part 'permissions_state.dart';

// class CubitPermissions extends Cubit<StatePermissions> {
//   CubitPermissions()
//       : super(const StatePermissions(
//           location: false,
//           camera: false,
//           notification: false,
//         ));

//   /// Check permissions and update the state.
//   checkPermissions(BuildContext contextS) async {
//     bool location = await requestLocation(contextS);
//     bool camera = await PermissionHandlerManager().checkCamera();
//     bool notification = await PermissionHandlerManager().checkNotification();
//     emit(StatePermissions(
//       location: location,
//       camera: camera,
//       notification: notification,
//     ));

//     print('location v2 : $location');
//   }

//   Future<bool> requestLocation(BuildContext contextA) async {
//     final HiveStorageManager hiveStorageManager = HiveStorageManager();
//     print('location : ${state.location}');
//     if (state.location) {
//       // Eğer already izin verilmişse, location always iznini kontrol edin.
//       return await PermissionHandlerManager().requestLocationAlwaysPermission();
//     }

//     bool isAccepted = await hiveStorageManager.getLocationPermission();

//     print('isAccepted : $isAccepted');

//     if (isAccepted) {
//       return true;
//     }

//     final userAccepted = await showDialog<bool>(
//       context: contextA,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Location permission is required"),
//           content: const Text(
//               "Ferris collects location data to track vehicles during active jobs, ensuring legal compliance and operational safety, even when the app is closed or not in use."),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, false); // Kullanıcı reddetti
//                 // context.go('/sign_in_page');
//               },
//               child: const Text("Deny"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, true); // Kullanıcı kabul etti
//                 // context.go('/sign_in_page');
//               },
//               child: const Text("Allow"),
//             ),
//           ],
//         );
//       },
//     );

//     print('userAccepted : $userAccepted');

//     if (userAccepted == null || !userAccepted) {
//       // Kullanıcı reddettiyse false döndür.
//       emit(state.copyWith(location: false));
//       return false;
//     }

//     // İlk olarak location iznini isteyin.
//     final result = await PermissionHandlerManager().requestLocationPermission(contextA);

//     // Eğer location izni verildiyse, location always iznini kontrol edin.
//     if (result) {
//       await PermissionHandlerManager().requestLocationAlwaysPermission();
//     }

//     print('result : $result');

//     emit(state.copyWith(location: result));

//     await hiveStorageManager.addLocationPermission(true);
//     return result;
//   }

//   Future requestCamera() async {
//     if (state.camera) return;
//     final result = await PermissionHandlerManager().requestCameraPermission();
//     emit(state.copyWith(camera: result));
//   }

//   Future requestNotification() async {
//     if (state.notification) return;
//     final result = await PermissionHandlerManager().requestNotification();

//     emit(state.copyWith(
//       notification: result,
//     ));
//   }
// }

// /// State of the [CubitPermissions].

// ignore_for_file: use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/manager/permission/permission_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'permissions_state.dart';

class CubitPermissions extends Cubit<StatePermissions> {
  CubitPermissions()
      : super(const StatePermissions(
          location: false,
          camera: false,
          notification: false,
        ));

  /// Check permissions and update the state.
  Future<void> checkPermissions(BuildContext contextS) async {
    bool location = await requestLocation(contextS);
    bool camera = await PermissionHandlerManager().checkCamera();
    bool notification = await PermissionHandlerManager().checkNotification();
    emit(StatePermissions(
      location: location,
      camera: camera,
      notification: notification,
    ));

    if (kDebugMode) {
      print('Location permission status: $location');
    }
  }

  // Request location permission and handle user interaction.
  Future<bool> requestLocation(BuildContext contextA) async {
    final HiveStorageManager hiveStorageManager = HiveStorageManager();
    if (kDebugMode) {
      print('Current location permission status: ${state.location}');
    }

    if (state.location) {
      // If already granted, check for "always" permission.
      return await PermissionHandlerManager().requestLocationAlwaysPermission();
    }

    bool isAccepted = await hiveStorageManager.getLocationPermission();

    if (kDebugMode) {
      print('Is location permission previously accepted? $isAccepted');
    }

    if (isAccepted) {
      return true;
    }

    // Show a dialog to explain why location permission is required.
    final userAccepted = await showDialog<bool>(
      context: contextA,
      builder: (context) {
        return AlertDialog(
          title: const Text("Location Permission Required"),
          content: const Text(
              "Ferris collects location data to track vehicles during active jobs, ensuring legal compliance and operational safety, even when the app is closed or not in use."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // User denied.
              },
              child: const Text("Deny"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // User accepted.
              },
              child: const Text("Allow"),
            ),
          ],
        );
      },
    );

    if (kDebugMode) {
      print('User accepted location permission? $userAccepted');
    }

    if (userAccepted == null || !userAccepted) {
      // If the user denied, update the state and return false.
      emit(state.copyWith(location: false));
      return false;
    }

    // Request "when in use" location permission.
    final result = await PermissionHandlerManager().requestLocationPermission(contextA);

    // If granted, request "always" permission.
    if (result) {
      await PermissionHandlerManager().requestLocationAlwaysPermission();
    }

    // Also request FOREGROUND_SERVICE_LOCATION permission for Android 14.
    // await PermissionHandlerManager().requestForegroundServiceLocationPermission();

    if (kDebugMode) {
      print('Final location permission result: $result');
    }

    emit(state.copyWith(location: result));

    await hiveStorageManager.addLocationPermission(true);
    return result;
  }

  // Request camera permission.
  Future<void> requestCamera() async {
    if (state.camera) return;
    final result = await PermissionHandlerManager().requestCameraPermission();
    emit(state.copyWith(camera: result));
  }

  // Request notification permission.
  Future<void> requestNotification() async {
    if (state.notification) return;
    final result = await PermissionHandlerManager().requestNotification();

    emit(state.copyWith(
      notification: result,
    ));
  }
}

/// State of the [CubitPermissions].