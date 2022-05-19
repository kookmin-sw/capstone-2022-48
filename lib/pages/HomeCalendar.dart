import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';

class HomeCalendar extends StatefulWidget {
  const HomeCalendar({Key? key}) : super(key: key);

  @override
  _HomeCalendarState createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  // calendar
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  CalendarFormat _calendarFormat = CalendarFormat.month;

  // pedometer
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?';
  String _steps = '?';

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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              width: size.width * 0.9,
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
                    color: Color(0xffEEEEEE),
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
                        'data',
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
                    color: Color(0xffEEEEEE),
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.sentiment_satisfied,
                              color: Color(0xffbbbbbb)),
                          Icon(Icons.sentiment_satisfied,
                              color: Color(0xffbbbbbb)),
                          Icon(Icons.sentiment_satisfied,
                              color: Color(0xffbbbbbb)),
                          Icon(Icons.sentiment_satisfied,
                              color: Color(0xffbbbbbb)),
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
    );
  }
}
