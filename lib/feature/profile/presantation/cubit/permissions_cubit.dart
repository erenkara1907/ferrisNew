import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/manager/permission/permission_manager.dart';
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
  checkPermissions(BuildContext contextS) async {
    bool location = await requestLocation(contextS);
    bool camera = await PermissionHandlerManager().checkCamera();
    bool notification = await PermissionHandlerManager().checkNotification();
    emit(StatePermissions(
      location: location,
      camera: camera,
      notification: notification,
    ));

    print('location v2 : $location');
  }

  Future<bool> requestLocation(BuildContext contextA) async {
    final HiveStorageManager hiveStorageManager = HiveStorageManager();
    print('location : ${state.location}');
    if (state.location) {
      // Eğer already izin verilmişse, location always iznini kontrol edin.
      return await PermissionHandlerManager().requestLocationAlwaysPermission();
    }

    bool isAccepted = await hiveStorageManager.getLocationPermission();

    print('isAccepted : $isAccepted');

    if (isAccepted) {
      return true;
    }

    final userAccepted = await showDialog<bool>(
      context: contextA,
      builder: (context) {
        return AlertDialog(
          title: const Text("Location permission is required"),
          content: const Text(
              "Ferris collects location data to track vehicles during active jobs, ensuring legal compliance and operational safety, even when the app is closed or not in use."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Kullanıcı reddetti
                // context.go('/sign_in_page');
              },
              child: const Text("Deny"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Kullanıcı kabul etti
                // context.go('/sign_in_page');
              },
              child: const Text("Allow"),
            ),
          ],
        );
      },
    );

    print('userAccepted : $userAccepted');

    if (userAccepted == null || !userAccepted) {
      // Kullanıcı reddettiyse false döndür.
      emit(state.copyWith(location: false));
      return false;
    }

    // İlk olarak location iznini isteyin.
    final result = await PermissionHandlerManager().requestLocationPermission(contextA);

    // Eğer location izni verildiyse, location always iznini kontrol edin.
    if (result) {
      await PermissionHandlerManager().requestLocationAlwaysPermission();
    }

    print('result : $result');

    emit(state.copyWith(location: result));

    await hiveStorageManager.addLocationPermission(true);
    return result;
  }

  Future requestCamera() async {
    if (state.camera) return;
    final result = await PermissionHandlerManager().requestCameraPermission();
    emit(state.copyWith(camera: result));
  }

  Future requestNotification() async {
    if (state.notification) return;
    final result = await PermissionHandlerManager().requestNotification();

    emit(state.copyWith(
      notification: result,
    ));
  }
}

/// State of the [CubitPermissions].