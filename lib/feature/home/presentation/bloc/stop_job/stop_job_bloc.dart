import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ferrisfwt/feature/home/data/models/job_stop/stop_categories_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/job_stop/stops_response_model_item.dart';
import 'package:ferrisfwt/feature/home/domain/usecases/uc_get_job_stop.dart';
import 'package:ferrisfwt/product/database/hive/core/hive_database_manager.dart';
import 'package:ferrisfwt/product/database/hive_operation/hive_storage_manager.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/mixin/network_mixin.dart';
import 'package:ferrisfwt/product/state/base/model/post_models/stops/stop_post_model.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';

part 'stop_job_event.dart';
part 'stop_job_state.dart';

class StopJobBloc extends Bloc<StopJobEvent, StopJobState> {
  StopJobBloc({
    required UCGetJobStop ucGetJobStop,
    required HiveDatabaseManager hiveDatabaseManager,
    required HiveStorageManager hiveStorageManager,
  })  : _ucGetJobStop = ucGetJobStop,
        _hiveDatabaseManager = hiveDatabaseManager,
        _hiveStorageManager = hiveStorageManager,
        super(const StopJobState()) {
    // _hiveDatabaseManager = ProductStateItems.hiveDatabaseManager;
    // _hiveStorageManager = ProductStateItems.hiveStorageManager;
    on<GetJobStops>(_onGetJobStops);
    on<PostJobStops>(_onPostJobStops);
    on<PostJobStopsControl>(_onPostJobStopsControl);
    on<GetJobStopsCategories>(_onGetJobStopsCategories);
    on<SetJobStopCategories>(_onSetJobStopCategories);
    on<SetJobStop>(_onSetJobStop);
    on<ClearJobStops>(_onClearJobStops);
  }

  final UCGetJobStop _ucGetJobStop;
  late final HiveDatabaseManager _hiveDatabaseManager;
  late final HiveStorageManager _hiveStorageManager;

  void _onClearJobStops(ClearJobStops event, Emitter<StopJobState> emit) async {
    emit(state.copyWith(
      getStopsResponse: [],
      totalStop: 0,
    ));
  }

  void _onGetJobStops(GetJobStops event, Emitter<StopJobState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _ucGetJobStop.getJobStops(jobId: event.jobId);
    result.fold(
      (failure) {
        emit(state.copyWith(status: ViewStatus.failure, failure: failure));
      },
      (data) {
        emit(
            state.copyWith(status: ViewStatus.failure, getStopsResponse: data));
      },
    );
  }

  void _onPostJobStopsControl(
      PostJobStopsControl event, Emitter<StopJobState> emit) async {
    emit(state.copyWith(status: ViewStatus.failure, isError: true));
  }

  void _onPostJobStops(PostJobStops event, Emitter<StopJobState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final resultHasNetwork = await hasNetwork();
    if (resultHasNetwork) {
      final result = await _ucGetJobStop.postJobStops(
        jobId: event.jobId,
        data: event.data,
      );
      result.fold(
        (failure) {
          emit(state.copyWith(
            status: ViewStatus.failure,
            failure: failure,
            isError: true,
          ));
        },
        (data) {
          if (event.isAsync) {
            emit(state.copyWith(
              status: ViewStatus.success,
              isError: false,
            ));
            return;
          }
          emit(state.copyWith(
              status: ViewStatus.success,
              isError: false,
              selectedStop: data,
              totalStop: state.totalStop + 1));

          _hiveDatabaseManager.saveTotalStop(state.totalStop);
        },
      );
    } else {
      if (event.isAsync) {
        emit(state.copyWith(
          status: ViewStatus.failure,
          isError: true,
        ));
        return;
      }
      _hiveStorageManager.setJobStopAsync(event.data);
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(
        status: ViewStatus.success,
        totalStop: state.totalStop + 1,
        isError: false,
      ));

      _hiveDatabaseManager.saveTotalStop(state.totalStop);
    }
  }

  void _onGetJobStopsCategories(
      GetJobStopsCategories event, Emitter<StopJobState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _ucGetJobStop.getStopCategories();
    result.fold(
      (failure) {
        emit(state.copyWith(status: ViewStatus.failure, failure: failure));
      },
      (data) {
        _hiveStorageManager.setStopCategories(data);
        emit(state.copyWith(
            status: ViewStatus.success, getStopCategoriesResponse: data));
      },
    );
  }

  void _onSetJobStopCategories(
      SetJobStopCategories event, Emitter<StopJobState> emit) async {
    final data = _hiveStorageManager.getStopCategories();
    emit(state.copyWith(
        status: ViewStatus.success, getStopCategoriesResponse: data));
  }

  void _onSetJobStop(SetJobStop event, Emitter<StopJobState> emit) async {
    final data = _hiveDatabaseManager.getUserModel()?.totalStop;
    emit(state.copyWith(status: ViewStatus.success, totalStop: data ?? 0));
  }
}
