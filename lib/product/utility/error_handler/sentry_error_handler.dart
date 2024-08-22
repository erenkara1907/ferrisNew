import 'package:sentry_flutter/sentry_flutter.dart';

class SentryErrorHandler {
  // Singleton yapısı için private constructor
  SentryErrorHandler._privateConstructor();

  // Sınıfın tek örneğini tutar
  static final SentryErrorHandler instance =
      SentryErrorHandler._privateConstructor();

  // Hataları yakalayan ve Sentry'ye gönderen fonksiyon
  Future<void> capture(dynamic error, {StackTrace? stackTrace}) async {
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
    );
  }
}
