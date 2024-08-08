import 'dart:io';

import 'package:ferrisfwt/product/manager/location/location_service_manager.dart';

abstract class PlatformNetworkCredentialsManager {
  /// Sets the token for the network calls.
  static Future<void> setToken(String token) async {
    await PlatformConstants.methodChannel.invokeMethod(
      PlatformConstants.funcSetToken,
      {'token': token},
    );
  }

  /// Sets the job id for the network calls.
  static Future<void> setJobId(int jobId) async {
    await PlatformConstants.methodChannel.invokeMethod(
      PlatformConstants.funcSetJobId,
      {'jobId': jobId},
    );
  }

  /// Sets the location post url for the network calls.
  static Future<void> setLocationPostUrl(String url) async {
    if (Platform.isAndroid) {
      throw Exception('setLocationPostUrl is not implemented on Android yet');
    }
    await PlatformConstants.methodChannel.invokeMethod(
      PlatformConstants.funcSetLocationPostUrl,
      {'location_post_url': url},
    );
  }

  /// Sets the job id and token for the network calls.
  static Future<void> setCredentials({
    required int jobId,
    required String token,
    required String url,
  }) async {
    await setToken(token);
    await setJobId(jobId);
    await setLocationPostUrl(url);
  }
}
