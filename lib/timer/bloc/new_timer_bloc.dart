import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_timer/ticker.dart';

part 'new_timer_event.dart';
part 'new_timer_state.dart';

class NewTimerBloc extends Bloc<NewTimerEvent, NewTimerState> {
  final Ticker _ticker;
  static int _duration = 0;

  StreamSubscription<int>? _tickerSubscription;

  NewTimerBloc(int init_duration, {required Ticker ticker})
      : _ticker = ticker,
        super(NewTimerInitial(init_duration)) {
    on<NewTimerStarted>(_onStarted);
    on<NewTimerPaused>(_onPaused);
    on<NewTimerResumed>(_onResumed);
    on<NewTimerReset>(_onReset);
    on<NewTimerTicked>(_onTicked);
    _duration = init_duration;
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(NewTimerStarted event, Emitter<NewTimerState> emit) {
    emit(NewTimerRunInProgress(event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(NewTimerTicked(duration: duration)));
  }

  void _onPaused(NewTimerPaused event, Emitter<NewTimerState> emit) {
    if (state is NewTimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(NewTimerRunPause(state.duration));
    }
  }

  void _onResumed(NewTimerResumed resumed, Emitter<NewTimerState> emit) {
    if (state is NewTimerRunPause) {
      _tickerSubscription?.resume();
      emit(NewTimerRunInProgress(state.duration));
    }
  }

  void _onReset(NewTimerReset event, Emitter<NewTimerState> emit) {
    _tickerSubscription?.cancel();
    emit(NewTimerInitial(_duration));
  }

  void _onTicked(NewTimerTicked event, Emitter<NewTimerState> emit) {
    emit(
      event.duration > 0
          ? NewTimerRunInProgress(event.duration)
          : NewTimerRunComplete(),
    );
  }
}
