part of 'landing_bloc.dart';

sealed class LandingEvent extends Equatable {
  const LandingEvent();
  @override
  List<Object> get props => [];
}


final class CheckConnection extends LandingEvent{
  @override
  List<Object> get props => [];
}