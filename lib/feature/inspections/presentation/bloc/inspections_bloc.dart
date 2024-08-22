// ignore_for_file: unused_local_variable, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_assets/damage_assets_model.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_categories/damage_category.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_failures/damage_failure.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_issues/damage_issue.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_parts/damage_part.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_repairs/damage_repair.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/gradle_item_model.dart';
import 'package:ferrisfwt/feature/inspections/data/models/checklist/checklist_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/condition_image/condition_image_response_model.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_abort_type_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspections_details_model.dart';
import 'package:ferrisfwt/feature/inspections/domain/usecases/uc_get_inspection_checklist.dart';
import 'package:ferrisfwt/feature/inspections/domain/usecases/uc_get_inspection_condition_images.dart';
import 'package:ferrisfwt/feature/inspections/domain/usecases/uc_get_inspection_damages.dart';
import 'package:ferrisfwt/feature/inspections/domain/usecases/uc_get_inspection_sign.dart';
import 'package:ferrisfwt/feature/inspections/domain/usecases/uc_get_job_inspections.dart';
import 'package:ferrisfwt/feature/inspections/presentation/widget/item_check_list_model.dart';
import 'package:ferrisfwt/product/database/hive/core/hive_database_manager.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/mixin/network_mixin.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/checklist/inspection_checklist_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/condition_image/inspection_condition_image_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_customer_sign_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_inspector_sign_post_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/Item_check_list_enum.dart';
import 'package:ferrisfwt/product/utility/enums/network_result.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:path_provider/path_provider.dart';

import '../../../home/data/models/damages/damage_combination/damage_combination_model.dart';
import '../../../home/data/models/job_start/job_start_model.dart';

part 'inspections_event.dart';
part 'inspections_state.dart';

class InspectionsBloc extends Bloc<InspectionsEvent, InspectionsState> {
  InspectionsBloc({
    required UCGetJobInspections ucGetJobInspections,
    required UCGetJobInspectionsSign ucGetJobInspectionsSign,
    required UCGetJobInspectionsDamages ucGetJobInspectionsDamages,
    required UCGetJobInspectionsCheckList ucGetJobInspectionsCheckList,
    required UCGetJobInspectionsConditionImages
        ucGetJobInspectionsConditionImages,
  })  : _ucGetJobInspections = ucGetJobInspections,
        _ucGetJobInspectionsSign = ucGetJobInspectionsSign,
        _ucGetJobInspectionsDamages = ucGetJobInspectionsDamages,
        _ucGetJobInspectionsCheckList = ucGetJobInspectionsCheckList,
        _ucGetJobInspectionsConditionImages =
            ucGetJobInspectionsConditionImages,
        super(const InspectionsState()) {
    _hiveStorageManager = ProductStateItems.hiveStorageManager;
    _hiveDatabaseManager = ProductStateItems.hiveDatabaseManager;
    on<GetJobInspections>(_onGetJobInspections);
    on<GetJobInspectionsCheckList>(_getJobInspectionsCheckList);
    on<PostJobInspectionsCheckList>(_postJobInspectionsCheckList);
    on<PostConditionImages>(_postConditionImages);
    on<DeleteConditionImage>(_deleteConditionImage);
    on<PostJobInspectionsDamages>(_postJobInspectionsDamages);
    on<PostJobInspectionsDamagesRemote>(_postJobInspectionsDamagesRemote);
    on<PostJobInspectionsDamagesControl>(_postJobInspectionsDamagesControl);
    on<PatchJobInspectionsDamages>(_patchJobInspectionsDamages);
    on<PostJobInspectionsCustomerSign>(_postJobInspectionsCustomerSign);
    on<PostInspectionSign>(_postInspectionSign);
    on<InspectionsItemDetail>(_onInspectionsItemDetail);
    on<SetInspections>(_onSetInspections);
    on<SetItemCheckList>(_setItemCheckList);
    // on<GetInspectionsDamagesCategory>(_getDamagesCategory);
    on<GetInspectionsDamagesFailure>(_getDamagesFailure);
    on<GetInspectionsDamagesIssue>(_getDamagesIssue);
    on<GetInspectionsDamagesPart>(_getDamagesPart);
    on<GetInspectionsDamagesRepair>(_getDamagesRepair);
    // on<GetInspectionsDamageCategories>(_getDamageCategories);
    on<GetInspectionsDamageAssets>(_getDamageAssets);
    on<CleanDamages>(_cleanDamages);
    on<SetDriverImage>(_setDriverImage);
    on<SetCustomerImage>(_setCustomerImage);
    on<SetGetDamages>(_setGetDamages);
    on<SetGetConditionImages>(_setGetConditionImages);
    on<SetLatLong>(_setLatLong);
    on<SetAddress>(_setAdress);
    on<ClearState>(_clearState);
    on<SetEditDetails>(_onSetEditDetails);
    on<ConditionsImagesEvent>(_onConditionImages);
    on<DeleteRecordedDamage>(_onDeleteRecordedDamage);
    on<UpdateDamageResponse>(_onUpdateDamageResponse);
    on<ClearInspection>(_clearInspection);
    on<ToggleButtonsEvent>(_onToggleButton);
  }

  final UCGetJobInspections _ucGetJobInspections;
  final UCGetJobInspectionsSign _ucGetJobInspectionsSign;
  final UCGetJobInspectionsDamages _ucGetJobInspectionsDamages;
  final UCGetJobInspectionsCheckList _ucGetJobInspectionsCheckList;
  final UCGetJobInspectionsConditionImages _ucGetJobInspectionsConditionImages;
  late final HiveStorageManager _hiveStorageManager;
  late final HiveDatabaseManager _hiveDatabaseManager;

  Future<void> _onToggleButton(
      ToggleButtonsEvent event, Emitter<InspectionsState> emit) async {
    emit(
      state.copyWith(areButtonsVisible: !state.areButtonsVisible),
    );
  }

  Future<void> _onSetEditDetails(
      SetEditDetails event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(
        odo: event.odo, fuelLevel: event.fuelLevel, gradeId: ""));
  }

  Future<void> _clearInspection(
      ClearInspection event, Emitter<InspectionsState> emit) async {
    emit(const InspectionsState());
  }

  // Future<void> _getDamageCategories(GetInspectionsDamageCategories event,
  //     Emitter<InspectionsState> emit) async {
  //   emit(state.copyWith(status: ViewStatus.loading));
  //   final result = await _hiveStorageManager.getDamageCategories();

  //   if (result != []) {
  //     emit(state.copyWith(
  //       getDamageCategoriesResponse: result,
  //       status: ViewStatus.success,
  //     ));
  //   }
  // }

  Future<void> _onConditionImages(
      ConditionsImagesEvent event, Emitter<InspectionsState> emit) async {
    state.conditionImages.add(event.conditionImage);
    List<File> updatedConditionImages = [];
    emit(state.copyWith(conditionImages: updatedConditionImages));
  }

  FutureOr<void> _onGetJobInspections(
      GetJobInspections event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(
        inspectionStatus: ViewStatus.loading, isSetInspection: false));
    final result = await hasNetwork();

    final inspections = await _hiveStorageManager.getInspectionsListModel();

    if (result) {
      final result = await _ucGetJobInspections.getJobInspections(
        jobId: event.jobId,
        regNumber: event.regnNumber,
      );

      result.fold(
        (failure) {
          emit(state.copyWith(
              failure: failure, inspectionStatus: ViewStatus.failure));
        },
        (data) {
          inspections.clear();
          if (inspections.isEmpty) {
            final List<int> inspectionsId = [];

            for (var element in data) {
              inspectionsId.add(element.id ?? 0);
            }

            _hiveDatabaseManager.saveInspectionsJobId(inspectionsId);
            _hiveStorageManager.setInspectionsListModel(data);
            emit(state.copyWith(
              inspectionStatus: ViewStatus.success,
              inspections: data,
            ));
            return;
          }
          if (inspections.length < data.length) {
            final List<int> inspectionsId = [];

            for (var element in data) {
              inspectionsId.add(element.id ?? 0);
            }
            _hiveDatabaseManager.saveInspectionsJobId(inspectionsId);
            _hiveStorageManager.setInspectionsListModel(data);
            emit(state.copyWith(
              inspectionStatus: ViewStatus.success,
              inspections: data,
            ));
            return;
          }

          // final updatedInspections = inspections.map((e) {
          //   return data
          //       .firstWhere(
          //         (element) => element.id == e?.id,
          //       )
          //       .copyWith(
          //         odoReading: data.odoReading,
          //         fuelLevel: e?.fuelLevel,
          //       );
          // }).toList();
          final updatedInspections = inspections.map((e) {
            var index = data.indexWhere((element) => element.id == e?.id);

            if (index != -1) {
              return data[index].copyWith(
                odoReading: data[index].odoReading,
                fuelLevel: data[index].fuelLevel,
              );
            } else {
              return e;
            }
          }).toList();

          _hiveStorageManager.setInspectionsListModel(updatedInspections);

          final List<int> inspectionsId = [];

          for (var element in data) {
            inspectionsId.add(element.id ?? 0);
          }

          _hiveDatabaseManager.saveInspectionsJobId(inspectionsId);

          emit(state.copyWith(
            inspectionStatus: ViewStatus.success,
            inspections: updatedInspections,
          ));
        },
      );
    } else {
      emit(state.copyWith(
          isSetInspection: true, inspectionStatus: ViewStatus.failure));
    }
  }

  Future<void> _getJobInspectionsCheckList(
      GetJobInspectionsCheckList event, Emitter<InspectionsState> emit) async {
    final resultNet = await hasNetwork();
    if (!resultNet) {
      return;
    }

    final result = await _ucGetJobInspectionsCheckList.getChecklists(
      inspectionId: event.inspectionId,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(status: ViewStatus.failure, failure: failure));
      },
      (data) {
        _hiveStorageManager.putInspectionChecklist(data);

        emit(state.copyWith(
          checklists: data,
        ));
      },
    );
  }

  Future<void> _postJobInspectionsCheckList(
      PostJobInspectionsCheckList event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await hasNetwork();
    if (result) {
      if (event.isUpdate) {
        final result = await _ucGetJobInspectionsCheckList.patchChecklist(
          checklistId: event.checklistId ?? 0,
          data: event.data,
        );

        result.fold(
          (failure) {
            emit(state.copyWith(status: ViewStatus.failure, failure: failure));
          },
          (data) {
            _hiveStorageManager.setItemCheckList(event.data);
            emit(state.copyWith(
              status: ViewStatus.success,
            ));
          },
        );
        return;
      }
      final result = await _ucGetJobInspectionsCheckList.postChecklist(
        data: event.data,
      );
      result.fold(
        (failure) {
          emit(state.copyWith(status: ViewStatus.failure, failure: failure));
        },
        (data) {
          if (event.isAsync) {
            emit(state.copyWith(
              status: ViewStatus.success,
            ));
            return;
          }
          _hiveStorageManager.setItemCheckList(event.data);
          emit(state.copyWith(
            status: ViewStatus.success,
          ));
        },
      );
    } else {
      if (event.isAsync) {
        emit(state.copyWith(status: ViewStatus.failure));
        return;
      }
      _hiveStorageManager.setChecklistPostModel(event.data);
      Future.delayed(const Duration(seconds: 2));
      _hiveStorageManager.setItemCheckList(event.data);
      emit(state.copyWith(
        status: ViewStatus.success,
      ));
    }
  }

  Future<void> _postConditionImages(
      PostConditionImages event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));

    final result = await hasNetwork();
    if (result) {
      // if (event.isAsync != true) {

      //   emit(state.copyWith(
      //     status: ViewStatus.success,
      //     conditionImageResponse: [result, ...state.conditionImageResponse],
      //   ));
      // }
      final result =
          await _ucGetJobInspectionsConditionImages.postConditionImage(
        data: event.data,
        jobInspectionId: event.jobInspectionId,
      );
      result.fold(
        (failure) {
          emit(state.copyWith(status: ViewStatus.failure, failure: failure));
        },
        (data) async {
          _hiveStorageManager.setConditionImagePostModel(event.data);

          final ConditionImageResponseModel result =
              ConditionImageResponseModel(
            // id: state.conditionImageResponse.length + 1,
            id: data.id,
            jobInspectionId: data.jobInspectionId,
            imagePath: data.imagePath,
          );

          emit(
            state.copyWith(
              status: ViewStatus.success,
              isSigned: true,
              conditionImageResponse: [result, ...state.conditionImageResponse],
            ),
          );

          await Future.delayed(const Duration(seconds: 2));
          _hiveStorageManager.replaceInspectionConditionImagesTable(result);
          _hiveStorageManager.addConditionImage(
            event.data,
          );
        },
      );
    } else {
      if (event.isAsync) {
        emit(state.copyWith(status: ViewStatus.failure));
        return;
      }
      _hiveStorageManager.setConditionImagePostModel(event.data);

      final ConditionImageResponseModel result = ConditionImageResponseModel(
        id: state.conditionImageResponse.length + 1,
        jobInspectionId: event.jobInspectionId ?? 0,
        imagePath: event.data.imageFile!.path,
      );

      await Future.delayed(const Duration(seconds: 2));
      _hiveStorageManager.replaceInspectionConditionImagesTable(result);
      _hiveStorageManager.addConditionImage(
        event.data,
      );
      emit(state.copyWith(
        status: ViewStatus.success,
        conditionImageResponse: [result, ...state.conditionImageResponse],
      ));
    }
  }

  Future<void> _deleteConditionImage(
      DeleteConditionImage event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));

    final result = await hasNetwork();

    if (result) {
      await _ucGetJobInspectionsConditionImages.deleteConditionImage(
          imageId: event.imageId);
    }

    print("IMAGE ID BLOC : ${event.imageId}");

    _hiveStorageManager.deleteInspectionConditionImage(event.imageId);

    _hiveStorageManager.deleteConditionImage(
        event.jobInspectionId, event.index);

    await Future.delayed(const Duration(seconds: 2));
    final List<ConditionImageResponseModel> conditionImageResponse =
        state.conditionImageResponse;

    conditionImageResponse
        .removeWhere((element) => element.id == event.imageId);
    emit(state.copyWith(
      status: ViewStatus.success,
      conditionImageResponse: conditionImageResponse,
    ));

    BotToast.showText(text: 'Image deleted successfully');
  }

  Future<void> _onDeleteRecordedDamage(
      DeleteRecordedDamage event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await hasNetwork();
    print("NETWORK : $result");
    if (result) {
      await _ucGetJobInspectionsDamages.deleteRecordedDamage(
          damageId: event.damageId);
    }

    _hiveStorageManager.deleteDamagePostModel(event.jobInspectionId);
    _hiveStorageManager.deleteGetDamage(event.jobInspectionId, event.damageId);
    final List<DamageResponseModel> damageResponse = state.damageResponse;
    await Future.delayed(const Duration(seconds: 1));
    damageResponse.removeWhere((element) => element.id == event.damageId);
    // print('damageResponse: $damageResponse');
    emit(state.copyWith(
      status: ViewStatus.success,
      damageResponse: damageResponse,
    ));

    BotToast.showText(text: 'Damage deleted successfully');
  }

  void _onUpdateDamageResponse(
      UpdateDamageResponse event, Emitter<InspectionsState> emit) {
    emit(state.copyWith(damageResponse: event.damages));
  }

  Future<void> _postJobInspectionsDamagesControl(
      PostJobInspectionsDamagesControl event,
      Emitter<InspectionsState> emit) async {
    emit(state.copyWith(isError: true));
  }

  Future<void> _postJobInspectionsDamagesRemote(
      PostJobInspectionsDamagesRemote event,
      Emitter<InspectionsState> emit) async {
    final result = await _ucGetJobInspectionsDamages.postDamage(
      data: event.data,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          failure: failure,
        ));
      },
      (data) {
        emit(
          state.copyWith(
            gradeId: data.gradeId ?? state.gradeId,
          ),
        );
      },
    );
  }

  String? getPriceForCombinationId(List<JobStartModel?> jobs,
      List<DamageCombinationModel?> damageCombinations, int combinationId) {
    // Önce combinationId'yi taşıyan job'u buluyoruz.
    JobStartModel? matchingJob = jobs.firstWhere(
      (job) => job?.combinationId == combinationId,
      orElse: () => null,
    );

    // Eşleşen job bulunduysa price değerini döndürüyoruz.
    return matchingJob?.price;
  }

  Future<void> _postJobInspectionsDamages(
      PostJobInspectionsDamages event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));

    String? _price = "0.0";
    // final inspectionList =
    //     await _hiveStorageManager.getInspectionsListModel();
    final currentInspectionId = event.jobInspectionId ?? 0;
    List<JobStartModel?> jobs = await _hiveStorageManager.getJobs();
    List<DamageCombinationModel?> damageCombinations =
        await _hiveStorageManager.getDamageCombination();

    print("JoBS STARted : $jobs");

    for (var damageCombination in damageCombinations) {
      if (damageCombination != null) {
        _price = getPriceForCombinationId(
            jobs, damageCombinations, damageCombination.id!);
        // print('Combination ID: ${damageCombination.id}, Price: $_price');
      }
    }

    print("PRICE : $_price");

    final gradeId = await findGrade(currentInspectionId);
    print("GRADE ID : $gradeId");

    if (event.isAsync) {
      emit(state.copyWith(status: ViewStatus.failure));
      return;
    }
    await _hiveStorageManager.setDamagePostModel(event.data);
    await Future.delayed(const Duration(seconds: 2));
    final categoryNmae = state.getDamageCategoriesResponse
        .firstWhere((element) => element?.id == event.data.categoryId);

    final partName = state.getDamagePartsResponse
        .firstWhere((element) => element.id == event.data.partId);

    final issueName = state.getDamageIssuesResponse
        .firstWhere((element) => element.id == event.data.issueId);

    final failureName = state.getDamageFailuresResponse
        .firstWhere((element) => element.id == event.data.failureId);

    final repairName = state.getDamageRepairsResponse
        .firstWhere((element) => element.id == event.data.repairId);

    final DamageResponseModel data = DamageResponseModel(
      id: Random().nextInt(10000),
      jobInspectionId: event.data.jobInspectionId,
      categoryId: DamagesCategory(
          id: event.data.categoryId, name: categoryNmae?.name ?? ''),
      partId: DamagesPart(
          id: event.data.partId,
          name: partName.name ?? '',
          categoryId: event.data.categoryId),
      issueId: DamagesIssue(
          id: event.data.issueId,
          name: issueName.name ?? "",
          partId: event.data.partId),
      failureId: DamagesFailure(
          id: event.data.failureId,
          name: failureName.name ?? "",
          issueId: event.data.issueId),
      repairId: DamagesRepair(
          id: event.data.repairId,
          name: repairName.name ?? "",
          failureId: event.data.failureId),
      damageImage: event.data.damageImage?.path ?? '',
      contextImage: event.data.contextImage?.path ?? '',
      gradeId: gradeId != null ? "G${gradeId.toString()}" : "G${state.gradeId}",
      price: double.parse(_price ?? "0.0"),
    );
    _hiveStorageManager.setGetDamage(data);

    _hiveStorageManager.setRecordedDamage(event.data);

    List<JobInspectionResponseModelItem?> inspecList =
        await _hiveStorageManager.getInspectionsListModel();
    state.getDamageCategoriesResponse.clear();
    state.getDamagePartsResponse.clear();
    state.getDamageIssuesResponse.clear();
    state.getDamageFailuresResponse.clear();
    state.getDamageRepairsResponse.clear();

    JobInspectionResponseModelItem? jobInspection =
        await _hiveStorageManager.getInspectionById(event.data.jobInspectionId);

    emit(
      state.copyWith(
        status: ViewStatus.success,
        damageResponse: [data, ...state.damageResponse],
        isError: false,
        inspections: inspecList,
        gradeId: gradeId != null
            ? "G$gradeId"
            : jobInspection!.gradleItem != null
                ? jobInspection.gradleItem!.name
                : "-",
      ),
    );
  }

  // Future<int?> findGrade(int jobInspectionId) async {
  //   // JobInspection tablosunda grade_id'yi null yapıyoruz.
  //   // await _hiveStorageManager.updateJobInspectionGrade(jobInspectionId, null);

  //   final inspections = await _hiveStorageManager.getInspectionsListModel();
  //   final grades = await _hiveStorageManager.getGrades();
  //   final gradeRules = await _hiveStorageManager.getGradeRules();

  //   final gradeRuleUplifts = await _hiveStorageManager.getGradeRuleUplifts();
  //   final damageCombinations = await _hiveStorageManager.getDamageCombination();

  //   // Eğer Damage tablosunda ilgili jobInspectionId ile ilgili bir veri yoksa false döndür.
  //   final hasDamage =
  //       inspections.any((inspection) => inspection?.id == jobInspectionId);
  //   if (!hasDamage) {
  //     return null;
  //   }

  //   // JobInspection nesnesini alıyoruz.
  //   final jobInspection = inspections
  //       .firstWhere((inspection) => inspection?.id == jobInspectionId);

  //   // jobId'ye göre ilgili Grade'leri sıralıyoruz.
  //   final relatedGrades = grades
  //       .where((grade) =>
  //           grade?.subClientId!.id == jobInspection?.jobId?.clientId!.id)
  //       .toList()
  //     ..sort((a, b) => a!.order!.compareTo(b!.order!));

  //   // Grade'leri döngü ile kontrol ediyoruz.
  //   for (final grade in relatedGrades) {
  //     final gradeRulesForCurrentGrade =
  //         gradeRules.where((rule) => rule!.gradeId == grade!.id).toList();

  //     print(
  //         "GRADE RULES FOR CURRENT GRADE : ${gradeRulesForCurrentGrade.length}");

  //     for (final rule in gradeRulesForCurrentGrade) {
  //       final requiredDamageCombinationId = rule?.requiredDamageCombinationId;
  //       final requiredDamageCombinationCount =
  //           rule?.requiredDamageCombinationCount ?? 0;

  //       // inspections listesinden ilgili kombinasyon sayısını buluyoruz.

  //       int inspectionsDamageCountByCombination =
  //           inspections.where((inspection) {
  //         // print("INSPECTION : $inspection");
  //         // print(
  //         //     "INSPECTION DAMAGE : ${inspection != null ? inspection.damages : false}");
  //         return inspection?.id == jobInspectionId &&
  //             (inspection != null
  //                 ? inspection.damages != null
  //                     ? inspection.damages!.any((damage) {
  //                         print(
  //                             "COMBINATION ID : ${damage.damageCombinationId.id}");
  //                         return damage.damageCombinationId.id ==
  //                             requiredDamageCombinationId;
  //                       })
  //                     : false
  //                 : false);
  //       }).length;

  //       // Eğer hasar kombinasyon sayısı gerekli sayıya eşit veya büyükse...
  //       if (inspectionsDamageCountByCombination >=
  //           requiredDamageCombinationCount) {
  //         // Mevcut JobInspection nesnesini tekrar alıyoruz.
  //         final currentJobInspection = inspections
  //             .firstWhere((inspection) => inspection?.id == jobInspectionId);

  //         final currentJobInspectionOrder = currentJobInspection?.gradleItem !=
  //                 null
  //             ? grades
  //                     .firstWhere(
  //                         (g) => g?.id == currentJobInspection?.gradleItem!.id)
  //                     ?.order ??
  //                 0
  //             : 0;

  //         print("currentJobInspectionOrder : $currentJobInspectionOrder");

  //         // Eğer bu grade'nin sırası mevcut olandan büyükse, grade_id'yi güncelle.
  //         if (grade!.order != null &&
  //             grade.order! > currentJobInspectionOrder) {
  //           // await _hiveStorageManager.updateJobInspectionGrade(
  //           //     jobInspectionId, grade.id);

  //           await _hiveStorageManager.updateInspectionsListModel(
  //             JobInspectionResponseModelItem(
  //               id: jobInspectionId,
  //               gradleItem: GradeId(
  //                 name: grade.name,
  //                 order: grade.order,
  //                 id: grade.id,
  //               ),
  //             ),
  //           );

  //           print("NEW GRADE ID : ${grade.id}");
  //           // return grade.id!;
  //         }

  //         // Eğer kurala bağlı uplifts varsa, bunları da kontrol ediyoruz.
  //         final upliftsForCurrentRule = gradeRuleUplifts
  //             .where((uplift) => uplift?.gradeRuleId == rule?.id)
  //             .toList();

  //         if (upliftsForCurrentRule.isNotEmpty) {
  //           for (final uplift in upliftsForCurrentRule) {
  //             final upliftRequiredDamageCombinationCount =
  //                 uplift?.requiredDamageCombinationCount ?? 0;
  //             final upliftToGradeId = uplift?.upToGradeId;

  //             // Eğer hasar kombinasyon sayısı uplift için yeterliyse...
  //             if (inspectionsDamageCountByCombination >=
  //                 upliftRequiredDamageCombinationCount) {
  //               final upliftGrade =
  //                   grades.firstWhere((g) => g?.id == upliftToGradeId);
  //               final upliftGradeOrder = upliftGrade?.order ?? 0;

  //               if (upliftGradeOrder > currentJobInspectionOrder) {
  //                 print("NEW GRADE UPLIFT ID : ${upliftGrade!.id}");
  //                 // await _hiveStorageManager.updateJobInspectionGrade(
  //                 //     jobInspectionId, upliftToGradeId);

  //                 await _hiveStorageManager.updateInspectionsListModel(
  //                   JobInspectionResponseModelItem(
  //                     id: jobInspectionId,
  //                     gradleItem: GradeId(
  //                       name: upliftGrade.name,
  //                       order: upliftGrade.order,
  //                       id: upliftGrade.id,
  //                     ),
  //                   ),
  //                 );
  //                 return upliftGrade.id!;
  //               }
  //             }
  //           }
  //         }
  //       }
  //     }
  //   }
  //   print("EMPTY NULL");
  //   return null;
  // }

  Future<int?> findGrade(int jobInspectionId) async {
    // 1. JobInspection tablosunda grade_id alanını null olarak güncelle.
    // await _hiveStorageManager.setGradeId(jobInspectionId, null);
    // 2. Eğer bu iş denetimi ile ilgili herhangi bir hasar yoksa false döndür.
    final inspections = await _hiveStorageManager.getInspectionsListModel();

    // print("Job Inspection Id : $jobInspectionId");

    // for (var insp in inspections) {
    //   for (var damage in insp!.damages!) {
    //     print("Combination Id : ${damage.damageCombinationId.id}");
    //   }
    // }

    final hasDamage = inspections.any((d) => d!.id == jobInspectionId);
    if (!hasDamage) {
      return null;
    }
    // 3. JobInspection ve ilişkili verileri al.
    final jobInspection =
        inspections.firstWhere((j) => j!.id == jobInspectionId);
    final grades = await _hiveStorageManager.getGrades();
    final gradeRules = await _hiveStorageManager.getGradeRules();
    final gradeRuleUplifts = await _hiveStorageManager.getGradeRuleUplifts();
    final damageCombinations = await _hiveStorageManager.getDamageCombination();
    // 4. Grade seviyelerini sırayla kontrol et.
    for (var grade in grades) {
      for (var rule in gradeRules) {
        // rule.gradeId == grade.id
        if (grade!.id == rule!.gradeId) {
          print("GRADE ID : ${grade.id} , RULE GRADE ID : ${rule.gradeId}");
          final requiredDamageCombinationId =
              rule.requiredDamageCombinationId; // Grade'göre grade kuralı getir
          final requiredDamageCombinationCount =
              rule.requiredDamageCombinationCount;
          // 5. Hasarların kombinasyon sayılarını kontrol et.
          final inspectionsDamageCountByCombination = inspections
              .where((d) =>
                  d!.id == jobInspectionId &&
                  damageCombinations
                      .any((dc) => dc!.id == requiredDamageCombinationId))
              .length;

          final matchingDamageCombinationId = inspections
              .where((d) =>
                  d!.id == jobInspectionId &&
                  damageCombinations
                      .any((dc) => dc!.id == requiredDamageCombinationId))
              .firstOrNull; // Eğer eşleşen bir id yoksa null döner

          if (matchingDamageCombinationId != null) {
            // print(
            //     "Eşleşen Damage Combination ID: ${matchingDamageCombinationId} Required : $requiredDamageCombinationId");
          } else {
            print("Eşleşen Damage Combination ID bulunamadı.");
          }

          if (inspectionsDamageCountByCombination >=
              requiredDamageCombinationCount!) {
            // 6. Mevcut JobInspection'ı ve gradeId'sini al.
            final currentJobInspection = jobInspection;
            final currentJobInspectionOrder =
                currentJobInspection!.gradleItem != null
                    ? grades
                        .firstWhere((g) =>
                            g!.id == currentJobInspection.gradleItem!.id)!
                        .order
                    : 0;
            // 7. Yeni Grade, mevcut Grade'den yüksekse, JobInspection tablosunda grade_id'yi güncelle.
            if (grade.order! > currentJobInspectionOrder!) {
              // await _hiveStorageManager.setGradeId(jobInspectionId, grade.id);
              print("NEW GRADE ID : ${grade.id}");
              await _hiveStorageManager.updateInspectionsListModel(
                JobInspectionResponseModelItem(
                  id: jobInspectionId,
                  gradleItem: GradeId(
                    name: grade.name,
                    order: grade.id,
                    id: grade.id,
                  ),
                ),
              );
              return grade.id!;
            }
            // 8. Eğer uplift varsa, kontrol et ve güncelle.
            if (gradeRuleUplifts.isNotEmpty) {
              for (var uplift in gradeRuleUplifts) {
                if (rule.gradeId == uplift!.upToGradeId) {
                  final upliftRequiredDamageCombinationCount = uplift
                      .requiredDamageCombinationCount; // GradeRuleId ile graderuleuplift eşleşmeli
                  final upliftToGradeId = uplift.gradeRuleId;

                  if (inspectionsDamageCountByCombination >=
                      upliftRequiredDamageCombinationCount!) {
                    final upliftGrade =
                        grades.firstWhere((g) => g!.id == upliftToGradeId);
                    if (upliftGrade!.order! > currentJobInspectionOrder) {
                      print("NEW GRADE ID UPLIFT : ${grade.id}");
                      return grade.id;

                      // await _hiveStorageManager.setGradeId(
                      //     jobInspectionId, upliftToGradeId);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return null;
  }

  Future<void> _patchJobInspectionsDamages(
      PatchJobInspectionsDamages event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await hasNetwork();
    if (result) {
      final result = await _ucGetJobInspectionsDamages.patchDamage(
        damageId: event.data.damageId ?? 0,
        data: event.data,
      );

      result.fold(
        (failure) {
          emit(state.copyWith(status: ViewStatus.failure, failure: failure));
        },
        (data) {
          final List<DamageResponseModel> damageResponse = state.damageResponse;

          damageResponse
              .removeWhere((element) => element.id == event.data.damageId);

          damageResponse.add(data.newDamage);

          //   _hiveStorageManager.updateGetDamage(data.newDamage);

          emit(state.copyWith(
            status: ViewStatus.success,
            damageResponse: damageResponse,
          ));
        },
      );
    } else {
      final List<DamageResponseModel> damageResponse = state.damageResponse;

      damageResponse
          .removeWhere((element) => element.id == event.data.damageId);

      final DamageResponseModel data = DamageResponseModel(
          id: Random().nextInt(10000),
          jobInspectionId: event.jobInspectionId ?? 0,
          categoryId:
              DamagesCategory(id: event.data.categoryId ?? 0, name: 'category'),
          partId: DamagesPart(
              id: event.data.partId ?? 0,
              name: 'part',
              categoryId: event.data.categoryId ?? 0),
          issueId: DamagesIssue(
              id: event.data.issueId ?? 0,
              name: 'issue',
              partId: event.data.partId ?? 0),
          failureId: DamagesFailure(
              id: event.data.failureId ?? 0,
              name: 'failure',
              issueId: event.data.issueId ?? 0),
          repairId: DamagesRepair(
              id: event.data.repairId ?? 0,
              name: 'repair',
              failureId: event.data.failureId ?? 0),
          damageImage: event.data.damageImage?.path ?? '',
          contextImage: event.data.contextImage?.path ?? '',
          price: 0.0);

      damageResponse.add(data);

      //    _hiveStorageManager.updateGetDamage(data);
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(
        status: ViewStatus.success,
        damageResponse: damageResponse,
      ));
    }
  }

  Future<void> _postJobInspectionsCustomerSign(
      PostJobInspectionsCustomerSign event,
      Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await hasNetwork();
    if (result) {
      final result = await _ucGetJobInspectionsSign.postCustomerSign(
        inspectionId: event.jobInspectionId,
        data: event.data,
      );

      result.fold(
        (failure) {
          emit(state.copyWith(status: ViewStatus.failure, failure: failure));
        },
        (data) {
          if (event.isAsync) {
            // emit(state.copyWith(
            //   status: ViewStatus.success,
            // ));
            return;
          }
          // emit(state.copyWith(
          //   status: ViewStatus.success,
          // ));
        },
      );
    } else {
      if (event.isAsync) {
        emit(state.copyWith(status: ViewStatus.failure));
        return;
      }
      _hiveStorageManager.setSignCustomerPostModel(
          event.data, event.jobInspectionId);
      // await Future.delayed(const Duration(seconds: 2));
      // emit(state.copyWith(
      //   status: ViewStatus.success,
      // ));
    }
  }

  Future<void> _postInspectionSign(
      PostInspectionSign event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading, isSigned: false));
    final result = await hasNetwork();
    if (result) {
      // final resultInspectionPatch = await ProductStateItems.hiveStorageManager
      //     .getConditionImagePostModel(event.jobInspectionId);

      // print("PATCH : ${resultInspectionPatch.isEmpty}");
      // if (resultInspectionPatch.isNotEmpty) {
      //   await Future.forEach(resultInspectionPatch, (item) async {
      //     add(PostConditionImages(
      //         data: item!,
      //         jobInspectionId: event.jobInspectionId,
      //         isAsync: true));
      //     await Future.delayed(const Duration(seconds: 2));
      //   });

      //   final resultInspectionEdit = await ProductStateItems.hiveStorageManager
      //       .getDamagePostModel(event.jobInspectionId);
      //   // print('resultInspectionDamage $resultInspectionEdit');
      //   if (resultInspectionEdit.isNotEmpty) {
      //     await Future.forEach(resultInspectionEdit, (item) async {
      //       add(PostJobInspectionsDamages(data: item!, isAsync: true));
      //       await Future.delayed(const Duration(seconds: 1));
      //     });
      //     await ProductStateItems.hiveStorageManager
      //         .deleteDamagePostModel(event.jobInspectionId);
      //   }

      //   // Await the deletion operation to ensure it's completed
      //   await ProductStateItems.hiveStorageManager
      //       .deleteConditionImagePostModel(event.jobInspectionId);
      // }
      final result = await _ucGetJobInspectionsSign.postInspectorSign(
        inspectionId: event.jobInspectionId,
        data: event.data,
      );

      result.fold(
        (failure) {
          emit(state.copyWith(
              status: ViewStatus.failure, failure: failure, isSigned: false));
        },
        (data) {
          _hiveDatabaseManager.saveInspectionsSign(event.jobInspectionId);
          BotToast.showText(text: 'Signed successfully');
          emit(state.copyWith(
            status: ViewStatus.success,
            isSigned: true,
          ));
        },
      );
    } else {
      _hiveStorageManager.setSignInspectorPostModel(
          event.data, event.jobInspectionId);
      await Future.delayed(const Duration(seconds: 2));
      _hiveDatabaseManager.saveInspectionsSign(event.jobInspectionId);
      emit(state.copyWith(
        status: ViewStatus.success,
        isSigned: true,
      ));
      BotToast.showText(text: 'Signed successfully');
    }
  }

  Future<void> _onInspectionsItemDetail(
      InspectionsItemDetail event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await hasNetwork();
    if (result) {
      final result = await _ucGetJobInspections.postDetails(
        inspectionId: event.inspectionId,
        odoReading: event.odoReading,
        fuelLevel: event.fuelLevel,
      );

      result.fold(
        (failure) {
          emit(state.copyWith(status: ViewStatus.failure, failure: failure));
        },
        (data) {
          final List<JobInspectionResponseModelItem?> updatedInspection =
              state.inspections
                  .map((e) => e?.id == event.inspectionId
                      ? e?.copyWith(
                          odoReading: event.odoReading,
                          fuelLevel: event.fuelLevel,
                        )
                      : e)
                  .toList();

          _hiveStorageManager.setInspectionsListModel(updatedInspection);

          emit(state.copyWith(
            status: ViewStatus.success,
            inspections: updatedInspection,
            odo: event.odoReading,
            fuelLevel: event.fuelLevel,
          ));
        },
      );
    } else {
      _hiveStorageManager.putInspectionDetails(
        InspectionDetailsPostModel(
          odoReading: event.odoReading,
          fuelLevel: event.fuelLevel,
          inspectionId: event.inspectionId,
        ),
      );

      final List<JobInspectionResponseModelItem?> updatedInspection =
          state.inspections
              .map((e) => e?.id == event.inspectionId
                  ? e?.copyWith(
                      odoReading: event.odoReading,
                      fuelLevel: event.fuelLevel,
                    )
                  : e)
              .toList();

      _hiveStorageManager.setInspectionsListModel(updatedInspection);

      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(
        status: ViewStatus.success,
        inspections: updatedInspection,
        odo: event.odoReading,
        fuelLevel: event.fuelLevel,
      ));
    }
  }

  Future<void> _onSetInspections(
      SetInspections event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final inspections = await _hiveStorageManager.getInspectionsListModel();
    await Future.delayed(const Duration(seconds: 2));
    // print('inspections: $inspections');
    emit(state.copyWith(
      inspections: inspections,
      status: ViewStatus.success,
    ));
  }

  void _setItemCheckList(
      SetItemCheckList event, Emitter<InspectionsState> emit) async {
    final List<ChecklistItemOption> selectedChecklist = [];
    final checkList = ItemChecklistModel.emptyForm.length;

    for (int i = 0; i < checkList; i++) {
      if (i == event.data.index) {
        selectedChecklist.add(event.data);
      } else {
        null;
      }
    }
  }

  Future<void> _getDamagesFailure(GetInspectionsDamagesFailure event,
      Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result =
        await _hiveStorageManager.getDamageAssetsByIds(event.standarIds);

    // Belirtilen damageCategoryId ve damagePartId'ye göre parçaları toplama
    List<Failures> filteredParts = [];
    for (var item in result) {
      if (item.categories != null && item.categories!.isNotEmpty) {
        for (var category in item.categories!) {
          if (category.id == event.damageCategoryId) {
            for (var part in category.parts!) {
              if (part.id == event.damagePartId) {
                for (var issue in part.issues!) {
                  if (issue.id == event.damageIssueId) {
                    filteredParts.addAll(issue.failures ?? []);
                  }
                }
              }
            }
          }
        }
      }
    }

    // Tekrarlayan parçaları birleştirme
    List<Failures> uniqueParts = [];
    Set<String> seenNames = {};

    for (var failure in filteredParts) {
      if (!seenNames.contains(failure.name)) {
        seenNames.add(failure.name ?? "");
        uniqueParts.add(failure);
      }
    }

    if (result.isNotEmpty) {
      emit(state.copyWith(
        getDamageFailuresResponse: uniqueParts,
        getDamageRepairsResponse: [],
        status: ViewStatus.success,
        damageCategoryId: event.damageCategoryId,
        damagePartId: event.damagePartId,
        damageIssueId: event.damageIssueId,
      ));
    }
  }

  Future<void> _getDamagesIssue(
      GetInspectionsDamagesIssue event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result =
        await _hiveStorageManager.getDamageAssetsByIds(event.standarIds);

    // Belirtilen damageCategoryId ve damagePartId'ye göre parçaları toplama
    List<Issues> filteredParts = [];
    for (var item in result) {
      if (item.categories != null && item.categories!.isNotEmpty) {
        for (var category in item.categories!) {
          if (category.id == event.damageCategoryId) {
            for (var part in category.parts!) {
              if (part.id == event.damagePartId) {
                filteredParts.addAll(part.issues ?? []);
              }
            }
          }
        }
      }
    }

    // Tekrarlayan parçaları birleştirme
    List<Issues> uniqueParts = [];
    Set<String> seenNames = {};

    for (var part in filteredParts) {
      if (!seenNames.contains(part.name)) {
        seenNames.add(part.name ?? "");
        uniqueParts.add(part);
      }
    }

    if (result.isNotEmpty) {
      emit(state.copyWith(
        getDamageIssuesResponse: uniqueParts,
        getDamageFailuresResponse: [],
        getDamageRepairsResponse: [],
        status: ViewStatus.success,
        damageCategoryId: event.damageCategoryId,
        damagePartId: event.damagePartId,
      ));
    }
  }

  Future<void> _getDamagesPart(
      GetInspectionsDamagesPart event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result =
        await _hiveStorageManager.getDamageAssetsByIds(event.standardIds);

    // Belirtilen damageCategoryId'ye göre parçaları toplama
    List<Parts> combinedParts = [];
    for (var item in result) {
      if (item.categories != null && item.categories!.isNotEmpty) {
        for (var category in item.categories!) {
          if (category.id == event.damageCategoryId) {
            combinedParts.addAll(category.parts!);
          }
        }
      }
    }

    // Tekrarlayan parçaları birleştirme
    List<Parts> uniqueParts = [];
    Set<String> seenNames = {};

    for (var part in combinedParts) {
      if (!seenNames.contains(part.name)) {
        seenNames.add(part.name ?? "");
        uniqueParts.add(part);
      }
    }

    if (result.isNotEmpty) {
      emit(state.copyWith(
        getDamagePartsResponse: uniqueParts,
        getDamageIssuesResponse: [],
        getDamageFailuresResponse: [],
        getDamageRepairsResponse: [],
        status: ViewStatus.success,
        damageCategoryId: event.damageCategoryId,
      ));
    }
  }

  Future<void> _getDamagesRepair(
      GetInspectionsDamagesRepair event, Emitter<InspectionsState> emit) async {
    // emit(state
    //     .copyWith(status: ViewStatus.loading, getDamageRepairsResponse: []));
    // final result = await _hiveStorageManager.getDamageRepairs(
    //   event.damageFailureId,
    // );

    // if (result != null) {
    //   emit(state.copyWith(
    //     getDamageRepairsResponse: result,
    //     status: ViewStatus.success,
    //   ));
    // }

    emit(state.copyWith(status: ViewStatus.loading));
    final result =
        await _hiveStorageManager.getDamageAssetsByIds(event.standarIds);

    // Belirtilen damageCategoryId ve damagePartId'ye göre parçaları toplama
    List<Repairs> filteredParts = [];
    for (var item in result) {
      if (item.categories != null && item.categories!.isNotEmpty) {
        for (var category in item.categories!) {
          if (category.id == event.damageCategoryId) {
            for (var part in category.parts!) {
              if (part.id == event.damagePartId) {
                for (var issue in part.issues!) {
                  if (issue.id == event.damageIssueId) {
                    for (var failure in issue.failures!) {
                      if (failure.id == event.damageFailureId) {
                        filteredParts.addAll(failure.repairs ?? []);
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    // Tekrarlayan parçaları birleştirme
    List<Repairs> uniqueParts = [];
    Set<String> seenNames = {};

    for (var repair in filteredParts) {
      if (!seenNames.contains(repair.name)) {
        seenNames.add(repair.name ?? "");
        uniqueParts.add(repair);
      }
    }

    if (result.isNotEmpty) {
      emit(state.copyWith(
        getDamageRepairsResponse: uniqueParts,
        status: ViewStatus.success,
        damageCategoryId: event.damageCategoryId,
        damagePartId: event.damagePartId,
        damageIssueId: event.damageIssueId,
      ));
    }
  }

  Future<void> _getDamageAssets(
      GetInspectionsDamageAssets event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result =
        await _hiveStorageManager.getDamageAssetsByIds(event.standardIds);

    // result içindeki tüm kategorileri tek bir listeye toplama
    List<Categories> combinedCategories = [];
    for (var item in result) {
      if (item.categories != null) {
        combinedCategories.addAll(item.categories!);
      }
    }

    // Tekrarlayan kategorileri birleştirme
    List<Categories> uniqueCategories = [];
    Set<String> seenNames = {};

    for (var category in combinedCategories) {
      if (!seenNames.contains(category.name)) {
        seenNames.add(category.name ?? "");
        uniqueCategories.add(category);
      }
    }

    if (result.isNotEmpty) {
      emit(state.copyWith(
        getDamageCategoriesResponse: uniqueCategories,
        status: ViewStatus.success,
      ));
    }
  }

  FutureOr<void> _cleanDamages(
      CleanDamages event, Emitter<InspectionsState> emit) {
    if (event.isCategory) {
      emit(state.copyWith(
          getDamageFailuresResponse: [],
          getDamageIssuesResponse: [],
          getDamagePartsResponse: [],
          getDamageRepairsResponse: []));
    } else if (event.isPart) {
      emit(state.copyWith(
          getDamageIssuesResponse: [],
          getDamageFailuresResponse: [],
          getDamageRepairsResponse: []));
    } else if (event.isIssue) {
      emit(state.copyWith(
          getDamageFailuresResponse: [], getDamageRepairsResponse: []));
    } else if (event.isFailure) {
      emit(state.copyWith(getDamageRepairsResponse: []));
    } else {
      emit(state.copyWith(
          getDamageFailuresResponse: [],
          getDamageIssuesResponse: [],
          getDamagePartsResponse: [],
          getDamageRepairsResponse: []));
    }
  }

  FutureOr<void> _setDriverImage(
      SetDriverImage event, Emitter<InspectionsState> emit) async {
    final Uint8List image = event.image;

    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/${Random().nextInt(10000)}.png');

    await file.writeAsBytes(image);

    emit(state.copyWith(imageDriverFile: file));
  }

  FutureOr<void> _setCustomerImage(
      SetCustomerImage event, Emitter<InspectionsState> emit) async {
    final Uint8List image = event.image;

    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/${Random().nextInt(10000)}.png');

    await file.writeAsBytes(image);

    emit(
      state.copyWith(
        imageCustamerFile: file,
        imageCustamerName: event.name,
        isSigned: false,
        // newInspection: true,
      ),
    );
  }

  FutureOr<void> _setGetDamages(
      SetGetDamages event, Emitter<InspectionsState> emit) async {
    final hiveDamages =
        await _hiveStorageManager.getGetDamage(event.inspectionId);
    // emit(
    //   state.copyWith(
    //     // status: ViewStatus.success,
    //     damageResponse: hiveDamages,
    //   ),
    // );

    emit(state.copyWith(status: ViewStatus.loading));

    final isNetwork = await hasNetwork();
    if (isNetwork && hiveDamages.isEmpty) {
      final result = await _ucGetJobInspectionsDamages.getDamages(
          jobInspectionId: event.inspectionId);

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: ViewStatus.failure,
              failure: failure,
            ),
          );
        },
        (data) async {
          emit(
            state.copyWith(
              status: ViewStatus.success,
              damageResponse: data,
            ),
          );

          for (var damage in data) {
            await _hiveStorageManager.setGetDamage(damage);
          }
        },
      );
    } else {
      emit(
        state.copyWith(
          status: ViewStatus.success,
          damageResponse: hiveDamages,
        ),
      );
    }
  }

  FutureOr<void> _setGetConditionImages(
      SetGetConditionImages event, Emitter<InspectionsState> emit) async {
    final result = await _hiveStorageManager.getInspectionConditionImages(
      event.inspectionId,
    );
    // print('result: $result');
    emit(state.copyWith(conditionImageResponse: result));
  }

  FutureOr<void> _setLatLong(
      SetLatLong event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(lat: event.lat, long: event.long));
  }

  FutureOr<void> _setAdress(
      SetAddress event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(address: event.address));
  }

  FutureOr<void> _clearState(
      ClearState event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(
      status: null,
      isSigned: false,
    ));
  }
}
