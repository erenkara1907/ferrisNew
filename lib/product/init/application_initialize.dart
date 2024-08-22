import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:ferrisfwt/firebase_options.dart';
import 'package:ferrisfwt/product/database/hive/core/hive_database_manager.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_init.dart';
import 'package:ferrisfwt/product/firebase/notification/firebaseMessaging/firebase_messaging_service.dart';
import 'package:ferrisfwt/product/state/container/product_state_container.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:logger/logger.dart';

@immutable
final class ApplicationInitialize {
  /// project basic required initialize
  Future<void> make() async {
    WidgetsFlutterBinding.ensureInitialized();
    await runZonedGuarded<Future<void>>(
      _initialize,
      (error, stack) {
        Logger().e(error, stackTrace: stack);
      },
    );
  }

  Future<void> _initialize() async {
    await EasyLocalization.ensureInitialized();
    await _setRotation();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await _crashlyticsInitialize();
    await _setAnalytics();
    EasyLocalization.logger.enableLevels = [LevelMessages.error];
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    FlutterError.onError = (details) {
      Logger().e(details.exceptionAsString());
    };
    await FCMManager().setFCMUp();
    await _productEnvironmentWithContainer();
    await Hive.initFlutter();
    await HiveInit.hiveInit();
    await HiveDatabaseManager().init();
  }

  Future<void> _productEnvironmentWithContainer() async {
    await Locator.locateServices(baseUrl: 'https://dev.fwtsolutions.co.uk');
  }

  Future<void> _crashlyticsInitialize() async {
    //if (kDebugMode) return;
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
  }

  Future<void> _setRotation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _setAnalytics() async {
    await FirebaseAnalytics.instance.logAppOpen();
  }
}
