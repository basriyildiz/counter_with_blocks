part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final int duration;
  const TimerState(this.duration);



  @override
  List<Object> get props => [duration];
}

class TimerInitial extends TimerState {
  TimerInitial(int duration) : super(duration);

  @override
  String toString() {
    // TODO: implement toString
    return "TimerInitial { duration: $duration }";
  }
}

class TimerRunPause extends TimerState {
  TimerRunPause(int duration) : super(duration);

  @override
  String toString() {
    // TODO: implement toString
    return "TimerRunPause { duration: $duration }";
  }
}

class TimerRunInProgress extends TimerState {
  TimerRunInProgress(int duration) : super(duration);

  @override
  String toString() {
    // TODO: implement toString
    return "TimerRunInProgress { duration: $duration }";
  }
}

class TimerRunCompleted extends TimerState {
  TimerRunCompleted() : super(0);
}
