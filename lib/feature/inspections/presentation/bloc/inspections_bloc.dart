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
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_patch_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/damage/inspection_damage_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_customer_sign_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/job_inspections/sign/inspection_inspector_sign_post_model.dart';
import 'package:ferrisfwt/product/utility/enums/Item_check_list_enum.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:path_provider/path_provider.dart';

import '../../../home/data/models/damages/damage_combination/damage_combination_model.dart';
import '../../../home/data/models/damages/grade/grade_model.dart';
import '../../../home/data/models/job_start/job_start_model.dart';

part 'inspections_event.dart';
part 'inspections_state.dart';

class InspectionsBloc extends Bloc<InspectionsEvent, InspectionsState> {
  InspectionsBloc({
    required UCGetJobInspections ucGetJobInspections,
    required UCGetJobInspectionsSign ucGetJobInspectionsSign,
    required UCGetJobInspectionsDamages ucGetJobInspectionsDamages,
    required UCGetJobInspectionsCheckList ucGetJobInspectionsCheckList,
    required UCGetJobInspectionsConditionImages ucGetJobInspectionsConditionImages,
    required HiveDatabaseManager hiveDatabaseManager,
    required HiveStorageManager hiveStorageManager,
  })  : _ucGetJobInspections = ucGetJobInspections,
        _ucGetJobInspectionsSign = ucGetJobInspectionsSign,
        _ucGetJobInspectionsDamages = ucGetJobInspectionsDamages,
        _ucGetJobInspectionsCheckList = ucGetJobInspectionsCheckList,
        _ucGetJobInspectionsConditionImages = ucGetJobInspectionsConditionImages,
        _hiveStorageManager = hiveStorageManager,
        _hiveDatabaseManager = hiveDatabaseManager,
        super(const InspectionsState()) {
    on<GetJobInspections>(_onGetJobInspections);
    on<GetJobInspectionsCheckList>(_getJobInspectionsCheckList);
    on<PostJobInspectionsCheckList>(_postJobInspectionsCheckList);
    on<PostConditionImages>(_postConditionImages);
    on<PostConditionImagesRemote>(_postConditionImagesRemote);
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
    on<DeleteRecordedDamageRemote>(_onDeleteRecordedDamageRemote);
    on<UpdateDamageResponse>(_onUpdateDamageResponse);
    on<DeleteConditionImageRemote>(_onDeleteConditionImageRemote);
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

  Future<void> _onToggleButton(ToggleButtonsEvent event, Emitter<InspectionsState> emit) async {
    emit(
      state.copyWith(areButtonsVisible: !state.areButtonsVisible),
    );
  }

  Future<void> _onSetEditDetails(SetEditDetails event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(odo: event.odo, fuelLevel: event.fuelLevel, gradeId: ""));
  }

  Future<void> _clearInspection(ClearInspection event, Emitter<InspectionsState> emit) async {
    emit(const InspectionsState());
  }

  Future<void> _onConditionImages(ConditionsImagesEvent event, Emitter<InspectionsState> emit) async {
    state.conditionImages.add(event.conditionImage);
    List<File> updatedConditionImages = [];
    emit(state.copyWith(conditionImages: updatedConditionImages));
  }

  FutureOr<void> _onGetJobInspections(GetJobInspections event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(inspectionStatus: ViewStatus.loading, isSetInspection: false));
    final result = await hasNetwork();

    final inspections = await _hiveStorageManager.getInspectionsListModel();

    if (result) {
      final result = await _ucGetJobInspections.getJobInspections(
        jobId: event.jobId,
        regNumber: event.regnNumber,
      );

      result.fold(
        (failure) {
          emit(state.copyWith(failure: failure, inspectionStatus: ViewStatus.failure));
        },
        (data) {
          inspections.clear();
          if (inspections.isEmpty) {
            final List<int> inspectionsId = [];

            // Sort the data list by date and time
            data.sort((a, b) {
              DateTime dateTimeA = DateTime.parse("${a.date} ${a.time}");
              DateTime dateTimeB = DateTime.parse("${b.date} ${b.time}");
              return dateTimeA.compareTo(dateTimeB);
            });

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
      emit(state.copyWith(isSetInspection: true, inspectionStatus: ViewStatus.failure));
    }
  }

  Future<void> _getJobInspectionsCheckList(GetJobInspectionsCheckList event, Emitter<InspectionsState> emit) async {
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

  Future<void> _postJobInspectionsCheckList(PostJobInspectionsCheckList event, Emitter<InspectionsState> emit) async {
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

  Future<void> _postConditionImagesRemote(PostConditionImagesRemote event, Emitter<InspectionsState> emit) async {
    final result = await _ucGetJobInspectionsConditionImages.postConditionImage(
      data: event.conditionImage,
      jobInspectionId: event.jobInspectionId,
    );

    result.fold(
      (failure) {},
      (data) {
        final ConditionImageResponseModel currentData = event.conditionImage; // Mevcut veriyi alın
        final ConditionImageResponseModel updatedData = currentData.copyWith(id: data.id); // ID'yi güncelleyin

        _hiveStorageManager.updateInspectionConditionImage(
          event.conditionImage.id ?? 0,
          updatedData,
        );
      },
    );
  }

  Future<void> _postConditionImages(PostConditionImages event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));

    final result = await hasNetwork();
    if (result) {
      // if (event.isAsync != true) {

      //   emit(state.copyWith(
      //     status: ViewStatus.success,
      //     conditionImageResponse: [result, ...state.conditionImageResponse],
      //   ));
      // }
      for (var image in event.dataList) {
        final result = await _ucGetJobInspectionsConditionImages.postConditionImage(
          data: image,
          jobInspectionId: event.jobInspectionId,
        );

        result.fold(
          (failure) {
            emit(state.copyWith(status: ViewStatus.failure, failure: failure));
          },
          (data) async {
            _hiveStorageManager.addConditionImage(image);
            // _hiveStorageManager.setConditionImagePostModel(image);

            ConditionImageResponseModel? result;

            result = ConditionImageResponseModel(
              // id: state.conditionImageResponse.length + 1,
              id: data.id,
              jobInspectionId: data.jobInspectionId,
              imagePath: data.imagePath,
              imageFile: image.imageFile,
            );
            _hiveStorageManager.replaceInspectionConditionImagesTable(result);

            emit(
              state.copyWith(
                status: ViewStatus.success,
                isSigned: true,
                conditionImageResponse: [result, ...state.conditionImageResponse],
              ),
            );
          },
        );
      }
    } else {
      if (event.isAsync) {
        emit(state.copyWith(status: ViewStatus.failure));
        return;
      }

      for (var image in event.dataList) {
        _hiveStorageManager.setConditionImagePostModel(image);

        // final ConditionImageResponseModel result = ConditionImageResponseModel(
        //   id: image.id,
        //   jobInspectionId: event.jobInspectionId ?? 0,
        //   imagePath: image.imageFile!.path,
        // );

        await Future.delayed(const Duration(seconds: 2));
        _hiveStorageManager.replaceInspectionConditionImagesTable(image);
        _hiveStorageManager.addConditionImage(
          image,
        );
        emit(state.copyWith(
          status: ViewStatus.success,
          conditionImageResponse: [image, ...state.conditionImageResponse],
        ));
      }
    }
  }

  Future<void> _onDeleteConditionImageRemote(DeleteConditionImageRemote event, Emitter<InspectionsState> emit) async {
    await _ucGetJobInspectionsConditionImages.deleteConditionImage(
      imageId: event.conditionId,
    );
  }

  Future<void> _deleteConditionImage(DeleteConditionImage event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));

    List<ConditionImageResponseModel?> resultInspectionConditionImages =
        await _hiveStorageManager.getConditionImagePostModel(event.jobInspectionId);

    final result = await hasNetwork();

    if (result) {
      await _ucGetJobInspectionsConditionImages.deleteConditionImage(
        imageId: event.imageId,
      );
    } else {
      if (resultInspectionConditionImages.isNotEmpty) {
        await _hiveStorageManager.deleteConditionImagePostModel(event.imageId);
      } else {
        await _hiveStorageManager.storeDeletedId(event.model);
      }
    }

    _hiveStorageManager.deleteInspectionConditionImage(
        jobInspectionId: event.jobInspectionId, conditionId: event.imageId);

    _hiveStorageManager.deleteConditionImage(event.jobInspectionId, event.index);

    await Future.delayed(const Duration(seconds: 2));
    final List<ConditionImageResponseModel> conditionImageResponse = state.conditionImageResponse;

    conditionImageResponse.removeWhere((element) => element.id == event.imageId);
    emit(state.copyWith(
      status: ViewStatus.success,
      conditionImageResponse: conditionImageResponse,
    ));

    BotToast.showText(text: 'Image deleted successfully');
  }

  Future<void> _onDeleteRecordedDamageRemote(DeleteRecordedDamageRemote event, Emitter<InspectionsState> emit) async {
    await _ucGetJobInspectionsDamages.deleteRecordedDamage(
      damageId: event.damageId,
    );
  }

  Future<void> _onDeleteRecordedDamage(DeleteRecordedDamage event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));

    List<DamageCombinationModel?> damageCombinations = await _hiveStorageManager.getDamageCombination();
    List<GradeModel?> grades = await _hiveStorageManager.getGrades();

    int? damageCombinationScore = 0;

    damageCombinationScore = damageCombinations
            .firstWhere(
              (damageCombination) => damageCombination != null && event.repairId == damageCombination.repairId!.id,
              orElse: () => null,
            )
            ?.score ??
        0;

    int? existingScore = await _hiveStorageManager.getScore(inspectionId: event.jobInspectionId);
    int updatedScore = (existingScore ?? 0) - damageCombinationScore;
    await _hiveStorageManager.deleteScore(scoreToRemove: damageCombinationScore, inspectionId: event.jobInspectionId);

    String? newGradeName;
    int? newGradeOrder;
    int? newGradeId;
    if (grades.isNotEmpty) {
      for (var grade in grades) {
        if (grade != null) {
          /// rangeFrom and rangeTo try to parse double
          double? rangeFrom = double.tryParse(grade.rangeFrom ?? "0");
          double? rangeTo = double.tryParse(grade.rangeTo ?? "0");

          /// if the rangeFrom and rangeTo is not null and the damageCombinationScore is greater than or equal to the rangeFrom and less than or equal to the rangeTo
          if (rangeFrom != null && rangeTo != null && updatedScore >= rangeFrom && updatedScore <= rangeTo) {
            newGradeName = grade.name; // grade name'ini al
            newGradeOrder = grade.order;
            newGradeId = grade.id;
            break;
          }
        }
      }
    }

    print("newGradeName: $newGradeName, updatedScore: $updatedScore");

    List<DamageResponseModel> newDamages = await _hiveStorageManager.getGetDamageNew(event.jobInspectionId);

    _hiveStorageManager.deleteDamagePostModel(event.jobInspectionId);
    _hiveStorageManager.deleteGetDamage(event.jobInspectionId, event.damageId);
    _hiveStorageManager.storeDeletedDamageId(event.model);

    final List<DamageResponseModel> damageResponse = state.damageResponse;
    await Future.delayed(const Duration(seconds: 1));
    damageResponse.removeWhere((element) {
      return element.id == event.stateDamageId;
    });

    print("event combinationId: ${event.combinationId}");
    await findGrade(event.jobInspectionId, event.combinationId);

    List<String> gradeOrder = ['G1', 'G2', 'G3', 'G4', 'G5', 'GU'];

    JobInspectionResponseModelItem? jobInspection = await _hiveStorageManager.getInspectionById(event.jobInspectionId);

    String? currentGradeName = jobInspection != null ? jobInspection.gradleItem?.name : "0";
    print("old currentGradeName: $currentGradeName");

    if (newGradeName != null && currentGradeName != null) {
      int currentGradeIndex = gradeOrder.indexOf(currentGradeName);
      int newGradeIndex = gradeOrder.indexOf(newGradeName);

      if (newGradeIndex >= currentGradeIndex) {
        currentGradeName = newGradeName;
        await _hiveStorageManager.updateInspectionsListModelGrade(
          JobInspectionResponseModelItem(
            id: event.jobInspectionId,
            gradleItem: GradeId(
              name: newGradeName,
              order: newGradeOrder,
              id: newGradeId,
            ),
          ),
        );
      }
    }

    List<JobInspectionResponseModelItem?> inspecList = await _hiveStorageManager.getInspectionsListModel();

    print("new currentGradeName: $currentGradeName");

    emit(state.copyWith(
      status: ViewStatus.success,
      damageResponse: damageResponse,
      inspections: inspecList,
      // gradeId: jobInspection!.gradleItem != null
      //     ? jobInspection.gradleItem!.name != "0"
      //         ? jobInspection.gradleItem!.name
      //         : "-"
      //     : "-",
      gradeId: currentGradeName ?? "-",
    ));

    BotToast.showText(text: 'Damage deleted successfully');

    // if (newDamages.isNotEmpty) {
    //   for (var newDamage in newDamages) {
    //     if (newDamage.id == event.damageId) {
    //       var result = await _ucGetJobInspectionsDamages.deleteRecordedDamage(
    //         damageId: newDamage.id,
    //       );
    //       await result.fold(
    //         (failure) {
    //           emit(state.copyWith(
    //             status: ViewStatus.failure,
    //           ));
    //         },
    //         (data) async {
    //           await _hiveStorageManager.deleteGetDamageNew(event.jobInspectionId, newDamage.id);

    //           await _hiveStorageManager.deleteDamagePostModel(event.jobInspectionId);
    //           await _hiveStorageManager.deleteGetDamage(event.jobInspectionId, newDamage.id);

    //           final List<DamageResponseModel> damageResponse = state.damageResponse;
    //           damageResponse.removeWhere((element) {
    //             return element.id == event.stateDamageId;
    //           });

    //           await findGrade(event.jobInspectionId, event.combinationId);

    //           JobInspectionResponseModelItem? jobInspection =
    //               await _hiveStorageManager.getInspectionById(event.jobInspectionId);

    //           List<String> gradeOrder = ['G1', 'G2', 'G3', 'G4', 'G5', 'GU'];

    //           String? currentGradeName = jobInspection != null ? jobInspection.gradleItem?.name : "0";

    //           print("1- currentGradeName : $currentGradeName");

    //           if (newGradeName != null && currentGradeName != null) {
    //             int currentGradeIndex = gradeOrder.indexOf(currentGradeName);
    //             int newGradeIndex = gradeOrder.indexOf(newGradeName);

    //             if (newGradeIndex >= currentGradeIndex) {
    //               currentGradeName = newGradeName;
    //               await _hiveStorageManager.updateInspectionsListModelGrade(
    //                 JobInspectionResponseModelItem(
    //                   id: event.jobInspectionId,
    //                   gradleItem: GradeId(
    //                     name: newGradeName,
    //                     order: newGradeOrder,
    //                     id: newGradeId,
    //                   ),
    //                 ),
    //               );
    //             }
    //           }

    //           List<JobInspectionResponseModelItem?> inspecList = await _hiveStorageManager.getInspectionsListModel();

    //           print("1- currentGradeName: $currentGradeName");

    //           emit(state.copyWith(
    //             status: ViewStatus.success,
    //             damageResponse: damageResponse,
    //             // gradeId: jobInspection!.gradleItem != null
    //             //     ? jobInspection.gradleItem!.name != "0"
    //             //         ? jobInspection.gradleItem!.name
    //             //         : "-"
    //             //     : "-"
    //             gradeId: currentGradeName ?? "-",
    //             inspections: inspecList,
    //           ));
    //           BotToast.showText(text: 'Damage deleted successfully');
    //         },
    //       );
    //     } else {
    //       _hiveStorageManager.deleteDamagePostModel(event.jobInspectionId);
    //       _hiveStorageManager.deleteGetDamage(event.jobInspectionId, event.damageId);
    //       final List<DamageResponseModel> damageResponse = state.damageResponse;
    //       await Future.delayed(const Duration(seconds: 1));
    //       damageResponse.removeWhere((element) {
    //         return element.id == event.stateDamageId;
    //       });

    //       await findGrade(event.jobInspectionId, event.combinationId);

    //       JobInspectionResponseModelItem? jobInspection =
    //           await _hiveStorageManager.getInspectionById(event.jobInspectionId);

    //       List<String> gradeOrder = ['G1', 'G2', 'G3', 'G4', 'G5', 'GU'];

    //       String? currentGradeName = jobInspection != null ? jobInspection.gradleItem?.name : "0";
    //       print("2- currentGradeName: $currentGradeName");

    //       if (newGradeName != null && currentGradeName != null) {
    //         int currentGradeIndex = gradeOrder.indexOf(currentGradeName);
    //         int newGradeIndex = gradeOrder.indexOf(newGradeName);

    //         if (newGradeIndex >= currentGradeIndex) {
    //           currentGradeName = newGradeName;
    //           await _hiveStorageManager.updateInspectionsListModelGrade(
    //             JobInspectionResponseModelItem(
    //               id: event.jobInspectionId,
    //               gradleItem: GradeId(
    //                 name: newGradeName,
    //                 order: newGradeOrder,
    //                 id: newGradeId,
    //               ),
    //             ),
    //           );
    //         }
    //       }

    //       List<JobInspectionResponseModelItem?> inspecList = await _hiveStorageManager.getInspectionsListModel();

    //       print("2- currentGradeName: $currentGradeName");

    //       emit(state.copyWith(
    //         status: ViewStatus.success,
    //         damageResponse: damageResponse,
    //         inspections: inspecList,
    //         // gradeId: jobInspection!.gradleItem != null
    //         //     ? jobInspection.gradleItem!.name != "0"
    //         //         ? jobInspection.gradleItem!.name
    //         //         : "-"
    //         //     : "-",
    //         gradeId: currentGradeName ?? "-",
    //       ));

    //       // BotToast.showText(text: 'Damage deleted successfully');
    //     }
    //   }
    // } else {
    //   _hiveStorageManager.deleteDamagePostModel(event.jobInspectionId);
    //   _hiveStorageManager.deleteGetDamage(event.jobInspectionId, event.damageId);

    //   final List<DamageResponseModel> damageResponse = state.damageResponse;
    //   await Future.delayed(const Duration(seconds: 1));
    //   damageResponse.removeWhere((element) {
    //     return element.id == event.stateDamageId;
    //   });

    //   await findGrade(event.jobInspectionId, event.combinationId);

    //   JobInspectionResponseModelItem? jobInspection =
    //       await _hiveStorageManager.getInspectionById(event.jobInspectionId);

    //   List<String> gradeOrder = ['G1', 'G2', 'G3', 'G4', 'G5', 'GU'];

    //   String? currentGradeName = jobInspection != null ? jobInspection.gradleItem?.name : "0";
    //   print("3- currentGradeName: $currentGradeName");

    //   if (newGradeName != null && currentGradeName != null) {
    //     int currentGradeIndex = gradeOrder.indexOf(currentGradeName);
    //     int newGradeIndex = gradeOrder.indexOf(newGradeName);

    //     if (newGradeIndex >= currentGradeIndex) {
    //       currentGradeName = newGradeName;
    //       await _hiveStorageManager.updateInspectionsListModelGrade(
    //         JobInspectionResponseModelItem(
    //           id: event.jobInspectionId,
    //           gradleItem: GradeId(
    //             name: newGradeName,
    //             order: newGradeOrder,
    //             id: newGradeId,
    //           ),
    //         ),
    //       );
    //     }
    //   }

    //   List<JobInspectionResponseModelItem?> inspecList = await _hiveStorageManager.getInspectionsListModel();

    //   print("3- currentGradeName: $currentGradeName");

    //   emit(state.copyWith(
    //     status: ViewStatus.success,
    //     damageResponse: damageResponse,
    //     inspections: inspecList,
    //     // gradeId: jobInspection!.gradleItem != null
    //     //     ? jobInspection.gradleItem!.name != "0"
    //     //         ? jobInspection.gradleItem!.name
    //     //         : "-"
    //     //     : "-",
    //     gradeId: currentGradeName ?? "-",
    //   ));

    //   BotToast.showText(text: 'Damage deleted successfully');
    // }
  }

  void _onUpdateDamageResponse(UpdateDamageResponse event, Emitter<InspectionsState> emit) {
    emit(state.copyWith(damageResponse: event.damages));
  }

  Future<void> _postJobInspectionsDamagesControl(
      PostJobInspectionsDamagesControl event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(isError: true));
  }

  Future<void> _postJobInspectionsDamagesRemote(
      PostJobInspectionsDamagesRemote event, Emitter<InspectionsState> emit) async {
    print("post damage remote is working");
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
        print("event data damageId : ${event.data.damageId}");
        print("data id : ${data.id}");
        _hiveStorageManager.setGetDamageNew(data);
        _hiveStorageManager.updateDamageId(event.data.damageId!, data.id);
        _hiveStorageManager.setDamageBoolValue(true);

        emit(
          state.copyWith(
            gradeId: data.gradeId ?? state.gradeId,
          ),
        );
      },
    );
  }

  Future<void> _postJobInspectionsDamages(PostJobInspectionsDamages event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));

    String? _price = "0.0";

    final currentInspectionId = event.jobInspectionId ?? 0;

    List<JobStartModel?> jobs = await _hiveStorageManager.getJobs();

    List<DamageCombinationModel?> damageCombinations = await _hiveStorageManager.getDamageCombination();
    List<GradeModel?> grades = await _hiveStorageManager.getGrades();

    int? damageCombinationScore = 0;
    int? damageCombinationId = 0;

    damageCombinationId = damageCombinations
            .firstWhere(
              (damageCombination) => damageCombination != null && event.data.repairId == damageCombination.repairId!.id,
              orElse: () => null,
            )
            ?.id ??
        0;

    damageCombinationScore = damageCombinations
            .firstWhere(
              (damageCombination) => damageCombination != null && event.data.repairId == damageCombination.repairId!.id,
              orElse: () => null,
            )
            ?.score ??
        0;

    int? existingScore = await _hiveStorageManager.getScore(inspectionId: currentInspectionId);
    int updatedScore = (existingScore ?? 0) + damageCombinationScore;
    await _hiveStorageManager.addScore(score: damageCombinationScore, inspectionId: currentInspectionId);

    String? newGradeName;
    int? newGradeOrder;
    int? newGradeId;
    if (grades.isNotEmpty) {
      for (var grade in grades) {
        if (grade != null) {
          /// rangeFrom and rangeTo try to parse double
          double? rangeFrom = double.tryParse(grade.rangeFrom ?? "0");
          double? rangeTo = double.tryParse(grade.rangeTo ?? "0");

          /// if the rangeFrom and rangeTo is not null and the damageCombinationScore is greater than or equal to the rangeFrom and less than or equal to the rangeTo
          if (rangeFrom != null && rangeTo != null && updatedScore >= rangeFrom && updatedScore <= rangeTo) {
            newGradeName = grade.name; // grade name'ini al
            newGradeOrder = grade.order;
            newGradeId = grade.id;
            break;
          }
        }
      }
    }

    print("newGradeName: $newGradeName, updatedScore: $updatedScore");

    /// if the damageCombinationId is 0 then we will get the null value from the damageCombinations list
    final matchingJob = jobs.firstWhere((job) {
      return job?.combinationId == damageCombinationId;
    }, orElse: () => null);

    _price = matchingJob?.price;

    if (event.isAsync) {
      emit(state.copyWith(status: ViewStatus.failure));
      return;
    }
    await _hiveStorageManager.setDamagePostModel(event.data);
    await Future.delayed(const Duration(seconds: 2));
    final categoryName =
        state.getDamageCategoriesResponse.firstWhere((element) => element?.id == event.data.categoryId);

    final partName = state.getDamagePartsResponse.firstWhere((element) => element.id == event.data.partId);

    final issueName = state.getDamageIssuesResponse.firstWhere((element) => element.id == event.data.issueId);

    final failureName = state.getDamageFailuresResponse.firstWhere((element) => element.id == event.data.failureId);

    final repairName = state.getDamageRepairsResponse.firstWhere((element) => element.id == event.data.repairId);

    print("damageCombinationId : $damageCombinationId");

    final DamageResponseModel data = DamageResponseModel(
      id: event.data.damageId ?? 0,
      combinationId: damageCombinationId,
      jobInspectionId: event.data.jobInspectionId,
      categoryId: DamagesCategory(id: event.data.categoryId, name: categoryName?.name ?? ''),
      partId: DamagesPart(id: event.data.partId, name: partName.name ?? '', categoryId: event.data.categoryId),
      issueId: DamagesIssue(id: event.data.issueId, name: issueName.name ?? "", partId: event.data.partId),
      failureId: DamagesFailure(id: event.data.failureId, name: failureName.name ?? "", issueId: event.data.issueId),
      repairId: DamagesRepair(id: event.data.repairId, name: repairName.name ?? "", failureId: event.data.failureId),
      damageImage: event.data.damageImage?.path ?? '',
      contextImage: event.data.contextImage?.path ?? '',
      // gradeId: gradeId != null ? gradeId.toString() : state.gradeId,
      price: double.parse(_price ?? "0.0"),
    );

    print("data combinationId : ${data.combinationId}");

    _hiveStorageManager.setGetDamage(data);

    _hiveStorageManager.setRecordedDamage(event.data);
    final gradeId = await findGrade(currentInspectionId, damageCombinationId);

    state.getDamageCategoriesResponse.clear();
    state.getDamagePartsResponse.clear();
    state.getDamageIssuesResponse.clear();
    state.getDamageFailuresResponse.clear();
    state.getDamageRepairsResponse.clear();

    JobInspectionResponseModelItem? jobInspection =
        await _hiveStorageManager.getInspectionById(event.data.jobInspectionId);

    List<String> gradeOrder = ['G1', 'G2', 'G3', 'G4', 'G5', 'GU'];

    String? currentGradeName = jobInspection != null ? jobInspection.gradleItem?.name : "0";

    if (newGradeName != null && currentGradeName != null) {
      int currentGradeIndex = gradeOrder.indexOf(currentGradeName);
      int newGradeIndex = gradeOrder.indexOf(newGradeName);

      if (newGradeIndex >= currentGradeIndex) {
        currentGradeName = newGradeName;
        await _hiveStorageManager.updateInspectionsListModelGrade(
          JobInspectionResponseModelItem(
            id: currentInspectionId,
            gradleItem: GradeId(
              name: newGradeName,
              order: newGradeOrder,
              id: newGradeId,
            ),
          ),
        );
      }
    }

    List<JobInspectionResponseModelItem?> inspecList = await _hiveStorageManager.getInspectionsListModel();

    emit(
      state.copyWith(
        status: ViewStatus.success,
        damageResponse: [data, ...state.damageResponse],
        isError: false,
        inspections: inspecList,
        // gradeId: gradeId != null
        //     ? "G$gradeId"
        //     : jobInspection != null
        //         ? jobInspection.gradleItem != null
        //             ? jobInspection.gradleItem!.name
        //             : "-"
        //         : "-",
        gradeId: gradeId != null ? "G$gradeId" : currentGradeName ?? "-",
      ),
    );
  }

  Future<int?> findGrade(int jobInspectionId, int combinationId) async {
    /// We will make the null grade for [JobInspectionResponseModelItem] with the given [jobInspectionId]
    await _hiveStorageManager.updateInspectionsListModelGrade(
      JobInspectionResponseModelItem(
        id: jobInspectionId,
        gradleItem: GradeId(
          id: null,
          name: null,
          order: null,
        ),
      ),
    );

    final inspections = await _hiveStorageManager.getInspectionsListModel();
    final grades = await _hiveStorageManager.getGrades();
    final gradeRules = await _hiveStorageManager.getGradeRules();

    final gradeRuleUplifts = await _hiveStorageManager.getGradeRuleUplifts();
    final damageCombinations = await _hiveStorageManager.getDamageCombination();
    final damages = await _hiveStorageManager.getGetDamage(jobInspectionId);

    /// If the damage is not found then we will return null
    final hasDamage = damages.any((inspection) => inspection.jobInspectionId == jobInspectionId);
    if (!hasDamage) {
      return null;
    }

    print("damages : ${damages.length}");

    int inspectionsDamageCountByCombinationV2 = damages.where((damage) {
      print("damage id : ${damage.id}");
      print("damage combination id ${damage.combinationId} : combinationId $combinationId");
      return damage.jobInspectionId == jobInspectionId;
    }).length;

    /// If the damage is found then we will get the [JobInspectionResponseModelItem] with the given [jobInspectionId]
    final jobInspection = inspections.firstWhere((inspection) => inspection?.id == jobInspectionId);

    /// We will get the [Grade] with the given [subClientId] and sort them by the [order]
    final relatedGrades = grades.where((grade) => grade?.subClientId!.id == jobInspection?.jobId?.clientId!.id).toList()
      ..sort((a, b) => a!.order!.compareTo(b!.order!));

    /// We will get the [GradeRule] with the given [gradeId]
    for (final grade in relatedGrades) {
      final gradeRulesForCurrentGrade = gradeRules.where((rule) => rule!.gradeId == grade!.id).toList();

      for (final rule in gradeRulesForCurrentGrade) {
        final requiredDamageCombinationId = rule?.requiredDamageCombinationId;
        final requiredDamageCombinationCount = rule?.requiredDamageCombinationCount ?? 0;

        /// We will get the [Damage] with the given [jobInspectionId] and [requiredDamageCombinationId]
        int inspectionsDamageCountByCombination = damages.where((damage) {
          return damage.jobInspectionId == jobInspectionId && damage.combinationId == requiredDamageCombinationId;
        }).length;

        /// If the [inspectionsDamageCountByCombination] is greater than or equal to the [requiredDamageCombinationCount]
        if (inspectionsDamageCountByCombination >= requiredDamageCombinationCount) {
          /// We will get the [currentJobInspection] with the given [jobInspectionId]
          final currentJobInspection = inspections.firstWhere((inspection) => inspection!.id == jobInspectionId);

          // final currentJobInspectionOrder =
          //     currentJobInspection!.gradleItem != null
          //         ? grades
          //                 .firstWhere(
          //                   (g) =>
          //                       g?.id == currentJobInspection.gradleItem!.id!,
          //                   orElse: () =>
          //                       null, // Eğer eşleşen bir eleman bulunamazsa null döner
          //                 )
          //                 ?.order ??
          //             0
          //         : 0;

          /// if the [grade] is not null and the [order] of the [grade] is greater than the [order] of the [currentJobInspection]
          if (grade!.order != null &&
              currentJobInspection!.gradleItem != null &&
              grade.order! > currentJobInspection.gradleItem!.order!) {
            // await _hiveStorageManager.updateJobInspectionGrade(
            //     jobInspectionId, grade.id);

            await _hiveStorageManager.updateInspectionsListModelGrade(
              JobInspectionResponseModelItem(
                id: jobInspectionId,
                gradleItem: GradeId(
                  name: grade.name,
                  order: grade.order,
                  id: grade.id,
                ),
              ),
            );

            print("NEW GRADE ID : ${grade.id}");
            // return grade.id!;
          }

          /// if gradeRuleUpLifts is not empty then we will get the [upliftsForCurrentRule] with the given [gradeRuleId]
          final upliftsForCurrentRule = gradeRuleUplifts.where((uplift) => rule!.id == uplift?.gradeRuleId).toList();

          if (upliftsForCurrentRule.isNotEmpty) {
            for (final uplift in upliftsForCurrentRule) {
              final upliftRequiredDamageCombinationCount = uplift?.requiredDamageCombinationCount ?? 0;
              final upliftToGradeId = uplift?.upToGradeId;

              /// if damage count by combination is greater than or equal to the [upliftRequiredDamageCombinationCount]
              if (inspectionsDamageCountByCombination >= upliftRequiredDamageCombinationCount) {
                final upliftGrade = grades.firstWhere((g) => g?.id == upliftToGradeId);
                final upliftGradeOrder = upliftGrade?.order ?? 0;

                if (upliftGradeOrder > currentJobInspection!.gradleItem!.order!) {
                  print("NEW GRADE UPLIFT ID : ${upliftGrade!.id}");
                  // await _hiveStorageManager.updateJobInspectionGrade(
                  //     jobInspectionId, upliftToGradeId);

                  await _hiveStorageManager.updateInspectionsListModelGrade(
                    JobInspectionResponseModelItem(
                      id: jobInspectionId,
                      gradleItem: GradeId(
                        name: upliftGrade.name,
                        order: upliftGrade.order,
                        id: upliftGrade.id,
                      ),
                    ),
                  );
                }
              }
            }
          }
        }
      }
    }
    return null;
  }

  Future<void> _patchJobInspectionsDamages(PatchJobInspectionsDamages event, Emitter<InspectionsState> emit) async {
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

          damageResponse.removeWhere((element) => element.id == event.data.damageId);

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

      damageResponse.removeWhere((element) => element.id == event.data.damageId);

      final DamageResponseModel data = DamageResponseModel(
          id: Random().nextInt(10000),
          jobInspectionId: event.jobInspectionId ?? 0,
          categoryId: DamagesCategory(id: event.data.categoryId ?? 0, name: 'category'),
          partId: DamagesPart(id: event.data.partId ?? 0, name: 'part', categoryId: event.data.categoryId ?? 0),
          issueId: DamagesIssue(id: event.data.issueId ?? 0, name: 'issue', partId: event.data.partId ?? 0),
          failureId: DamagesFailure(id: event.data.failureId ?? 0, name: 'failure', issueId: event.data.issueId ?? 0),
          repairId: DamagesRepair(id: event.data.repairId ?? 0, name: 'repair', failureId: event.data.failureId ?? 0),
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
      PostJobInspectionsCustomerSign event, Emitter<InspectionsState> emit) async {
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
      _hiveStorageManager.setSignCustomerPostModel(event.data, event.jobInspectionId);
      // await Future.delayed(const Duration(seconds: 2));
      // emit(state.copyWith(
      //   status: ViewStatus.success,
      // ));
    }
  }

  Future<void> _postInspectionSign(PostInspectionSign event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading, isSigned: false));
    final result = await hasNetwork();
    if (result) {
      // final resultInspectionPatch = await ProductStateItems.hiveStorageManager
      //     .getConditionImagePostModel(event.jobInspectionId);

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
          emit(state.copyWith(status: ViewStatus.failure, failure: failure, isSigned: false));
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
      _hiveStorageManager.setSignInspectorPostModel(event.data, event.jobInspectionId);
      await Future.delayed(const Duration(seconds: 2));
      _hiveDatabaseManager.saveInspectionsSign(event.jobInspectionId);
      emit(state.copyWith(
        status: ViewStatus.success,
        isSigned: true,
      ));
      BotToast.showText(text: 'Signed successfully');
    }
  }

  Future<void> _onInspectionsItemDetail(InspectionsItemDetail event, Emitter<InspectionsState> emit) async {
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
          final List<JobInspectionResponseModelItem?> updatedInspection = state.inspections
              .map((e) => e?.id == event.inspectionId
                  ? e?.copyWith(
                      odoReading: event.odoReading,
                      fuelLevel: event.fuelLevel,
                    )
                  : e)
              .toList();

          _hiveStorageManager.updateInspectionsListModel(updatedInspection);

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

      final List<JobInspectionResponseModelItem?> updatedInspection = state.inspections
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

  Future<void> _onSetInspections(SetInspections event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final inspections = await _hiveStorageManager.getInspectionsListModel();
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(
      inspections: inspections,
      status: ViewStatus.success,
    ));
  }

  void _setItemCheckList(SetItemCheckList event, Emitter<InspectionsState> emit) async {
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

  Future<void> _getDamagesFailure(GetInspectionsDamagesFailure event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _hiveStorageManager.getDamageAssetsByIds(event.standarIds);

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

  Future<void> _getDamagesIssue(GetInspectionsDamagesIssue event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _hiveStorageManager.getDamageAssetsByIds(event.standarIds);

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

  Future<void> _getDamagesPart(GetInspectionsDamagesPart event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _hiveStorageManager.getDamageAssetsByIds(event.standardIds);

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

  Future<void> _getDamagesRepair(GetInspectionsDamagesRepair event, Emitter<InspectionsState> emit) async {
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
    final result = await _hiveStorageManager.getDamageAssetsByIds(event.standarIds);

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

  Future<void> _getDamageAssets(GetInspectionsDamageAssets event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _hiveStorageManager.getDamageAssetsByIds(event.standardIds);

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

  FutureOr<void> _cleanDamages(CleanDamages event, Emitter<InspectionsState> emit) {
    if (event.isCategory) {
      emit(state.copyWith(
          getDamageFailuresResponse: [],
          getDamageIssuesResponse: [],
          getDamagePartsResponse: [],
          getDamageRepairsResponse: []));
    } else if (event.isPart) {
      emit(state.copyWith(getDamageIssuesResponse: [], getDamageFailuresResponse: [], getDamageRepairsResponse: []));
    } else if (event.isIssue) {
      emit(state.copyWith(getDamageFailuresResponse: [], getDamageRepairsResponse: []));
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

  FutureOr<void> _setDriverImage(SetDriverImage event, Emitter<InspectionsState> emit) async {
    final Uint8List image = event.image;

    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/${Random().nextInt(10000)}.png');

    await file.writeAsBytes(image);

    emit(state.copyWith(imageDriverFile: file));
  }

  FutureOr<void> _setCustomerImage(SetCustomerImage event, Emitter<InspectionsState> emit) async {
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

  FutureOr<void> _setGetDamages(SetGetDamages event, Emitter<InspectionsState> emit) async {
    final hiveDamages = await _hiveStorageManager.getGetDamage(event.inspectionId);
    // emit(
    //   state.copyWith(
    //     // status: ViewStatus.success,
    //     damageResponse: hiveDamages,
    //   ),
    // );

    emit(state.copyWith(status: ViewStatus.loading));

    final isNetwork = await hasNetwork();
    if (isNetwork && hiveDamages.isEmpty) {
      final result = await _ucGetJobInspectionsDamages.getDamages(jobInspectionId: event.inspectionId);

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
            await _hiveStorageManager.setGetDamageNew(damage);
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

  FutureOr<void> _setGetConditionImages(SetGetConditionImages event, Emitter<InspectionsState> emit) async {
    final result = await _hiveStorageManager.getInspectionConditionImages(
      event.inspectionId,
    );
    emit(state.copyWith(conditionImageResponse: result));
  }

  FutureOr<void> _setLatLong(SetLatLong event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(lat: event.lat, long: event.long));
  }

  FutureOr<void> _setAdress(SetAddress event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(address: event.address));
  }

  FutureOr<void> _clearState(ClearState event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(
      status: null,
      isSigned: false,
    ));
  }
}
