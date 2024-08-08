import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_categories/damage_category.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_failures/damage_failure.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_issues/damage_issue.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_parts/damage_part.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_repairs/damage_repair.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_response_model.dart';
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
    on<PatchJobInspectionsDamages>(_patchJobInspectionsDamages);
    on<PostJobInspectionsCustomerSign>(_postJobInspectionsCustomerSign);
    on<PostInspectionSign>(_postInspectionSign);
    on<InspectionsItemDetail>(_onInspectionsItemDetail);
    on<SetInspections>(_onSetInspections);
    on<SetItemCheckList>(_setItemCheckList);
    on<GetInspectionsDamagesCategory>(_getDamagesCategory);
    on<GetInspectionsDamagesFailure>(_getDamagesFailure);
    on<GetInspectionsDamagesIssue>(_getDamagesIssue);
    on<GetInspectionsDamagesPart>(_getDamagesPart);
    on<GetInspectionsDamagesRepair>(_getDamagesRepair);
    on<GetInspectionsDamageCategories>(_getDamageCategories);
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
  }

  final UCGetJobInspections _ucGetJobInspections;
  final UCGetJobInspectionsSign _ucGetJobInspectionsSign;
  final UCGetJobInspectionsDamages _ucGetJobInspectionsDamages;
  final UCGetJobInspectionsCheckList _ucGetJobInspectionsCheckList;
  final UCGetJobInspectionsConditionImages _ucGetJobInspectionsConditionImages;
  late final HiveStorageManager _hiveStorageManager;
  late final HiveDatabaseManager _hiveDatabaseManager;

  Future<void> _onSetEditDetails(
      SetEditDetails event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(odo: event.odo, fuelLevel: event.fuelLevel));
  }

  Future<void> _clearInspection(
      ClearInspection event, Emitter<InspectionsState> emit) async {
    emit(const InspectionsState());
  }

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
        print("dataaaaaaaaaaa: $data");
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
      if (event.isAsync != true) {
        _hiveStorageManager.setConditionImagePostModel(event.data);

        final ConditionImageResponseModel result = ConditionImageResponseModel(
          id: state.conditionImageResponse.length + 1,
          jobInspectionId: event.jobInspectionId ?? 0,
          imagePath: event.data.image.path,
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
        return;
      }
      final result =
          await _ucGetJobInspectionsConditionImages.postConditionImage(
        data: event.data,
        jobInspectionId: event.jobInspectionId,
      );
      result.fold(
        (failure) {
          emit(state.copyWith(status: ViewStatus.failure, failure: failure));
        },
        (data) {
          emit(state.copyWith(status: ViewStatus.success, isSigned: true));
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
        imagePath: event.data.image.path,
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

    _hiveStorageManager.deleteDamagePostModel(event.jobInspectionId);
    _hiveStorageManager.deleteGetDamage(event.jobInspectionId, event.damageId);
    final List<DamageResponseModel> damageResponse = state.damageResponse;
    await Future.delayed(const Duration(seconds: 1));
    damageResponse.removeWhere((element) => element.id == event.damageId);
    print('damageResponse: $damageResponse');
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

  Future<void> _postJobInspectionsDamages(
      PostJobInspectionsDamages event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await hasNetwork();
    if (result) {
      final result = await _ucGetJobInspectionsDamages.postDamage(
        data: event.data,
      );

      result.fold(
        (failure) {
          emit(state.copyWith(status: ViewStatus.failure, failure: failure));
        },
        (data) {
          emit(state.copyWith(
            status: ViewStatus.success,
          ));

          if (!event.isAsync) {
            // print("DATA BLOC EVENT : ${event.data}");
            _hiveStorageManager.setDamagePostModel(event.data);
            // print("DATA BLOC GİRDİ 1");
            // await Future.delayed(const Duration(seconds: 2));
            // final categoryNmae = state.getDamageCategoriesResponse
            //     .firstWhere((element) => element?.id == event.data.categoryId);
            // print("DATA BLOC GİRDİ 2");

            // final partName = state.getDamagePartsResponse
            //     .firstWhere((element) => element.id == event.data.partId);
            // print("DATA BLOC GİRDİ 3");

            // final issueName = state.getDamageIssuesResponse
            //     .firstWhere((element) => element.id == event.data.issueId);
            // print("DATA BLOC GİRDİ 4");

            // final failureName = state.getDamageFailuresResponse
            //     .firstWhere((element) => element.id == event.data.failureId);
            // print("DATA BLOC GİRDİ 5");

            // final repairName = state.getDamageRepairsResponse
            //     .firstWhere((element) => element.id == event.data.repairId);
            // print("DATA BLOC GİRDİ 6");

            // final DamageResponseModel data = DamageResponseModel(
            //     id: Random().nextInt(10000),
            //     jobInspectionId: event.data.jobInspectionId,
            //     categoryId: DamagesCategory(
            //         id: event.data.categoryId, name: categoryNmae?.name ?? ''),
            //     partId: DamagesPart(
            //         id: event.data.partId,
            //         name: partName.name ?? '',
            //         categoryId: event.data.categoryId),
            //     issueId: DamagesIssue(
            //         id: event.data.issueId,
            //         name: issueName.name,
            //         partId: event.data.partId),
            //     failureId: DamagesFailure(
            //         id: event.data.failureId,
            //         name: failureName.name,
            //         issueId: event.data.issueId),
            //     repairId: DamagesRepair(
            //         id: event.data.repairId,
            //         name: repairName.name,
            //         failureId: event.data.failureId),
            //     damageImage: event.data.damageImage?.path ?? '',
            //     contextImage: event.data.contextImage?.path ?? '',
            //     price: 0.0);

            _hiveStorageManager.setGetDamage(data);

            Future.delayed(const Duration(seconds: 2));
            _hiveStorageManager.setRecordedDamage(event.data);

            emit(state.copyWith(
              status: ViewStatus.success,
              damageResponse: [data, ...state.damageResponse],
            ));
            print("DATA BLOC GİRDİ 10");
            return;
          }
        },
      );
    } else {
      if (event.isAsync) {
        emit(state.copyWith(status: ViewStatus.failure));
        return;
      }
      _hiveStorageManager.setDamagePostModel(event.data);
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
              name: issueName.name,
              partId: event.data.partId),
          failureId: DamagesFailure(
              id: event.data.failureId,
              name: failureName.name,
              issueId: event.data.issueId),
          repairId: DamagesRepair(
              id: event.data.repairId,
              name: repairName.name,
              failureId: event.data.failureId),
          damageImage: event.data.damageImage?.path ?? '',
          contextImage: event.data.contextImage?.path ?? '',
          price: 0.0);
      _hiveStorageManager.setGetDamage(data);
      await Future.delayed(const Duration(seconds: 2));
      _hiveStorageManager.setRecordedDamage(event.data);
      emit(state.copyWith(
        status: ViewStatus.success,
        damageResponse: [data, ...state.damageResponse],
      ));
    }
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
            emit(state.copyWith(
              status: ViewStatus.success,
            ));
            return;
          }
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
      _hiveStorageManager.setSignCustomerPostModel(
          event.data, event.jobInspectionId);
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(
        status: ViewStatus.success,
      ));
    }
  }

  Future<void> _postInspectionSign(
      PostInspectionSign event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading, isSigned: false));
    final result = await hasNetwork();
    if (result) {
      final resultInspectionPatch = await ProductStateItems.hiveStorageManager
          .getConditionImagePostModel(event.jobInspectionId);
      if (resultInspectionPatch.isNotEmpty) {
        await Future.forEach(resultInspectionPatch, (item) async {
          add(PostConditionImages(
              data: item!,
              jobInspectionId: event.jobInspectionId,
              isAsync: true));
          await Future.delayed(const Duration(seconds: 2));
        });

        final resultInspectionEdit = await ProductStateItems.hiveStorageManager
            .getDamagePostModel(event.jobInspectionId);
        print('resultInspectionDamage $resultInspectionEdit');
        if (resultInspectionEdit.isNotEmpty) {
          await Future.forEach(resultInspectionEdit, (item) async {
            add(PostJobInspectionsDamages(data: item!, isAsync: true));
            await Future.delayed(const Duration(seconds: 1));
          });
          await ProductStateItems.hiveStorageManager
              .deleteDamagePostModel(event.jobInspectionId);
        }

        // Await the deletion operation to ensure it's completed
        await ProductStateItems.hiveStorageManager
            .deleteConditionImagePostModel(event.jobInspectionId);
      }
      final result = await _ucGetJobInspectionsSign.postInspectorSign(
        inspectionId: event.jobInspectionId,
        data: event.data,
      );

      result.fold(
        (failure) {
          emit(state.copyWith(
              status: ViewStatus.failure, failure: failure, isSigned: false));
        },
        (data) async {
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
      ));
    }
  }

  Future<void> _onSetInspections(
      SetInspections event, Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final inspections = await _hiveStorageManager.getInspectionsListModel();
    await Future.delayed(const Duration(seconds: 2));
    print('inspections: $inspections');
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

  Future<void> _getDamagesCategory(GetInspectionsDamagesCategory event,
      Emitter<InspectionsState> emit) async {
    emit(state
        .copyWith(status: ViewStatus.loading, getDamageCategoriesResponse: []));

    final result = await _hiveStorageManager.getDamageCategoryById(
      event.damageCategoryId,
    );

    if (result != null) {
      emit(state.copyWith(
        selectedDamageCategory: result,
        getDamageFailuresResponse: [],
        getDamagePartsResponse: [],
        getDamageIssuesResponse: [],
        getDamageRepairsResponse: [],
        status: ViewStatus.success,
      ));
    }
  }

  Future<void> _getDamagesFailure(GetInspectionsDamagesFailure event,
      Emitter<InspectionsState> emit) async {
    emit(state
        .copyWith(status: ViewStatus.loading, getDamageFailuresResponse: []));
    final result =
        await _hiveStorageManager.getDamageFailures(event.damageIssueId);

    if (result != null) {
      emit(state.copyWith(
        getDamageFailuresResponse: result,
        getDamageRepairsResponse: [],
        status: ViewStatus.success,
      ));
    }
  }

  Future<void> _getDamagesIssue(
      GetInspectionsDamagesIssue event, Emitter<InspectionsState> emit) async {
    emit(state
        .copyWith(status: ViewStatus.loading, getDamageIssuesResponse: []));
    final result =
        await _hiveStorageManager.getDamageIssues(event.damagePartId);

    if (result != null) {
      emit(state.copyWith(
        getDamageIssuesResponse: result,
        getDamageFailuresResponse: [],
        getDamageRepairsResponse: [],
        status: ViewStatus.success,
      ));
    }
  }

  Future<void> _getDamagesPart(
      GetInspectionsDamagesPart event, Emitter<InspectionsState> emit) async {
    emit(
        state.copyWith(status: ViewStatus.loading, getDamagePartsResponse: []));
    final result = await _hiveStorageManager.getDamageParts(
      event.damageCategoryId,
    );

    print("DAMAGE PART : $result");

    if (result != null) {
      emit(state.copyWith(
        getDamagePartsResponse: result,
        getDamageIssuesResponse: [],
        getDamageFailuresResponse: [],
        getDamageRepairsResponse: [],
        status: ViewStatus.success,
      ));
    }
  }

  Future<void> _getDamagesRepair(
      GetInspectionsDamagesRepair event, Emitter<InspectionsState> emit) async {
    emit(state
        .copyWith(status: ViewStatus.loading, getDamageRepairsResponse: []));
    final result = await _hiveStorageManager.getDamageRepairs(
      event.damageFailureId,
    );

    if (result != null) {
      emit(state.copyWith(
        getDamageRepairsResponse: result,
        status: ViewStatus.success,
      ));
    }
  }

  Future<void> _getDamageCategories(GetInspectionsDamageCategories event,
      Emitter<InspectionsState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _hiveStorageManager.getDamageCategories();

    print("DAMAGE CATEGORY : $result");
    // print("INSPECTION ID : ${event.inspectionId}");

    if (result != []) {
      emit(state.copyWith(
        getDamageCategoriesResponse: result,
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
        state.copyWith(imageCustamerFile: file, imageCustamerName: event.name));
  }

  FutureOr<void> _setGetDamages(
      SetGetDamages event, Emitter<InspectionsState> emit) async {
    final result = await _hiveStorageManager.getGetDamage(event.inspectionId);

    print("RESULT DAMAGE : $result");

    emit(state.copyWith(damageResponse: result));
  }

  FutureOr<void> _setGetConditionImages(
      SetGetConditionImages event, Emitter<InspectionsState> emit) async {
    final result = await _hiveStorageManager.getInspectionConditionImages(
      event.inspectionId,
    );
    print('result: $result');
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
