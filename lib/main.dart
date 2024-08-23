// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/job_expense/job_expense_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/stop_job/stop_job_bloc.dart';
import 'package:ferrisfwt/feature/inspections/presentation/bloc/inspections_bloc.dart';
import 'package:ferrisfwt/product/database/hive/core/hive_database_manager.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/init/application_initialize.dart';
import 'package:ferrisfwt/product/init/product_localization.dart';
import 'package:ferrisfwt/product/init/state.initialize.dart';
import 'package:ferrisfwt/product/mixin/network_mixin.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/theme/custom_dark_theme.dart';
import 'package:ferrisfwt/product/theme/theme_notifer.dart';
import 'package:ferrisfwt/product/utility/error_handler/sentry_error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    await dotenv.load(fileName: ".env");
    await ApplicationInitialize().make();

    await SentryFlutter.init(
      (options) {
        options.dsn = dotenv.env['SENTRY_DSN'];
        options.tracesSampleRate = 1.0;
        options.attachScreenshot = true;
        options.recordHttpBreadcrumbs = true;
        options.enableAutoSessionTracking = true;
        options.enableMetrics = true;
        options.attachViewHierarchy = true;
        options.enableAutoPerformanceTracing = true;
      },
    );

    runApp(
      SentryWidget(
        child: ProductLocalization(
          child: const StateInitialize(
            child: _MyApp(),
          ),
        ),
      ),
    );
  }, (exception, stackTrace) async {
    await Sentry.captureException(exception, stackTrace: stackTrace);
  });
}

Future<void> mains() async {
  // BindingBase.debugZoneErrorsAreFatal = true;
  // WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN'];
      options.tracesSampleRate = 1.0;
      options.attachScreenshot = true;
      options.recordHttpBreadcrumbs = true;
      options.enableAutoSessionTracking = true;
      options.enableMetrics = true;
      options.attachViewHierarchy = true;
      options.enableAutoPerformanceTracing = true;
    },
    appRunner: () async {
      // Zone guard için runZonedGuarded burada kullanılıyor
      runZonedGuarded(
        () {
          runApp(
            SentryWidget(
              child: ProductLocalization(
                child: const StateInitialize(
                  child: _MyApp(),
                ),
              ),
            ),
          );

          FlutterError.onError = (FlutterErrorDetails details) {
            FlutterError.presentError(details);
            Sentry.captureException(details.exception,
                stackTrace: details.stack);
          };
        },
        (error, stackTrace) async {
          await Sentry.captureException(error, stackTrace: stackTrace);
        },
      );
    },
  );

  // FlutterError.onError, Sentry'nin init işleminden sonra yapılandırılır
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   if (details.library == 'image resource service' &&
  //       (details.exception.toString().contains('404') ||
  //           details.exception.toString().contains("Invalid"))) {
  //     return;
  //   }
  //   Sentry.captureException(details.exception, stackTrace: details.stack);
  //   FlutterError.presentError(details);
  // };
}

class _MyApp extends StatefulWidget {
  const _MyApp();

  @override
  State<_MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<_MyApp> {
  late final HiveStorageManager _userHiveOperation;
  late final HiveDatabaseManager _userHiveDatabase;
  late Timer timer;
  late Timer timer2;

  @override
  void initState() {
    super.initState();
    _userHiveOperation = ProductStateItems.hiveStorageManager;
    _userHiveDatabase = ProductStateItems.hiveDatabaseManager;

    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      checkInternetConnection();
    });

    timer2 = Timer.periodic(const Duration(seconds: 30), (timer) async {
      await checkTrackingCoordinates();
    });
  }

  Future<void> checkTrackingCoordinates() async {
    if (ProductStateItems.hiveDatabaseManager.getUserModel()?.isStarted ==
        false) return;
    if (ProductStateItems.hiveDatabaseManager.getUserModel()?.token == null ||
        ProductStateItems.hiveDatabaseManager.getUserModel()?.token == "") {
      return;
    }
    try {
      // var connectivityResult = await hasNetwork();
      // final position = await Geolocator.getCurrentPosition(
      //     desiredAccuracy: LocationAccuracy.high);
      // if (connectivityResult) {
      //   final currentJobId =
      //       ProductStateItems.hiveDatabaseManager.getUserModel()?.currentJobId;

      //   print("currentJob Id : $currentJobId");

      //   if (currentJobId != null && context.mounted) {
      //     await Future.delayed(const Duration(seconds: 1));
      //     context.read<HomeBloc>().add(UpdateTrackingCoordinate(
      //           jobId: int.parse(currentJobId),
      //           latitude: position.latitude,
      //           longitude: position.longitude,
      //         ));
      //   }
      // } else {}
      final HiveStorageManager _hiveStorageManager = HiveStorageManager();
      var connectivityResult = await hasNetwork();
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final currentJobId =
          ProductStateItems.hiveDatabaseManager.getUserModel()?.currentJobId;
      if (connectivityResult) {
        List<Map<String, double>> _locations =
            await _hiveStorageManager.getLocationsFromTable();
        if (_locations.isNotEmpty && currentJobId != null) {
          print("LOCATIONS : $_locations");
          // API Request
          context.read<HomeBloc>().add(UpdateTrackingCoordinateBulk(
                jobId: int.parse(currentJobId),
                cordinates: _locations,
              ));

          await _hiveStorageManager.clearLocationTable();
          return;
        }

        print("currentJob Id : $currentJobId");

        if (currentJobId != null && context.mounted) {
          await Future.delayed(const Duration(seconds: 1));
          context.read<HomeBloc>().add(UpdateTrackingCoordinate(
                jobId: int.parse(currentJobId),
                latitude: position.latitude,
                longitude: position.longitude,
              ));
        }
      } else {
        // Şu anki tarih ve zaman
        DateTime _now = DateTime.now();

        // UNIX zaman damgası (saniye cinsinden)
        int _addedTime = _now.millisecondsSinceEpoch ~/ 1000;
        // Lokasyon verilerini eklemek için kodlar
        List<Map<String, dynamic>> locationData = [
          {
            "latitude": position.latitude,
            "longitude": position.longitude,
            "addedTime": _addedTime,
          },
        ];

        await _hiveStorageManager.addLocationsToTable(locationData);

        print("No network connection. Location saved locally: $locationData");
      }
    } on PermissionDeniedException catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
    } on LocationServiceDisabledException catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
    }
  }

  void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> checkInternetConnection() async {
    if (ProductStateItems.hiveDatabaseManager.getUserModel()?.isStarted ==
        false) return;
    if (ProductStateItems.hiveDatabaseManager.getUserModel()?.token == null ||
        ProductStateItems.hiveDatabaseManager.getUserModel()?.token == "") {
      return;
    }
    var connectivityResult = await hasNetwork();
    if (connectivityResult) {
      final result = await _userHiveOperation.getJobExpenseAsync();
      // print('result: $result');

      final resultStop = await _userHiveOperation.getJobStopAsync();

      // print('resultStop: $resultStop');

      final resultJobUpdate = await _userHiveOperation.getJobUpdate();

      // print('resultJobUpdate: $resultJobUpdate');

      final resultPatch = await _userHiveOperation.getJobExpensePatchAsync();

      // print('resultPatch: $resultPatch');

      if (result != [] && result.isNotEmpty && result != {}) {
        for (var item in result) {
          context.read<JobExpenseBloc>().add(PostExpense(item!, true));
          await Future.delayed(const Duration(seconds: 5));
        }
        await Future.delayed(const Duration(seconds: 5));

        _userHiveOperation.deleteJobExpenseAsync();
      }
      if (resultPatch.isNotEmpty &&
          resultPatch != {} &&
          resultPatch != [] &&
          _userHiveDatabase.getUserModel() != null) {
        for (var item in resultPatch) {
          context.read<JobExpenseBloc>().add(PatchExpense(item!, true, 0));
          await Future.delayed(const Duration(seconds: 5));
        }
        _userHiveOperation.deleteJobExpensePatchAsync();
      }

      if (resultStop != [] &&
          resultStop.isNotEmpty &&
          resultStop != {} &&
          _userHiveDatabase.getUserModel() != null) {
        for (var item in resultStop) {
          context.read<StopJobBloc>().add(PostJobStops(
              isAsync: true,
              jobId: int.parse(
                  _userHiveDatabase.getUserModel()!.currentJobId ?? ""),
              data: item!));
          await Future.delayed(const Duration(seconds: 2));
        }
        _userHiveOperation.deleteJobStopAsync();
      }

      if (resultJobUpdate.isNotEmpty &&
          resultJobUpdate != {} &&
          resultJobUpdate != [] &&
          _userHiveDatabase.getUserModel() != null) {
        for (var item in resultJobUpdate) {
          context.read<HomeBloc>().add(UpdateJob(
              _userHiveDatabase.getUserModel()!.currentJobId ?? "",
              item!,
              true));
          await Future.delayed(const Duration(seconds: 2));
        }

        _userHiveOperation.deleteJobUpdates();
      }
      final List<int> jobInspectionsId = ProductStateItems.hiveDatabaseManager
              .getUserModel()
              ?.inspectionsJobId ??
          [];

      // print('jobInspectionsId: $jobInspectionsId');

      for (var id in jobInspectionsId) {
        try {
          final resultInspection =
              await _userHiveOperation.getChecklistPostModel(id);
          // print('resultInspectionChekList: $resultInspection');
          if (resultInspection.isNotEmpty) {
            await Future.forEach(resultInspection, (item) async {
              context
                  .read<InspectionsBloc>()
                  .add(PostJobInspectionsCheckList(item!, true, false, null));
              await Future.delayed(const Duration(seconds: 2));
            });
            await _userHiveOperation.deleteChecklistPostModel(id);
          }

          /*
          final resultInspectionPatch =
              await _userHiveOperation.getConditionImagePostModel(id);
          print('resultInspectionConditionsImage: $resultInspectionPatch');
          if (resultInspectionPatch != null &&
              resultInspectionPatch.isNotEmpty) {
            await Future.forEach(resultInspectionPatch, (item) async {
              context.read<InspectionsBloc>().add(PostConditionImages(
                  data: item!, jobInspectionId: id, isAsync: true));
              await Future.delayed(const Duration(seconds: 2));
            });
            await _userHiveOperation.deleteConditionImagePostModel(id);
          }
*/
          final resultInspectionEditDetail =
              await _userHiveOperation.getInspectionDetails(id);
          // print('resultInspectionEditDetail: $resultInspectionEditDetail');
          if (resultInspectionEditDetail.isNotEmpty) {
            await Future.forEach(resultInspectionEditDetail, (item) async {
              context.read<InspectionsBloc>().add(InspectionsItemDetail(
                    odoReading: item!.odoReading,
                    fuelLevel: item.fuelLevel,
                    inspectionId: item.inspectionId,
                    isAsync: true,
                  ));
              await Future.delayed(const Duration(seconds: 2));
            });
            await _userHiveOperation.removeInspectionDetailsRecord(id);
          }

          final resultInspectionEdit =
              await _userHiveOperation.getDamagePostModel(id);

          if (resultInspectionEdit.isNotEmpty) {
            await Future.forEach(resultInspectionEdit, (item) async {
              context.read<InspectionsBloc>().add(
                  PostJobInspectionsDamagesRemote(data: item!, isAsync: true));
              await Future.delayed(const Duration(seconds: 2));
            });
            await _userHiveOperation.deleteDamagePostModel(id);
          }

          final resultInspectionCustomerSign =
              await _userHiveOperation.getSignCustomerPostModel(id);
          final resultInspectionSign =
              await _userHiveOperation.getSignInspectorPostModel(id);
          // print('resultInspectionSign $resultInspectionCustomerSign');

          if (resultInspectionCustomerSign != null) {
            context.read<InspectionsBloc>().add(PostJobInspectionsCustomerSign(
                  jobInspectionId: id,
                  data: resultInspectionCustomerSign,
                  isAsync: true,
                ));
            await Future.delayed(const Duration(seconds: 1));

            context.read<InspectionsBloc>().add(PostInspectionSign(
                  jobInspectionId: id,
                  data: resultInspectionSign!,
                  isAsync: true,
                ));
            await Future.delayed(const Duration(seconds: 2));

            await _userHiveOperation.clearAllSignCustomerPostModels();
            await _userHiveOperation.clearAllSignInspectorPostModels();
          }
        } catch (e, s) {
          await SentryErrorHandler.instance.capture(e, stackTrace: s);
          // Hata meydana gelirse, devam edebilir veya döngüyü durdurabilirsiniz.
          // Burada nasıl davranmak istediğinize karar verin.
        }
      }
      //future delaye ekle
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Ferris',
      locale: context.locale,
      theme: context.watch<ThemeNotifier>().currentTheme,
      darkTheme: CustomDarkTheme().themeData,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      routerConfig: ProductStateItems.appRouter.router,
      builder: BotToastInit(),
    );
  }
}
