import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({Key? key}) : super(key: key);

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours = true;

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('stop watch page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
        StreamBuilder<int>(
        stream: _stopWatchTimer.rawTime,
            initialData: _stopWatchTimer.rawTime.value,
            builder: (context, snapshot) {
              final value = snapshot.data;
              final displayTime =
              StopWatchTimer.getDisplayTime(value!, hours: _isHours);

              return Text(displayTime,
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold));
            }),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                },
                child: const Text('Start'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                },
                child: const Text('Stop'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                },
                child: const Text('Reset'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  // 기록 기능
                },
                child: const Text('ADD'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        ],
      ),
    ),
    );
  }
}
