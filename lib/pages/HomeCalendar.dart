import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';
import 'package:capstone_2022_48/model/DataModel.dart';

class HomeCalendar extends StatefulWidget {
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

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    int _exerciseMinutes = context.watch<ExerciseData>().time ~/ 60;
    int _exerciseHours =
        (_exerciseMinutes ~/ 60 == 0) ? 0 : _exerciseMinutes ~/ 60;

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '오늘은 ' + _steps + ' 걸음',
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold),
              ),
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
                  Container(
                    width: size.width * 0.4,
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
                          // '${context.watch<ExerciseData>().time}',
                          '${_exerciseHours}시간 ${_exerciseMinutes}분',
                          style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: size.width * 0.4,
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
                          '식단',
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
                              onPressed: () => ExerciseDialog(),
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
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
