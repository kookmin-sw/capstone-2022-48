import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';
import 'package:capstone_2022_48/model/DataModel.dart';
import 'dart:io';
import 'package:capstone_2022_48/model/DataModel.dart';
import 'package:capstone_2022_48/pages/Diet.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeCalendar extends StatefulWidget {
//   final Future<Database> db;
  const HomeCalendar({Key? key}) : super(key: key);

  @override
  _HomeCalendarState createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  Map<String, Icon> iconList = {
    'good': Icon(Icons.sentiment_very_satisfied, color: Color(0xffFFCD00)),
    'soso': Icon(Icons.sentiment_satisfied, color: Color(0xff4675C0)),
    'bad': Icon(Icons.mood_bad, color: Color(0xffB8BFD6)),
    'default': Icon(Icons.sentiment_satisfied, color: Color(0xffbbbbbb)),
  };
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  bool _isToday = true;
  bool _isPast = false;
  bool _isFuture = false;
  int _isDay = 0; // 0:오늘 1:오늘이전 2:오늘이후

  CalendarFormat _calendarFormat = CalendarFormat.month;

  // pedometer
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?';
  String _steps = '?';
  // String _steps = context.watch<StepData>().steps.toString();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    // Handle step count changed
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    // Handle step count changed
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('사용자 보행 상태 에러: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('만보기 카운트 에러: $error');
    setState(() {
      _steps = '0';
    });
  }

  void initPlatformState() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _pedestrianStatusStream
          .listen(onPedestrianStatusChanged)
          .onError(onPedestrianStatusError);

      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
    } else {}
    if (!mounted) return;
  }

  var _selected = '';
  var _test = 'Full Screen';

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference _collectionExercise =
      FirebaseFirestore.instance.collection('ExerciseDataCollection');

  CollectionReference _collectionDiet =
      FirebaseFirestore.instance.collection('DietDataCollection');

  CollectionReference _collectionSteps =
      FirebaseFirestore.instance.collection('StepDataCollection');

  Future<void> getData() async {
    DateTime _now = DateTime.now();
    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
    DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

    QuerySnapshot querySnapshot = await _collectionExercise
        .where('date', isGreaterThanOrEqualTo: _start)
        .where('date', isLessThanOrEqualTo: _end)
        .orderBy('date')
        .get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    // print(allData.elementAt(1));
    print(allData);
  }

  int todayExerciseTimes = 0;

  @override
  Widget build(BuildContext context) {
    // getData();
    // int _exerciseMinutes = context.watch<ExerciseData>().time ~/ 60;
    // // int _exerciseMinutes = context.watch<ExerciseData>().time;
    // int _exerciseHours =
    //     (_exerciseMinutes ~/ 60 == 0) ? 0 : _exerciseMinutes ~/ 60;

    double _cal = context.watch<DietData>().calories;

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Text(
              //   '오늘은 ' + (_selectedDay == DateTime.now())
              //       ? _steps
              //       : getStepsData(_selectedDay).toString() + ' 걸음',
              //   style: TextStyle(
              //       fontSize: 30,
              //       fontFamily: 'Pretendard',
              //       fontWeight: FontWeight.bold),
              // ),
              // Text(
              //   '오늘은 ' + _steps + ' 걸음',
              //   style: TextStyle(
              //       fontSize: 30,
              //       fontFamily: 'Pretendard',
              //       fontWeight: FontWeight.bold),
              // ),
              getStepsFutureBuilder(),
              SizedBox(
                height: 10,
              ),
              Container(
                width: size.width * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffeeeeee),
                ),
                child: TableCalendar(
                  locale: 'ko-KR',

                  focusedDay: DateTime.now(),
                  // focusedDay: DateTime(2022, 5, 18),
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2030),

                  selectedDayPredicate: (DateTime date) {
                    return isSameDay(_selectedDay, date);
                  },
                  onDaySelected: (selectDay, focusDay) {
                    setState(() {
                      _selectedDay = selectDay;
                      _focusedDay = focusDay;
                    });
                  },

                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },

                  startingDayOfWeek: StartingDayOfWeek.monday,
                  // daysOfWeekVisible: true,
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },

                  // header style
                  headerVisible: true,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    // centerHeaderTitle: true,
                    leftChevronIcon: Icon(Icons.arrow_back_ios_rounded),
                    rightChevronIcon: Icon(Icons.arrow_forward_ios_rounded),
                    // titleTextStyle: const TextStyle(fontSize: 15.0),
                  ),
                  daysOfWeekHeight: 20,

                  // calendar style
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(color: Colors.grey),
                    weekendTextStyle: TextStyle(color: Colors.grey),
                    isTodayHighlighted: true,

                    // selectedDecoration: BoxDecoration(
                    //   color: Colors.blue,
                    //   shape: BoxShape.circle,
                    // ),
                    // selectedTextStyle: TextStyle(color: Colors.white),

                    // today style
                    todayDecoration: BoxDecoration(
                        color: Color(0xffc1c1c1), shape: BoxShape.circle),
                    // color: Color(0xff6fa8dc), shape: BoxShape.circle),
                    todayTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xffffffff),
                        fontSize: 16),

                    // selected day style
                    selectedDecoration: BoxDecoration(
                      color: Color(0xff6fa8dc),
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xffffffff),
                        fontSize: 16),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // todayExercise(),
                  // FutureBuilder(
                  //   future: exercisefromdb(),
                  //   builder: (context, snapshot) {
                  // DateTime _now = DateTime.now();
                  // DateTime _start =
                  //     DateTime(_now.year, _now.month, _now.day, 0, 0);
                  // DateTime _end =
                  //     DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

                  // QuerySnapshot querySnapshot = await _collectionRef
                  //     .where('date', isGreaterThanOrEqualTo: _start)
                  //     .where('date', isLessThanOrEqualTo: _end)
                  //     .orderBy('date')
                  //     .get();
                  // final allData =
                  //     querySnapshot.docs.map((doc) => doc.data()).toList();
                  // // print(allData.elementAt(1));
                  // // print(allData);

                  // return Container(
                  //   width: MediaQuery.of(context).size.width * 0.4,
                  //   height: 100,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10),
                  //     color: Color(0xffeeeeee),
                  //   ),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: <Widget>[
                  //       Text(
                  //         '운동 시간',
                  //         style: TextStyle(
                  //           fontFamily: 'Pretendard',
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 20,
                  //         ),
                  //       ),
                  //       Text(
                  //         // 'data',
                  //         // '${context.watch<ExerciseData>().time}',
                  //         // '${_exerciseHocurs}시간 ${_exerciseMinutes}분',
                  //         'ㅏ하ㅏ하하하하',
                  //         style: TextStyle(
                  //             fontFamily: 'Pretendard',
                  //             fontWeight: FontWeight.normal),
                  //       ),
                  //     ],
                  //   ),
                  // );
                  //   },
                  // ),
                  // FutureBuilder(
                  //   future: getExerciseData(),
                  //   builder: (context, snapshot) {
                  //     int d = snapshot.data as int;
                  //     int todayExerciseMinutes = d % 60;
                  //     // print(todayExerciseMinutes);
                  //     // int _exerciseMinutes = context.watch<ExerciseData>().time;
                  //     int todayExerciseHours = d ~/ 60;

                  //     return Container(
                  //       width: MediaQuery.of(context).size.width * 0.4,
                  //       height: 100,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10),
                  //         color: Color(0xffeeeeee),
                  //       ),
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: <Widget>[
                  //           Text(
                  //             '운동 시간',
                  //             style: TextStyle(
                  //               fontFamily: 'Pretendard',
                  //               fontWeight: FontWeight.bold,
                  //               fontSize: 20,
                  //             ),
                  //           ),
                  //           Text(
                  //             // 'data',
                  //             // '${context.watch<ExerciseData>().time ~/ 60}',
                  //             // '${_exerciseHocurs}시간 ${_exerciseMinutes}분',
                  //             // 'ㅏ하ㅏ하하하하',
                  //             // '${todayExerciseTimes}시간 ${todayExerciseTimes}분',
                  //             '${todayExerciseHours}시간 ${todayExerciseMinutes}분',
                  //             // '$docSnapshots[i]['time']',
                  //             style: TextStyle(
                  //                 fontFamily: 'Pretendard',
                  //                 fontWeight: FontWeight.normal),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  // ),
                  getExerciseFutureBuilder(),
                  // Container(
                  //   width: size.width * 0.4,
                  //   height: 100,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10),
                  //     color: Color(0xffeeeeee),
                  //   ),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: <Widget>[
                  //       Text(
                  //         '운동 시간',
                  //         style: TextStyle(
                  //           fontFamily: 'Pretendard',
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 20,
                  //         ),
                  //       ),
                  //       Text(
                  //         // 'data',
                  //         // '${context.watch<ExerciseData>().time}',
                  //         '${_exerciseHours}시간 ${_exerciseMinutes}분',
                  //         style: TextStyle(
                  //             fontFamily: 'Pretendard',
                  //             fontWeight: FontWeight.normal),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  getCalFutureBuilder(),
                  // Container(
                  //   width: size.width * 0.4,
                  //   height: 100,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10),
                  //     color: Color(0xffeeeeee),
                  //   ),
                  //   // child: (_selectedDay == DateTime.now())
                  //   //     ? TodayDiet()
                  //   //     : FutureDiet(),
                  //   // child: ConditionalDiet(Whatday(_selectedDay)),
                  //   // child: Whatday(_selectedDay),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: <Widget>[
                  //       Text(
                  //         '섭취 칼로리',
                  //         style: TextStyle(
                  //           fontFamily: 'Pretendard',
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 20,
                  //         ),
                  //       ),
                  //       Text(
                  //         // 'data',
                  //         // '${context.watch<ExerciseData>().time}',
                  //         '${_cal.round()} 칼로리',
                  //         style: TextStyle(
                  //             fontFamily: 'Pretendard',
                  //             fontWeight: FontWeight.normal),
                  //       ),
                  //     ],
                  //   ),
                  //   //_sectedDay! 오류나서 _selectedDay로 수정
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder getStepsFutureBuilder() {
    return FutureBuilder(
      future: getStepsData(_selectedDay),
      builder: (context, snapshot) {
        final int d = snapshot.data ?? 0;
        // print(DateTime.now());

        if (_selectedDay == DateTime.now()) {
          // print(DateTime.now());
          // if (_selectedDay == DateTime.now().toUtc().add(Duration(hours: -9))) {
          return Text(
            '오늘은 ' + _steps + ' 걸음',
            style: TextStyle(
                fontSize: 30,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.bold),
          );
        } else {
          return Text(
            '오늘은 ' + d.toString() + ' 걸음',
            style: TextStyle(
                fontSize: 30,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.bold),
          );
        }

        // return Container(
        //   width: MediaQuery.of(context).size.width * 0.4,
        //   height: 100,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10),
        //     color: Color(0xffeeeeee),
        //   ),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: <Widget>[
        //       Text(
        //         '운동 시간',
        //         style: TextStyle(
        //           fontFamily: 'Pretendard',
        //           fontWeight: FontWeight.bold,
        //           fontSize: 20,
        //         ),
        //       ),
        //       Text(
        //         // 'data',
        //         // '${context.watch<ExerciseData>().time ~/ 60}',
        //         // '${_exerciseHocurs}시간 ${_exerciseMinutes}분',
        //         // 'ㅏ하ㅏ하하하하',
        //         // '${todayExerciseTimes}시간 ${todayExerciseTimes}분',
        //         '${todayExerciseHours}시간 ${todayExerciseMinutes}분',
        //         // '$docSnapshots[i]['time']',
        //         style: TextStyle(
        //             fontFamily: 'Pretendard', fontWeight: FontWeight.normal),
        //       ),
        //     ],
        //   ),
        // );
      },
    );
  }

  FutureBuilder getCalFutureBuilder() {
    return FutureBuilder(
      future: getCalData(_selectedDay),
      builder: (context, snapshot) {
        final int d = snapshot.data ?? 0;
        // int todayExerciseMinutes = d % 60;
        // // print(todayExerciseMinutes);
        // // int _exerciseMinutes = context.watch<ExerciseData>().time;
        // int todayExerciseHours = d ~/ 60;

        // return Container(
        //   width: MediaQuery.of(context).size.width * 0.4,
        //   height: 100,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10),
        //     color: Color(0xffeeeeee),
        //   ),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: <Widget>[
        //       Text(
        //         '운동 시간',
        //         style: TextStyle(
        //           fontFamily: 'Pretendard',
        //           fontWeight: FontWeight.bold,
        //           fontSize: 20,
        //         ),
        //       ),
        //       Text(
        //         // 'data',
        //         // '${context.watch<ExerciseData>().time ~/ 60}',
        //         // '${_exerciseHocurs}시간 ${_exerciseMinutes}분',
        //         // 'ㅏ하ㅏ하하하하',
        //         // '${todayExerciseTimes}시간 ${todayExerciseTimes}분',
        //         '${todayExerciseHours}시간 ${todayExerciseMinutes}분',
        //         // '$docSnapshots[i]['time']',
        //         style: TextStyle(
        //             fontFamily: 'Pretendard', fontWeight: FontWeight.normal),
        //       ),
        //     ],
        //   ),
        // );
        if (_selectedDay == DateTime.now()) {
          // if (_selectedDay == DateTime.now().toUtc().add(Duration(hours: -9))) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffeeeeee),
            ),
            // child: (_selectedDay == DateTime.now())
            //     ? TodayDiet()
            //     : FutureDiet(),
            // child: ConditionalDiet(Whatday(_selectedDay)),
            // child: Whatday(_selectedDay),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '섭취 칼로리',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  // 'data',
                  '${context.watch<DietData>().calories}',
                  // '${d.round()} 칼로리',
                  style: TextStyle(
                      fontFamily: 'Pretendard', fontWeight: FontWeight.normal),
                ),
              ],
            ),
            //_sectedDay! 오류나서 _selectedDay로 수정
          );
        } else {
          return Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffeeeeee),
            ),
            // child: (_selectedDay == DateTime.now())
            //     ? TodayDiet()
            //     : FutureDiet(),
            // child: ConditionalDiet(Whatday(_selectedDay)),
            // child: Whatday(_selectedDay),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '섭취 칼로리',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  // 'data',
                  // '${context.watch<ExerciseData>().time}',
                  '${d.round()} 칼로리',
                  style: TextStyle(
                      fontFamily: 'Pretendard', fontWeight: FontWeight.normal),
                ),
              ],
            ),
            //_sectedDay! 오류나서 _selectedDay로 수정
          );
        }
      },
    );
  }

  FutureBuilder getExerciseFutureBuilder() {
    return FutureBuilder(
      future: getExerciseData(_selectedDay),
      builder: (context, snapshot) {
        final int d = snapshot.data ?? 0;
        int todayExerciseMinutes = d % 60;
        // print(todayExerciseMinutes);
        // int _exerciseMinutes = context.watch<ExerciseData>().time;
        int todayExerciseHours = d ~/ 60;

        return Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xffeeeeee),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '운동 시간',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                // 'data',
                // '${context.watch<ExerciseData>().time ~/ 60}',
                // '${_exerciseHocurs}시간 ${_exerciseMinutes}분',
                // 'ㅏ하ㅏ하하하하',
                // '${todayExerciseTimes}시간 ${todayExerciseTimes}분',
                '${todayExerciseHours}시간 ${todayExerciseMinutes}분',
                // '$docSnapshots[i]['time']',
                style: TextStyle(
                    fontFamily: 'Pretendard', fontWeight: FontWeight.normal),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<int> getExerciseData(DateTime date) async {
    // DateTime _now = date;
    // DateTime _now = date.toUtc();
    DateTime _now = date.toUtc().add(Duration(hours: -9));
    // print(_now);

    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
    DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

    QuerySnapshot querySnapshot = await _collectionExercise
        .where('date', isGreaterThanOrEqualTo: _start)
        .where('date', isLessThanOrEqualTo: _end)
        .orderBy('date')
        .get();
    var docSnapshots = querySnapshot.docs;

    int return_int = 0;
    int timess;

    for (int i = 0; i < docSnapshots.length; i++) {
      // print(docSnapshots[i].data());
      // int timess = docSnapshots[i]['time'];
      // print(docSnapshots[i]['time']);
      // print(timess);
      // todayExerciseTimes += timess;
      timess = docSnapshots[i]['time'];
      // todayExerciseTimes += timess;
      // print(todayExerciseTimes);
      return_int += timess;
    }

    return return_int;
  }

  Future<int> getCalData(DateTime date) async {
    // DateTime _now = date;
    DateTime _now = date.toUtc().add(Duration(hours: -9));
    // print(_now);
    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
    DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

    QuerySnapshot querySnapshot = await _collectionDiet
        .where('date', isGreaterThanOrEqualTo: _start)
        .where('date', isLessThanOrEqualTo: _end)
        .orderBy('date')
        .get();
    var docSnapshots = querySnapshot.docs;

    int return_int = 0;
    int cals;

    for (int i = 0; i < docSnapshots.length; i++) {
      // print(docSnapshots[i].data());
      // int timess = docSnapshots[i]['time'];
      // print(docSnapshots[i]['time']);
      // print(timess);
      // todayExerciseTimes += timess;
      cals = docSnapshots[i]['cal'];
      // todayExerciseTimes += timess;
      // print(todayExerciseTimes);
      return_int += cals;
    }

    return return_int;
  }

  Future<int> getStepsData(DateTime date) async {
    // DateTime _now = date;

    DateTime _now = date.toUtc().add(Duration(hours: -9));
    // print(_now);
    // print(DateTime.now());

    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
    DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

    QuerySnapshot querySnapshot = await _collectionSteps
        .where('date', isGreaterThanOrEqualTo: _start)
        .where('date', isLessThanOrEqualTo: _end)
        .orderBy('date')
        .get();
    var docSnapshots = querySnapshot.docs;

    int return_int = 0;
    int stepss;

    for (int i = 0; i < docSnapshots.length; i++) {
      // print(docSnapshots[i].data());
      // int timess = docSnapshots[i]['time'];
      // print(docSnapshots[i]['time']);
      // print(timess);
      // todayExerciseTimes += timess;
      stepss = docSnapshots[i]['step'];
      // todayExerciseTimes += timess;
      // print(todayExerciseTimes);
      return_int += stepss;
    }

    return return_int;
  }

  // exercisefromdb() async {
  //   // DateTime _now = DateTime.now();
  //   // DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
  //   // DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

  //   // QuerySnapshot querySnapshot = await _collectionRef
  //   //     .where('date', isGreaterThanOrEqualTo: _start)
  //   //     .where('date', isLessThanOrEqualTo: _end)
  //   //     .orderBy('date')
  //   //     .get();
  //   // var docSnapshots = querySnapshot.docs;

  //   // int todayExerciseTimes = 0;

  //   // for (int i = 0; i < docSnapshots.length; i++) {
  //   //   // print(docSnapshots[i].data());
  //   //   int timess = docSnapshots[i]['time'];
  //   //   // print(docSnapshots[i]['time']);
  //   //   // print(timess);
  //   //   todayExerciseTimes += timess;
  //   //   // print(todayExerciseTimes);
  //   // }

  //   // final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   // final allData = querySnapshot.docs.map((doc) => doc.data());
  //   // print(allData);
  //   // return allData;
  //   DateTime _now = DateTime.now();
  //   DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
  //   DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

  //   QuerySnapshot querySnapshot = await _collectionRef
  //       .where('date', isGreaterThanOrEqualTo: _start)
  //       .where('date', isLessThanOrEqualTo: _end)
  //       .orderBy('date')
  //       .get();
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   // print(allData.elementAt(1));
  //   // print(allData);

  //   return Container(
  //     width: MediaQuery.of(context).size.width * 0.4,
  //     height: 100,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10),
  //       color: Color(0xffeeeeee),
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: <Widget>[
  //         Text(
  //           '운동 시간',
  //           style: TextStyle(
  //             fontFamily: 'Pretendard',
  //             fontWeight: FontWeight.bold,
  //             fontSize: 20,
  //           ),
  //         ),
  //         Text(
  //           // 'data',
  //           // '${context.watch<ExerciseData>().time}',
  //           // '${_exerciseHocurs}시간 ${_exerciseMinutes}분',
  //           'ㅏ하ㅏ하하하하',
  //           style: TextStyle(
  //               fontFamily: 'Pretendard', fontWeight: FontWeight.normal),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Future<Widget> todayExercise() async {
  //   DateTime _now = DateTime.now();
  //   DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
  //   DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

  //   QuerySnapshot querySnapshot = await _collectionRef
  //       .where('date', isGreaterThanOrEqualTo: _start)
  //       .where('date', isLessThanOrEqualTo: _end)
  //       .orderBy('date')
  //       .get();
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   // print(allData.elementAt(1));
  //   // print(allData);

  //   return Container(
  //     width: MediaQuery.of(context).size.width * 0.4,
  //     height: 100,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10),
  //       color: Color(0xffeeeeee),
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: <Widget>[
  //         Text(
  //           '운동 시간',
  //           style: TextStyle(
  //             fontFamily: 'Pretendard',
  //             fontWeight: FontWeight.bold,
  //             fontSize: 20,
  //           ),
  //         ),
  //         Text(
  //           // 'data',
  //           // '${context.watch<ExerciseData>().time}',
  //           // '${_exerciseHocurs}시간 ${_exerciseMinutes}분',
  //           'ㅏ하ㅏ하하하하',
  //           style: TextStyle(
  //               fontFamily: 'Pretendard', fontWeight: FontWeight.normal),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // int Whatday(DateTime selectedDay) {
  //   DateTime now = DateTime.now();
  //   if (selectedDay.day == now.day &&
  //       selectedDay.year == now.year &&
  //       selectedDay.month == now.month) {
  //     // if (selectedDay == now) {
  //     return 1;
  //     // } else if (now.isBefore(selectedDay)) {
  //   } else if (selectedDay.isBefore(now)) {
  //     return 2;
  //     // } else if (now.isAfter(selectedDay)) {
  //   } else if (selectedDay.isAfter(now)) {
  //     return 3;
  //   } else {
  //     return 0;
  //   }
  // }

  Widget? Whatday(DateTime selectedDay) {
    DateTime now = DateTime.now();

    // int diet_type;
    // String diet_food;
    // int diet_score;

    if (selectedDay.day == now.day &&
        selectedDay.year == now.year &&
        selectedDay.month == now.month) {
      // if (selectedDay == now) {
      // return TodayDiet();
      // } else if (now.isBefore(selectedDay)) {
    } else if (selectedDay.isBefore(now)) {
      return PastDiet();
      // } else if (now.isAfter(selectedDay)) {
    } else if (selectedDay.isAfter(now)) {
      return FutureDiet();
    } else {
      return null;
    }
  }

  // Widget? ConditionalDiet(int b) {
  //   if (b == 1) {
  //     return TodayDiet(${diet_type}, $diet_food $diet_score);
  //   } else if (b == 2) {
  //     return PastDiet();
  //   } else if (b == 3) {
  //     return FutureDiet();
  //   } else {
  //     return null;
  //   }
  // }

  // Widget TodayDiet() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: <Widget>[
  //       Text(
  //         '식단',
  //         style: TextStyle(
  //           fontFamily: 'Pretendard',
  //           fontWeight: FontWeight.bold,
  //           fontSize: 20,
  //         ),
  //       ),
  //       Row(
  //         // mainAxisSize: MainAxisSize.min,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           IconButton(
  //             constraints: BoxConstraints(maxWidth: 30),
  //             padding: EdgeInsets.zero,
  //             icon: Icon(Icons.sentiment_satisfied),
  //             color: const Color(0xffbbbbbb),
  //             onPressed: () => _openDialog(_selectedDay, 1),
  //             // onPressed: () => Diet(),
  //           ),
  //           IconButton(
  //             constraints: BoxConstraints(maxHeight: 24),
  //             padding: EdgeInsets.zero,
  //             icon: Icon(Icons.sentiment_satisfied),
  //             color: const Color(0xffbbbbbb),
  //             onPressed: () => _openDialog(_selectedDay, 2),
  //             // onPressed: () => Diet(),
  //           ),
  //           IconButton(
  //             constraints: BoxConstraints(maxHeight: 24),
  //             padding: EdgeInsets.zero,
  //             icon: Icon(Icons.sentiment_satisfied),
  //             color: const Color(0xffbbbbbb),
  //             onPressed: () => _openDialog(_selectedDay, 3),
  //             // onPressed: () => Diet(),
  //           ),
  //           IconButton(
  //             constraints: BoxConstraints(maxHeight: 24),
  //             padding: EdgeInsets.zero,
  //             icon: Icon(Icons.sentiment_satisfied),
  //             color: const Color(0xffbbbbbb),
  //             onPressed: () => _openDialog(_selectedDay, 4),
  //             // // onPressed: () => Diet(),
  //             // onPressed: () => Navigator.push(
  //             //     context, MaterialPageRoute(builder: (context) => Diet())),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget PastDiet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          '과거 식단',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              constraints: BoxConstraints(maxWidth: 30),
              padding: EdgeInsets.zero,
              icon: Icon(Icons.sentiment_satisfied),
              color: const Color(0xffbbbbbb),
              onPressed: () => _openDialog(_selectedDay, 1),
              // onPressed: () {},
            ),
            IconButton(
              constraints: BoxConstraints(maxHeight: 24),
              padding: EdgeInsets.zero,
              icon: Icon(Icons.sentiment_satisfied),
              color: const Color(0xffbbbbbb),
              onPressed: () => _openDialog(_selectedDay, 2),
              // onPressed: () {},
            ),
            IconButton(
              constraints: BoxConstraints(maxHeight: 24),
              padding: EdgeInsets.zero,
              icon: Icon(Icons.sentiment_satisfied),
              color: const Color(0xffbbbbbb),
              onPressed: () => _openDialog(_selectedDay, 3),
              // onPressed: () {},
            ),
            IconButton(
              constraints: BoxConstraints(maxHeight: 24),
              padding: EdgeInsets.zero,
              icon: Icon(Icons.sentiment_satisfied),
              color: const Color(0xffbbbbbb),
              onPressed: () => _openDialog(_selectedDay, 4),
              // onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget FutureDiet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          '이후 식단',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              constraints: BoxConstraints(maxWidth: 30),
              padding: EdgeInsets.zero,
              icon: Icon(Icons.sentiment_satisfied),
              color: const Color(0xffbbbbbb),
              onPressed: () {},
            ),
            IconButton(
              constraints: BoxConstraints(maxHeight: 24),
              padding: EdgeInsets.zero,
              icon: Icon(Icons.sentiment_satisfied),
              color: const Color(0xffbbbbbb),
              onPressed: () {},
            ),
            IconButton(
              constraints: BoxConstraints(maxHeight: 24),
              padding: EdgeInsets.zero,
              icon: Icon(Icons.sentiment_satisfied),
              color: const Color(0xffbbbbbb),
              onPressed: () {},
            ),
            IconButton(
              constraints: BoxConstraints(maxHeight: 24),
              padding: EdgeInsets.zero,
              icon: Icon(Icons.sentiment_satisfied),
              color: const Color(0xffbbbbbb),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  int value = 0;
  var _selectedValue = null;
  String inputs = '';

  Widget CustomRadio(String text, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          value = index;
        });
      },
      child: Text(text),
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(70, 50),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        primary:
            (value == index) ? Color.fromARGB(255, 61, 67, 114) : Colors.grey,
        elevation: 0.0,
        textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pretendard'),
      ),
    );
  }

  Widget _icon(int index, IconData icon) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: InkResponse(
        child: Column(
          children: [
            Icon(
              icon,
              color: _selectedValue == index
                  ? Color.fromARGB(255, 61, 67, 114)
                  : Colors.grey,
              size: 60.0,
            ),
          ],
        ),
        onTap: () => setState(
          () {
            _selectedValue = index;
          },
        ),
      ),
    );
  }

  void _openDialog(DateTime date, int type) async {
    _selectedValue =
        (await Navigator.of(context).push(new MaterialPageRoute<String>(
            builder: (BuildContext context) {
              return new Scaffold(
                appBar: new AppBar(
                  title: const Text('식단 추가'),
                  actions: [
                    new ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop("hai");
                        },
                        child: Text(
                          '추가',
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
                  // child: Column(
                  //   children: [
                  //     ElevatedButton(
                  //       onPressed: () {
                  //         Navigator.of(context).pop();
                  //       },
                  //       child: Text(
                  //         'Full Screen',
                  //         style: TextStyle(color: Colors.white),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomRadio("아침", 1),
                                SizedBox(width: 10),
                                CustomRadio("점심", 2),
                                SizedBox(width: 10),
                                CustomRadio("저녁", 3),
                                SizedBox(width: 10),
                                CustomRadio("간식", 4),
                              ]),
                        ),
                        Center(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: TextField(
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Pretendard'),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: '식단을 입력해주세요.',
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 61, 67, 114)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 61, 67, 114)),
                                    ),
                                  ),
                                  onChanged: (String str) {
                                    setState(() => inputs = str);
                                  },
                                ),
                                padding: EdgeInsets.only(top: 30, bottom: 20),
                                width: 200,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _icon(0, Icons.sentiment_very_satisfied),
                                  SizedBox(width: 5),
                                  _icon(
                                    1,
                                    Icons.sentiment_satisfied,
                                  ),
                                  SizedBox(width: 5),
                                  _icon(
                                    2,
                                    Icons.sentiment_very_dissatisfied,
                                  ),
                                ],
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            fullscreenDialog: true)))!;
    if (_selectedValue != null)
      setState(() {
        _selectedValue = _selectedValue;
      });
  }

  void ExerciseDialog() {
    final List<String> _valueList = [
      '운동 선택',
      '스트레칭',
      '헬스',
      '런닝',
      '필라테스',
      '걷기',
      '그외'
    ];
    String _selectedValue = '운동 선택';

    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text(
                  '식단 추가',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '분류',
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  '확인',
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  '취소',
                ),
              ),
            ],
          );
        });
  }
}

// class Whatday extends StatelessWidget {
//   DateTime selectedDay;
//   DateTime now = DateTime.now();

//   int diet_type;
//   String diet_food;
//   int diet_score;

//   Whatday({
//     Key? key,
//     required this.selectedDay,
//     required this.diet_type,
//     required this.diet_food,
//     required diet_score,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (selectedDay.day == DateTime.now().day &&
//         selectedDay.year == now.year &&
//         selectedDay.month == now.month) {
//       // if (selectedDay == now) {
//       return TodayDiet();
//       // } else if (now.isBefore(selectedDay)) {
//     } else if (selectedDay.isBefore(DateTime.now())) {
//       return PastDiet();
//       // } else if (now.isAfter(selectedDay)) {
//     } else if (selectedDay.isAfter(DateTime.now())) {
//       return FutureDiet();
//     } else {
//       return null;
//     }
//   }
// }

// class TodayDiet extends StatelessWidget {
//   int diet_type;
//   String diet_food;
//   int diet_score;

//   TodayDiet(
//       {Key? key,
//       required this.diet_type,
//       required this.diet_food,
//       required this.diet_score})
//       : super(key: key);

//   Widget dietIcon(int type) {
//     return IconButton(
//       constraints: BoxConstraints(maxWidth: 30),
//       padding: EdgeInsets.zero,
//       icon: Icon(Icons.sentiment_satisfied),
//       color: const Color(0xffbbbbbb),
//       // onPressed: () => _openDialog(_selectedDay, 1),
//       onPressed: () => Diet(db: ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         Text(
//           '식단',
//           style: TextStyle(
//             fontFamily: 'Pretendard',
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         Row(
//           // mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               constraints: BoxConstraints(maxWidth: 30),
//               padding: EdgeInsets.zero,
//               icon: Icon(Icons.sentiment_satisfied),
//               color: const Color(0xffbbbbbb),
//               // onPressed: () => _openDialog(_selectedDay, 1),
//               onPressed: () => Diet(),
//             ),
//             IconButton(
//               constraints: BoxConstraints(maxHeight: 24),
//               padding: EdgeInsets.zero,
//               icon: Icon(Icons.sentiment_satisfied),
//               color: const Color(0xffbbbbbb),
//               // onPressed: () => _openDialog(_selectedDay, 2),
//               onPressed: () => Diet(),
//             ),
//             IconButton(
//               constraints: BoxConstraints(maxHeight: 24),
//               padding: EdgeInsets.zero,
//               icon: Icon(Icons.sentiment_satisfied),
//               color: const Color(0xffbbbbbb),
//               // onPressed: () => _openDialog(_selectedDay, 3),
//               onPressed: () => Diet(),
//             ),
//             IconButton(
//               constraints: BoxConstraints(maxHeight: 24),
//               padding: EdgeInsets.zero,
//               icon: Icon(Icons.sentiment_satisfied),
//               color: const Color(0xffbbbbbb),
//               // onPressed: () => _openDialog(_selectedDay, 4),
//               onPressed: () => Diet(),
//               // onPressed: () => Navigator.push(
//               //     context, MaterialPageRoute(builder: (context) => Diet())),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
