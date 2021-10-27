import 'package:counter_with_blocks/ticker.dart';
import 'package:counter_with_blocks/timer/bloc/timer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double firstState = 0;
    return BlocProvider<TimerBloc>(
      create: (_) => TimerBloc(ticker: Ticker()),
      child: Scaffold(
          appBar: AppBar(
            title: Text("Timer"),
            elevation: 0,
            centerTitle: true,
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            //  color: Colors.pink,
            child: Stack(
              children: [
                Positioned(
                    child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white.withOpacity(.1),
                  child: Stack(
                    children: [
                      BlocBuilder<TimerBloc, TimerState>(
                        builder: (context, state) {
                          debugPrint("f " +
                              firstState.toString() +
                              " d " +
                              state.duration.toString());
                          if (firstState < state.duration) {
                            firstState = state.duration.toDouble();
                            debugPrint("girdi");
                          }
                          debugPrint("first state" + firstState.toString());
                          return AnimatedContainer(
                            curve: Curves.ease,
                            duration: const Duration(seconds: 1),
                            color: Colors.purple,
                            width: MediaQuery.of(context).size.width /
                                firstState *
                                state.duration,
                            height: MediaQuery.of(context).size.height * .02,
                          );
                        },
                      ),
                    ],
                  ),
                )),
                Positioned(
                  top: MediaQuery.of(context).size.height * .3,
                  left: MediaQuery.of(context).size.width / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TimerText(),
                      ActionsButton(),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class ActionsButton extends StatelessWidget {
  const ActionsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (state is TimerInitial) ...[
              acitonButtonMethod(
                  () => context.read<TimerBloc>().add(
                        TimerStarted(
                          duration: state.duration,
                        ),
                      ),
                  Icons.play_arrow_rounded)
            ],
            if (state is TimerRunInProgress) ...[
              acitonButtonMethod(
                () => context.read<TimerBloc>().add(TimerPaused()),
                Icons.pause,
              ),
              SizedBox(width: 20),
              acitonButtonMethod(
                () => context.read<TimerBloc>().add(TimerReset()),
                Icons.replay_rounded,
              ),
            ],
            if (state is TimerRunPause) ...[
              acitonButtonMethod(
                () => context.read<TimerBloc>().add(TimerResumed()),
                Icons.play_arrow_rounded,
              ),
              SizedBox(width: 20),
              acitonButtonMethod(
                () => context.read<TimerBloc>().add(TimerReset()),
                Icons.replay_rounded,
              ),
            ],
            if (state is TimerRunCompleted) ...[
              acitonButtonMethod(
                () => context.read<TimerBloc>().add(TimerReset()),
                Icons.replay_rounded,
              ),
            ],
          ],
        );
      },
    );
  }

  InkWell acitonButtonMethod(Function() function, IconData icon) {
    return InkWell(
      onTap: function,
      borderRadius: BorderRadius.circular(50),
      child: CircleAvatar(
        backgroundColor: Colors.white24,
        child: Icon(
          icon,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: Theme.of(context).textTheme.headline2,
    );
  }
}
