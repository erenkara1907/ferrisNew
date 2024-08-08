import 'package:ferrisfwt/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/job_damage/job_damage_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/job_expense/job_expense_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/stop_job/stop_job_bloc.dart';
import 'package:ferrisfwt/feature/inspections/presentation/bloc/inspections_bloc.dart';
import 'package:ferrisfwt/feature/landing/presentation/view/landing_page.dart';
import 'package:ferrisfwt/feature/profile/presantation/cubit/permissions_cubit.dart';
import 'package:ferrisfwt/product/database/hive/core/hive_database_manager.dart';
import 'package:ferrisfwt/product/manager/location/location_service_manager.dart';
import 'package:ferrisfwt/product/mixin/network_mixin.dart';
import 'package:ferrisfwt/product/state/base/mixin/base_mixin.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

mixin LandingMixin on BaseMixin<LandingPage> {
  late final HiveDatabaseManager userHiveOperation;

  bool checkedLogin = false;

  Future<void> checkUserLogin() async {
    if (!checkedLogin) {
      final user = userHiveOperation.getUserModel()?.token;
      if (user != null && user != "") {
        if (!await LocationServiceManager().isServiceStarted()) {
          await LocationServiceManager().startService();
        }
        await checkLoginStatus();
      } else {
        context.go('/sign_in_page');
      }
      checkedLogin = true; // Marking login as checked
    }
  }

  Future<void> checkLoginStatus() async {
    final user = userHiveOperation.getUserModel();
    context.read<CubitPermissions>().checkPermissions();
    await checkInternetConnection();
    context.read<AuthBloc>().add(const SetDeviceIdEvent());
    context.read<HomeBloc>().add(const GetJobs());
    context.read<HomeBloc>().add(const GetJobTomorrow());
    context.read<HomeBloc>().add(const GetJobsValet());
    context.read<HomeBloc>().add(const GetJobHistory());
    context.read<StopJobBloc>().add(const GetJobStopsCategories());
    context.read<JobExpenseBloc>().add(const GetExpenseCategories());
    // context.read<JobDamageBloc>().add(const GetDamageCategories());
    // context.read<JobDamageBloc>().add(const GetDamageIssues());
    // context.read<JobDamageBloc>().add(const GetDamageFailures());
    // context.read<JobDamageBloc>().add(const GetDamageParts());
    // context.read<JobDamageBloc>().add(const GetDamageRepairs());
    context.read<StopJobBloc>().add(const SetJobStop());

    context.read<AuthBloc>().add(const GetUserEvent());
    if (userHiveOperation.getUserModel()?.currentJobId != null &&
        userHiveOperation.getUserModel()?.currentJobId != "") {
      context
          .read<JobExpenseBloc>()
          .add(GetJobExpenses(jobId: int.parse(user?.currentJobId ?? "0")));
      context.read<InspectionsBloc>().add(GetJobInspections(
          jobId: int.parse(user?.currentJobId ?? "0"),
          regnNumber: ProductStateItems.hiveDatabaseManager
              .getUserModel()!
              .regnNumber));
    }
  }

  Future<void> checkInternetConnection() async {
    final userHiveOperation = ProductStateItems.hiveStorageManager;
    final userHiveDatabase = ProductStateItems.hiveDatabaseManager;
    if (ProductStateItems.hiveDatabaseManager.getUserModel()?.isStarted ==
        false) return;
    var connectivityResult = await hasNetwork();
    if (connectivityResult) {
      final result = await userHiveOperation.getJobExpenseAsync();
      print('result: $result');

      final resultStop = await userHiveOperation.getJobStopAsync();

      print('resultStop: $resultStop');

      final resultJobUpdate = await userHiveOperation.getJobUpdate();

      print('resultJobUpdate: $resultJobUpdate');

      final resultPatch = await userHiveOperation.getJobExpensePatchAsync();

      print('resultPatch: $resultPatch');

      if (result != [] && result.isNotEmpty && result != {}) {
        for (var item in result) {
          context.read<JobExpenseBloc>().add(PostExpense(item!, true));
          await Future.delayed(const Duration(seconds: 5));
        }
        await Future.delayed(const Duration(seconds: 5));

        if (resultPatch.isNotEmpty &&
            resultPatch != {} &&
            resultPatch != [] &&
            userHiveDatabase.getUserModel() != null) {
          for (var item in resultPatch) {
            context.read<JobExpenseBloc>().add(PatchExpense(item!, true, 0));
            await Future.delayed(const Duration(seconds: 5));
          }
          userHiveOperation.deleteJobExpensePatchAsync();
        }

        userHiveOperation.deleteJobExpenseAsync();
      }

      if (resultStop != [] &&
          resultStop.isNotEmpty &&
          resultStop != {} &&
          userHiveDatabase.getUserModel() != null) {
        for (var item in resultStop) {
          if (context.mounted) {
            context.read<StopJobBloc>().add(PostJobStops(
                isAsync: true,
                jobId: int.parse(
                    userHiveDatabase.getUserModel()!.currentJobId ?? ""),
                data: item!));
          }
          await Future.delayed(const Duration(seconds: 2));
        }
        userHiveOperation.deleteJobStopAsync();
      }

      if (resultJobUpdate.isNotEmpty &&
          resultJobUpdate != {} &&
          resultJobUpdate != [] &&
          userHiveDatabase.getUserModel() != null) {
        for (var item in resultJobUpdate) {
          context.read<HomeBloc>().add(UpdateJob(
              userHiveDatabase.getUserModel()!.currentJobId ?? "",
              item!,
              true));
          await Future.delayed(const Duration(seconds: 2));
        }

        userHiveOperation.deleteJobUpdates();
      }
      final List<int> jobInspectionsId = ProductStateItems.hiveDatabaseManager
              .getUserModel()
              ?.inspectionsJobId ??
          [];

      print('jobInspectionsId: $jobInspectionsId');

      for (var id in jobInspectionsId) {
        try {
          final resultInspection =
              await userHiveOperation.getChecklistPostModel(id);
          print('resultInspectionChekList: $resultInspection');
          if (resultInspection.isNotEmpty) {
            await Future.forEach(resultInspection, (item) async {
              context
                  .read<InspectionsBloc>()
                  .add(PostJobInspectionsCheckList(item!, true, false, null));
              await Future.delayed(const Duration(seconds: 2));
            });
            await userHiveOperation.deleteChecklistPostModel(id);
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
              await userHiveOperation.getInspectionDetails(id);
          print('resultInspectionEditDetail: $resultInspectionEditDetail');
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
            await userHiveOperation.removeInspectionDetailsRecord(id);
          }

          final resultInspectionEdit =
              await userHiveOperation.getDamagePostModel(id);
          print('resultInspectionDamage $resultInspectionEdit');
          if (resultInspectionEdit.isNotEmpty) {
            await Future.forEach(resultInspectionEdit, (item) async {
              context
                  .read<InspectionsBloc>()
                  .add(PostJobInspectionsDamages(data: item!, isAsync: true));
              await Future.delayed(const Duration(seconds: 2));
            });
            await userHiveOperation.deleteDamagePostModel(id);
          }

          final resultInspectionCustomerSign =
              await userHiveOperation.getSignCustomerPostModel(id);
          final resultInspectionSign =
              await userHiveOperation.getSignInspectorPostModel(id);
          print('resultInspectionSign $resultInspectionCustomerSign');

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

            await userHiveOperation.clearAllSignCustomerPostModels();
            await userHiveOperation.clearAllSignInspectorPostModels();
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

  void checkJobModule() {
    if (userHiveOperation.getUserModel() == null) {
      context.go('/sign_in_page');
      return;
    }
    if (userHiveOperation.getUserModel()?.isStarted == true &&
        userHiveOperation.getUserModel()?.currentJobId != null) {
      context.go('/job_detail_page', extra: {
        'jobId': userHiveOperation.getUserModel()?.currentJobId,
        'asyncJob': true
      });
      context.read<HomeBloc>().add(const SetTrackingCoordinate());
      context.read<StopJobBloc>().add(const SetJobStopCategories());
      context.read<JobExpenseBloc>().add(const SetExpenseCategories());
      context.read<JobDamageBloc>().add(const SetDamageCategories());
      context.read<InspectionsBloc>().add(const SetInspections());
      context.read<HomeBloc>().add(const SetValetJob());
      context.read<StopJobBloc>().add(const SetJobStop());
      context.read<JobExpenseBloc>().add(SetExpensePost(
            int.parse(userHiveOperation.getUserModel()!.currentJobId ?? "0"),
          ));
    }
  }
}
