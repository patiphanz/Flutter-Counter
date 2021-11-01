import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer/ticker.dart';
import 'package:flutter_timer/timer/timer.dart';

class NewTimerPage extends StatelessWidget {
  const NewTimerPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    int init_duration = ModalRoute.of(context)!.settings.arguments as int;
    return BlocProvider(
      create: (_) => NewTimerBloc(init_duration, ticker: Ticker()),
      child: const NewTimerView(),
    );
  }
}

class NewTimerView extends StatelessWidget {
  const NewTimerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Timer')),
      body: Stack(
        children: [
          const NewBackground(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100.0),
                child: Center(child: NewTimerText()),
              ),
              NewActions(),
            ],
          ),
        ],
      ),
    );
  }
}

class NewTimerText extends StatelessWidget {
  const NewTimerText({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final duration = context.select((NewTimerBloc bloc) => bloc.state.duration);
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: Theme.of(context).textTheme.headline1,
    );
  }
}

class NewActions extends StatelessWidget {
  const NewActions({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final duration = context.select((NewTimerBloc bloc) => bloc.state.duration);
    return BlocBuilder<NewTimerBloc, NewTimerState>(
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (state is NewTimerInitial) ...[
              FloatingActionButton(
                child: Icon(Icons.play_circle),
                onPressed: () => context
                    .read<NewTimerBloc>()
                    .add(NewTimerStarted(duration: state.duration)),
              ),
            ],
            if (state is NewTimerRunInProgress) ...[
              FloatingActionButton(
                  child: Icon(Icons.pause),
                  onPressed: () =>
                      context.read<NewTimerBloc>().add(NewTimerPaused())),
              FloatingActionButton(
                child: Icon(Icons.replay),
                onPressed: () =>
                    context.read<NewTimerBloc>().add(NewTimerReset()),
              ),
            ],
            if (state is NewTimerRunPause) ...[
              FloatingActionButton(
                child: Icon(Icons.play_circle),
                onPressed: () =>
                    context.read<NewTimerBloc>().add(NewTimerResumed()),
              ),
              FloatingActionButton(
                child: Icon(Icons.replay),
                onPressed: () =>
                    context.read<NewTimerBloc>().add(NewTimerReset()),
              ),
            ],
            if (state is NewTimerRunComplete) ...[
              FloatingActionButton(
                child: Icon(Icons.replay),
                onPressed: () =>
                    context.read<NewTimerBloc>().add(NewTimerReset()),
              ),
            ]
          ],
        );
      },
    );
  }
}

class NewBackground extends StatelessWidget {
  const NewBackground({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade500,
          ],
        ),
      ),
    );
  }
}
