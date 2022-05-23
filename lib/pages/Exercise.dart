//ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:provider/provider.dart';
import 'package:capstone_2022_48/model/DataModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({Key? key}) : super(key: key);

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  // FirebaseFirestore firestore = FirebaseFirestore.instance;

  late ExerciseData _exerciseData;

  DateTime _today = DateTime.now();

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours = true;
  final List<String> _valueList = [
    '운동 선택',
    '걷기',
    '필라테스',
    '요가',
    '스트레칭',
    '헬스',
    '그외'
  ];
  final Map<String, int> _exerciseList = {
    '걷기': 1,
    '필라테스': 2,
    '요가': 3,
    '스트레칭': 4,
    '헬스': 5,
    '그외': 6,
  };

  String _selectedValue = '운동 선택';

  CollectionReference exercisedatas =
      FirebaseFirestore.instance.collection('ExerciseDataCollection');

  Future<void> addExerciseData() {
    // Call the user's CollectionReference to add a new user
    return exercisedatas
        .add({
          'date': _today,
          'time': _stopWatchTimer.secondTime.value ~/ 60,
          'type': _exerciseList[_selectedValue],
        })
        .then((value) => print("add exercise"))
        .catchError((error) => print("Failed to add food: $error"));
  }

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _exerciseData = Provider.of<ExerciseData>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200.0,
                decoration: BoxDecoration(
                    // color: Color.fromARGB(255, 200, 199, 199),
                    borderRadius: BorderRadius.circular(7.0),
                    border:
                        Border.all(color: Color.fromARGB(255, 200, 199, 199))),
                child: Center(
                  child: DropdownButton<String>(
                      underline: SizedBox.shrink(),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pretendard',
                        color: Colors.black,
                      ),
                      value: _selectedValue,
                      items: _valueList.map(
                        (value) {
                          return DropdownMenuItem(
                              value: value, child: Text(value));
                        },
                      ).toList(),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          _selectedValue = value!;
                        });
                      }),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snapshot) {
                    final value = snapshot.data;
                    final displayTime =
                        StopWatchTimer.getDisplayTime(value!, hours: _isHours);

                    return Text(displayTime,
                        style: const TextStyle(
                            fontSize: 36,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.bold));
                  }),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                      },
                      child: const Text('시작'),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(100, 70),
                        primary: Color(0xffFFCD00),
                        shape: CircleBorder(),
                        elevation: 0.0,
                        textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pretendard'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                      },
                      child: const Text('정지'),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(100, 70),
                        primary: Color(0xffbbbbbb),
                        elevation: 0.0,
                        shape: CircleBorder(),
                        textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pretendard'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                        setState(() {
                          _selectedValue = '운동 선택';
                        });
                      },
                      label: Text('리셋'),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(100, 45),
                        primary: Color(0xffbbbbbb),
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        textStyle: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
                        // print(_stopWatchTimer.rawTime.value);
                        // print(_stopWatchTimer.minuteTime.value);
                        print(_stopWatchTimer.secondTime.value ~/ 60);
                        context
                            .read<ExerciseData>()
                            .addTime(_stopWatchTimer.secondTime.value);
                        addExerciseData();
                        // firestore.collection('ExerciseDataCollection').add({
                        //   'date': _today,
                        //   'type': _exerciseList[_selectedValue],
                        //   'time': _stopWatchTimer.secondTime.value
                        // });
                        // String hours = StopWatchTimer.getDisplayTimeHours(value);
                        // _exerciseData
                        //     .addTime(StopWatchTimer.getDisplayTime(value));
                      },
                      label: Text('추가'),
                      // child: Text('${StopWatchTimer.getRawHours()}'),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(100, 45),
                        primary: Color(0xff19335A),
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pretendard',
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
