part of 'new_timer_bloc.dart';

abstract class NewTimerEvent extends Equatable {
  const NewTimerEvent();

  @override
  List<Object> get props => [];
}

class NewTimerStarted extends NewTimerEvent {
  const NewTimerStarted({required this.duration});
  final int duration;
}

class NewTimerPaused extends NewTimerEvent {
  const NewTimerPaused();
}

class NewTimerResumed extends NewTimerEvent {
  const NewTimerResumed();
}

class NewTimerReset extends NewTimerEvent {
  const NewTimerReset();
}

class NewTimerTicked extends NewTimerEvent {
  const NewTimerTicked({required this.duration});
  final int duration;

  @override
  List<Object> get props => [duration];
}
