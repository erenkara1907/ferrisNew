import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

/// AppDefaults provides the app default values like animation duration and
/// curve.
abstract class GeneralAppConstants {
  // animation
  static const Duration appDuration = Duration(milliseconds: 400);
  static const Curve appCurve = Curves.easeInOutCubic;

  // map
  static const LatLng mapDefaultCenter = LatLng(
    51.503303190287255,
    -0.11966807533661769,
  );
  static const double mapDefaultZoom = 14;

  // privacy policy
  static const String privacyPolicyUrl = 'https://www.driveferris.com/privacy/';

  // local storage files
  static const String _imagesDirName = 'images';
  static Future<Directory> get imagesRoot async {
    final dir = Directory(
      '${(await getApplicationDocumentsDirectory()).path}/$_imagesDirName',
    );
    if (!dir.existsSync()) {
      return await dir.create();
    }
    return dir;
  }
}
