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
    final location = await requestLocation();
    bool camera = await PermissionHandlerManager().checkCamera();
    bool notification = await PermissionHandlerManager().checkNotification();
    emit(StatePermissions(
      location: location,
      camera: camera,
      notification: notification,
    ));
  }

  /// Request the location permission.
  Future<bool> requestLocation() async {
    if (state.location) return true;
    final result = await PermissionHandlerManager().requestLocationPermission();

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