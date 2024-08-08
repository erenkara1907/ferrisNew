import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:ferrisfwt/product/errors/failures/failures.dart';
import 'package:ferrisfwt/product/extensions/network_extensions.dart';
import 'package:ferrisfwt/product/manager/utils/event_transformer/event_tranformer_utils.dart';
import 'package:ferrisfwt/product/utility/constants/duration_constants.dart';
import 'package:ferrisfwt/product/utility/enums/network_result.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'landing_event.dart';
part 'landing_state.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  LandingBloc() : super(const LandingState()) {
    on<CheckConnection>(
      _checkConnection,
      transformer: EventTransformerUtils.throttle(DurationConstants.medium()),
    );
  }

  Future<void> _checkConnection(
    CheckConnection event,
    Emitter<LandingState> emit,
  ) async {
    emit(state.copyWith(status: ViewStatus.loading));
    try {
      final result = NetworkResultExtension.checkConnectivityResult(
        await Connectivity().checkConnectivity(),
      );
      if (result == NetworkResult.off) {
        emit(state.copyWith(networkResult: false, status: ViewStatus.success));
      } else {
        emit(state.copyWith(networkResult: true, status: ViewStatus.success));
      }
    } catch (e) {
      emit(
        state.copyWith(
          networkResult: false,
          status: ViewStatus.failure,
          failure: NetworkFailure(),
        ),
      );
    }
  }
}
