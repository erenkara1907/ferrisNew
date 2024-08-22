import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ferrisfwt/product/manager/permission/permission_manager.dart';

part 'permissions_state.dart';

class CubitPermissions extends Cubit<StatePermissions> {
  CubitPermissions()
      : super(const StatePermissions(
          location: false,
          camera: false,
          notification: false,
        ));

  /// Check permissions and update the state.
  checkPermissions() async {
    print("Check Permission");
    bool location = await requestLocation();
    bool camera = await PermissionHandlerManager().checkCamera();
    bool notification = await PermissionHandlerManager().checkNotification();
    emit(StatePermissions(
      location: location,
      camera: camera,
      notification: notification,
    ));
  }

  /// Request the location permission.
  // Future<bool> requestLocation() async {
  //   print("Location Girdi State : ${state.location}");
  //   if (state.location) {
  //     await PermissionHandlerManager().checkLocationAlways();
  //     return true;
  //   }
  //   final result = await PermissionHandlerManager().requestLocationPermission();
  //   print("Location Girdi : $result");

  //   if (result) {
  //     await PermissionHandlerManager().checkLocationAlways();
  //   }

  //   emit(state.copyWith(location: result));
  //   return result;
  // }

  Future<bool> requestLocation() async {
    print("Location izni durumu: ${state.location}");

    if (state.location) {
      // Eğer already izin verilmişse, location always iznini kontrol edin.
      return await PermissionHandlerManager().requestLocationAlwaysPermission();
    }

    // İlk olarak location iznini isteyin.
    final result = await PermissionHandlerManager().requestLocationPermission();

    print("Location izni sonucu: $result");

    // Eğer location izni verildiyse, location always iznini kontrol edin.
    if (result) {
      await PermissionHandlerManager().requestLocationAlwaysPermission();
    }

    emit(state.copyWith(location: result));

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