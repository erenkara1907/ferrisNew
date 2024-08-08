import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:ferrisfwt/feature/home/data/models/job_tracking_coordinates/tracking_coordinates_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/movement_type/feedback_input_availability.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/valet_standard/valet_standard_response_model_item.dart';
import 'package:ferrisfwt/feature/home/domain/usecases/uc_get_job.dart';
import 'package:ferrisfwt/feature/home/domain/usecases/uc_get_job_tracking_coordinates.dart';
import 'package:ferrisfwt/product/database/hive/core/hive_database_manager.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/mixin/network_mixin.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/end_job_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/start_job_post_model.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/jobs/update_job_status_post_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required UCGetJob ucGetJob,
    required UCGetJobTrackingCoordinates ucGetJobTrackingCoordinates,
  })  : _ucGetJob = ucGetJob,
        _ucGetJobTrackingCoordinates = ucGetJobTrackingCoordinates,
        super(const HomeState()) {
    _hiveDatabaseManager = ProductStateItems.hiveDatabaseManager;
    _hiveStorageManager = ProductStateItems.hiveStorageManager;
    on<GetJobs>(_onGetJobs);
    on<StartJob>(_onStartJob);
    on<EndJob>(_onEndJob);
    on<UpdateJob>(_onUpdateJob);
    on<GetJob>(_onGetJob);
    on<GetJobsValet>(_onGetJobsValet);
    on<GetJobShowValetByType>(_onGetJobShowValetByType);
    on<GetJobTracingCordinates>(_onGetJobTracingCordinates);
    on<GetTrackingCoordinate>(_onGetTrackingCoordinate);
    on<SetJob>(_onSetJob);
    on<GetJobTomorrow>(_getJobTomorrow);
    on<GetJobHistory>(_getJobHistory);
    on<ClearJob>(_onClearJob);
    on<SetValetJob>(_onSetValetJob);
    on<SetTrackingCoordinate>(_onSetTrackingCoordinate);
    on<SetExpenseCount>(_onSetExpenseCount);
    on<SetStopCount>(_onSetStopCount);
    on<UpdateTrackingCoordinate>(_onUpdateTrackingCoordinate);
    on<ConfirmJob>(_onConfirmJob);
    on<FinishJobResetHome>(_resetHomeFinishJob);
  }

  final UCGetJob _ucGetJob;
  final UCGetJobTrackingCoordinates _ucGetJobTrackingCoordinates;
  late final HiveDatabaseManager _hiveDatabaseManager;
  late final HiveStorageManager _hiveStorageManager;

  void _resetHomeFinishJob(FinishJobResetHome event, Emitter<HomeState> emit) {
    emit(state.copyWith(status: null));
  }

  Future<void> _onGetJobs(GetJobs event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading, jobs: []));

    final id = _hiveDatabaseManager.getUserModel()?.currentJobId;
    if (id == null || id == "") {
      final result = await _ucGetJob.getJob(
          date:
              "${DateTime.now().year}-${DateTime.now().month < 10 ? "0${DateTime.now().month}" : "${DateTime.now().month}"}-${DateTime.now().day < 10 ? "0${DateTime.now().day}" : DateTime.now().day}");
      result.fold(
          (failure) => emit(
              state.copyWith(status: ViewStatus.failure, failure: failure)),
          (data) {
        emit(state.copyWith(status: ViewStatus.success, jobs: data));
      });
      return;
    }
    final jobWorkingOn = await _hiveStorageManager
        .getJobWorkingOnModel(int.parse(id.toString()));

    final result = await _ucGetJob.getJob(
        date:
            "${DateTime.now().year}-${DateTime.now().month < 10 ? "0${DateTime.now().month}" : "${DateTime.now().month}"}-${DateTime.now().day < 10 ? "0${DateTime.now().day}" : DateTime.now().day}");

    result.fold(
        (failure) =>
            emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
        (data) {
      if (jobWorkingOn != null) {
        bool jobExists = false;
        for (var element in data) {
          if (element.id == jobWorkingOn.id) {
            jobExists = true;
          }
        }
        if (!jobExists) {
          final List<JobsResponseModelItem> jobs = [jobWorkingOn, ...data];
          emit(state.copyWith(status: ViewStatus.success, jobs: jobs));
        } else {
          emit(state.copyWith(status: ViewStatus.success, jobs: data));
        }
      } else {
        emit(state.copyWith(status: ViewStatus.success, jobs: data));
      }
    });
  }

  Future<void> _onGetJob(GetJob event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading, showJob: null));
    final result = await _ucGetJob.getJobShow(id: event.jobId.toString());
    result.fold(
      (failure) =>
          emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
      (data) => emit(state.copyWith(status: ViewStatus.success, showJob: data)),
    );
  }

  Future<void> _onStartJob(StartJob event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _ucGetJob.startJob(
        data: StartJobPostModel(startDate: event.jobShowModel.startDate ?? 0),
        jobId: event.jobShowModel.id);
    result.fold(
        (failure) =>
            emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
        (data) async {
      _hiveDatabaseManager.saveJob(event.jobShowModel.id.toString(),
          event.jobShowModel.startDate.toString());

      _hiveStorageManager.setJobWorkingOn(event.jobShowModel);
      emit(state.copyWith(
        status: ViewStatus.success,
        isStarted: true,
      ));
    });
  }

  Future<void> _onEndJob(EndJob event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading, isFinished: false));
    final network = await hasNetwork();

    if (network) {
      final result = await _ucGetJob.endJob(
        jobId: int.parse(event.id),
        data: event.data,
      );
      result.fold(
          (failure) => emit(
              state.copyWith(status: ViewStatus.failure, failure: failure)),
          (data) async {
        emit(state.copyWith(
          status: ViewStatus.success,
          isFinished: true,
        ));
      });
    } else {
      Future.delayed(const Duration(seconds: 1));
      if (event.feedbackInputAvailability != null) {
        final result = ProductStateItems.hiveStorageManager.getJopUpdatePage();
        if (event.isFeedBackView) {
          if (event.feedbackInputAvailability?.customer ==
                      FeedbackInputAvailabilityEnum.required &&
                  result?.customerFeedback == null ||
              result?.customerFeedback == "") {
            emit(state.copyWith(
              status: ViewStatus.failure,
            ));
            BotToast.showText(text: "Please fill the feedback form");
            return;
          } else if (event.feedbackInputAvailability?.vehicle ==
                      FeedbackInputAvailabilityEnum.required &&
                  result?.vehicleFeedback == null ||
              result?.vehicleFeedback == "") {
            emit(state.copyWith(
              status: ViewStatus.failure,
            ));
            BotToast.showText(text: "Please fill the feedback form");
            return;
          } else if (event.isViewFuel &&
              result?.fuelChargeLevelCollection == 0 &&
              result?.fuelChargeLevelDelivery == 0) {
            emit(state.copyWith(
              status: ViewStatus.failure,
            ));
            BotToast.showText(text: "Please fill the feedback form");
            return;
          } else {
            _hiveStorageManager.saveJobToFinish(event.data);
            ProductStateItems.hiveDatabaseManager.updateFinishStatus();
            emit(state.copyWith(
              status: ViewStatus.success,
              noNetworkFinished: true,
            ));
          }
        }
      }
    }
  }

  Future<void> _onUpdateJob(UpdateJob event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await hasNetwork();
    if (result) {
      final result = await _ucGetJob.updateJob(
        jobId: int.parse(event.id),
        updateJobStatusPostModel: event.data,
      );
      result.fold(
          (failure) => emit(
              state.copyWith(status: ViewStatus.failure, failure: failure)),
          (data) {
        if (event.isAsync) {
          emit(state.copyWith(status: ViewStatus.success));
          return;
        }
        _hiveStorageManager.setJopUpdates(event.data);
        emit(state.copyWith(status: ViewStatus.success, isFinished: false));
      });
    } else {
      await Future.delayed(const Duration(seconds: 2));
      _hiveStorageManager.insertJobUpdate(event.data);
      _hiveStorageManager.setJopUpdates(event.data);
      emit(state.copyWith(
        status: ViewStatus.success,
      ));
    }
  }

  Future<void> _onGetJobsValet(
      GetJobsValet event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _ucGetJob.getJobValetStandards();
    result.fold(
        (failure) =>
            emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
        (data) {
      _hiveStorageManager.setValetStandards(data);
      emit(state.copyWith(status: ViewStatus.success, jobsValet: data));
    });
  }

  Future<void> _onGetJobShowValetByType(
      GetJobShowValetByType event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _ucGetJob.showJobValetStandards(
        id: event.movementTypeId.toString());
    result.fold(
      (failure) =>
          emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
      (data) => emit(state.copyWith(
        status: ViewStatus.success,
        jobsValetByType: data,
      )),
    );
  }

  Future<void> _onGetJobTracingCordinates(
      GetJobTracingCordinates event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    print("event.jobId: ${event.jobId}");
    final result = await _ucGetJobTrackingCoordinates
        .getJobTrackingCoordinatess(jobId: event.jobId);
    result.fold(
        (failure) =>
            emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
        (data) {
      print("dataaaaaaa: $data");
      emit(state.copyWith(
        status: ViewStatus.success,
        getTrackingCoordinatesResponse: data,
        isStarted: false,
      ));
    });
  }

  Future<void> _onGetTrackingCoordinate(
      GetTrackingCoordinate event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _ucGetJobTrackingCoordinates.getTrackingCoordinate(
      id: event.id,
    );
    result.fold(
        (failure) =>
            emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
        (data) {
      _hiveStorageManager.setTrackingCoordinate(data);
      emit(state.copyWith(
        status: ViewStatus.success,
        selectedTrackingCoordinate: data,
        isStarted: false,
      ));
    });
  }

  void _onSetJob(SetJob event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      status: ViewStatus.loading,
    ));
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(
        status: ViewStatus.success, showJob: event.jobModel, isAsync: true));
  }

  void _getJobTomorrow(GetJobTomorrow event, Emitter<HomeState> emit) async {
    final resultNetwork = await hasNetwork();
    if (!resultNetwork) {
      return;
    }
    emit(state.copyWith(status: ViewStatus.loading, jobsTomorrow: []));

    final result = await _ucGetJob.getJob(
        date:
            "${DateTime.now().year}-${DateTime.now().month < 9 ? "0${DateTime.now().month}" : "${DateTime.now().month}"}-${DateTime.now().day + 1 < 9 ? "0${DateTime.now().day + 1}" : "${DateTime.now().day + 1}"}");
    print(
        "${DateTime.now().year}-${DateTime.now().month < 9 ? "0${DateTime.now().month}" : "${DateTime.now().month}"}-${DateTime.now().day + 1 < 9 ? "0${DateTime.now().day + 1}" : "${DateTime.now().day + 1}"}");
    result.fold(
        (failure) =>
            emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
        (data) {
      print("data: $data");
      emit(state.copyWith(status: ViewStatus.success, jobsTomorrow: data));
    });
  }

  void _getJobHistory(GetJobHistory event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading, jobsHistory: []));

    final result = await _ucGetJob.getJob(
      status: "2",
    );

    result.fold(
        (failure) =>
            emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
        (data) {
      emit(state.copyWith(status: ViewStatus.success, jobsHistory: data));
    });
  }

  void _onClearJob(ClearJob event, Emitter<HomeState> emit) async {
    emit(state.copyWith(showJob: null));
  }

  void _onSetValetJob(SetValetJob event, Emitter<HomeState> emit) async {
    final valetStandard = await _hiveStorageManager.getValetStandards();

    emit(state.copyWith(
      jobsValet: valetStandard,
    ));
  }

  void _onSetTrackingCoordinate(
      SetTrackingCoordinate event, Emitter<HomeState> emit) async {
    final trackingCoordinate =
        await _hiveStorageManager.getTrackingCoordinateModel();

    emit(state.copyWith(
      selectedTrackingCoordinate: trackingCoordinate,
    ));
  }

  void _onSetExpenseCount(
      SetExpenseCount event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      totalExpense: event.totalExpense,
    ));
  }

  void _onSetStopCount(SetStopCount event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      stopCount: state.stopCount + 1,
    ));
  }

  Future<void> _onUpdateTrackingCoordinate(
      UpdateTrackingCoordinate event, Emitter<HomeState> emit) async {
    final result = await hasNetwork();
    if (result) {
      await _ucGetJobTrackingCoordinates.updateTrackingCoordinate(
        jobId: event.jobId,
        latitude: event.latitude,
        longitude: event.longitude,
      );
    } else {}
  }

  Future<void> _onConfirmJob(ConfirmJob event, Emitter<HomeState> emit) async {
    final resultNetwork = await hasNetwork();
    if (!resultNetwork) {
      return;
    }
    if (event.isDetail) {
      final result = await _ucGetJob.confirmJob(
        id: event.id,
      );
      result.fold(
          (failure) => emit(
              state.copyWith(status: ViewStatus.failure, failure: failure)),
          (data) {
        add(const GetJobs());
        BotToast.showText(text: 'Job confirmed successfully');
      });
      return;
    }
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _ucGetJob.confirmJob(
      id: event.id,
    );
    result.fold(
        (failure) =>
            emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
        (data) {
      add(const GetJobs());
      BotToast.showText(text: 'Job confirmed successfully');
      emit(state.copyWith(status: ViewStatus.success));
    });
  }
}
