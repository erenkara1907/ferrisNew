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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await ApplicationInitialize().make();
  FlutterError.onError = (FlutterErrorDetails details) {
    //FirebaseCrashlytics.instance.recordFlutterFatalError(details);

    if (details.library == 'image resource service' &&
        (details.exception.toString().contains('404') ||
            details.exception.toString().contains("Invalid"))) {
      return;
    }
    Sentry.captureException(details.exception, stackTrace: details.stack);
    FlutterError.presentError(details);
  };
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://5a101e43010540dc8fb5247780c8b7f8@o4507728913956864.ingest.de.sentry.io/4507743999492176';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      options.attachScreenshot = true;
      // options.beforeScreenshot = (event, {hint}) {
      //   // Return false if you don't want to attach the screenshot based on some condition.
      //   return true;
      // };
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.attachViewHierarchy = true;
      options.enableAutoPerformanceTracing = true;
    },
    appRunner: () => runApp(
      SentryWidget(
        child: ProductLocalization(
          child: const StateInitialize(
            child: _MyApp(),
          ),
        ),
      ),
    ),
  );
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

    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
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
      var connectivityResult = await hasNetwork();
      if (connectivityResult) {
        final currentJobId =
            ProductStateItems.hiveDatabaseManager.getUserModel()?.currentJobId;

        print("currentJob Id : $currentJobId");

        if (currentJobId != null && context.mounted) {
          final position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          await Future.delayed(const Duration(seconds: 1));
          context.read<HomeBloc>().add(UpdateTrackingCoordinate(
                jobId: int.parse(currentJobId),
                latitude: position.latitude,
                longitude: position.longitude,
              ));
        }
      } else {}
    } on PermissionDeniedException catch (_) {
      // print('permission');
    } on LocationServiceDisabledException catch (_) {
      // print('location');
    } catch (e) {
      // print('catchhh $e');
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
/*
          final resultInspectionEdit =
              await _userHiveOperation.getDamagePostModel(id);
          print('resultInspectionDamage $resultInspectionEdit');
          if (resultInspectionEdit != null && resultInspectionEdit.isNotEmpty) {
            await Future.forEach(resultInspectionEdit, (item) async {
              context
                  .read<InspectionsBloc>()
                  .add(PostJobInspectionsDamages(data: item!, isAsync: true));
              await Future.delayed(const Duration(seconds: 2));
            });
            await _userHiveOperation.deleteDamagePostModel(id);
          }

          */

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
        } catch (e) {
          print('Error occurred: $e');
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
