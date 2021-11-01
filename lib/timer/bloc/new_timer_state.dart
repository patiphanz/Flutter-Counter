part of 'new_timer_bloc.dart';

abstract class NewTimerState extends Equatable {
  final int duration;

  const NewTimerState(this.duration);

  @override
  List<Object> get props => [duration];
}

class NewTimerInitial extends NewTimerState {
  const NewTimerInitial(int duration) : super(duration);

  @override
  String toString() => 'NewTimerIntial { duration: $duration }';
}

class NewTimerRunPause extends NewTimerState {
  const NewTimerRunPause(int duration) : super(duration);

  @override
  String toString() => 'NewTimerRunPause { duration: $duration }';
}

class NewTimerRunInProgress extends NewTimerState {
  const NewTimerRunInProgress(int duration) : super(duration);

  @override
  String toString() => 'NewTimerRunInProgress { duration $duration }';
}

class NewTimerRunComplete extends NewTimerState {
  const NewTimerRunComplete() : super(10);
}
