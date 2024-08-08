part of 'permissions_cubit.dart';

class StatePermissions extends Equatable {
  const StatePermissions({
    required this.location,
    required this.camera,
    required this.notification,
  });

  /// True if the location permission is granted.
  final bool location;

  /// True if the camera permission is granted.
  final bool camera;

  /// True if the notification permission is granted.
  final bool notification;

  @override
  List<Object> get props => [location, camera, notification];

  StatePermissions copyWith({
    bool? location,
    bool? camera,
    bool? notification,
  }) {
    return StatePermissions(
      location: location ?? this.location,
      camera: camera ?? this.camera,
      notification: notification ?? this.notification,
    );
  }
}
