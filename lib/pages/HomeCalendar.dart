import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';
import 'package:capstone_2022_48/model/DataModel.dart';
import 'package:capstone_2022_48/pages/Diet.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:capstone_2022_48/navigator/sidemenu.dart';

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class HomeCalendar extends StatefulWidget {
  // const HomeCalendar({Key? key}) : super(key: key);
  // static final route = 'homecalendar';

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

  double _suggestedExerciseTime = 120; // 수정해야한다!!!!!!!!!
  double _suggestedCalories = 1600; //이하동문
  double _suggestedSugar = 50; //이하동문

  get suggestedExerciseTime => _suggestedExerciseTime;
  get suggestedCalories => _suggestedCalories;
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
    // double _cal = context.watch<DietData>().calories;

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        (_selectedDay == DateTime.now())
                            ? Text(
                                '오늘은 ' + _steps + ' 걸음',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.bold),
                              )
                            : getStepsFutureBuilder(),
                        // Text(
                        //   '오늘은 ' + _steps + ' 걸음',
                        //   style: TextStyle(
                        //       fontSize: 30,
                        //       fontFamily: 'Pretendard',
                        //       fontWeight: FontWeight.bold),
                        // ),
                        // getStepsFutureBuilder(),
                        SizedBox(
                          height: 15,
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
                              leftChevronIcon:
                                  Icon(Icons.arrow_back_ios_rounded),
                              rightChevronIcon:
                                  Icon(Icons.arrow_forward_ios_rounded),
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
                                  color: Color(0xffc1c1c1),
                                  shape: BoxShape.circle),
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
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            getExerciseFutureBuilder(),
                            getCalFutureBuilder(),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            getTandanziFutureBuilder(),
                            getSugarFutureBuilder(),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
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

  // Widget _buildcard() {
  // List<Widget> _buildcard() {
  //   List<Widget> list =
  //   Card(
  //   child: Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Expanded(
  //           child: getExerciseFutureBuilder(),
  //         ),
  //         Expanded(
  //           child: getCalFutureBuilder(),
  //         ),
  //         Expanded(
  //           child: getExerciseFutureBuilder(),
  //         ),
  //         Expanded(
  //           child: getCalFutureBuilder(),
  //         ),
  //       ],
  //     ),
  //   ),
  // );
  // return Card(
  //   Padding(
  //     padding: EdgeInsets.all(10.0),
  //     child: Column(
  //       children: [
  //         Expanded(
  //           child: getExerciseFutureBuilder(),
  //         ),
  //       ],
  //     ),
  //   ),
  // );
  // }

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
      },
    );
  }

  FutureBuilder getCalFutureBuilder() {
    return FutureBuilder(
      future: getCalData(_selectedDay),
      builder: (context, snapshot) {
        num d = snapshot.data ?? 0;
        // if (_selectedDay == DateTime.now()) {
        //   // if (_selectedDay == DateTime.now().toUtc().add(Duration(hours: -9))) {
        //   return Container(
        //     width: MediaQuery.of(context).size.width * 0.4,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(10),
        //       color: Color(0xffeeeeee),
        //     ),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: <Widget>[
        //         Text(
        //           '오늘의 섭취 칼로리',
        //           style: TextStyle(
        //             fontFamily: 'Pretendard',
        //             fontWeight: FontWeight.bold,
        //             fontSize: 20,
        //           ),
        //         ),
        //         Text(
        //           // 'data',
        //           '${context.watch<DietData>().calories}',
        //           // '${d.round()} 칼로리',
        //           style: TextStyle(
        //               fontFamily: 'Pretendard', fontWeight: FontWeight.normal),
        //         ),
        //       ],
        //     ),
        //   );
        // } else {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xffeeeeee),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                SizedBox(
                  height: 10,
                ),
                SfLinearGauge(
                  maximum: 3000,
                  ranges: [
                    LinearGaugeRange(
                      startValue: 0,
                      endValue: suggestedCalories,
                      color: Color(0xffFFCD00),
                    ),
                  ],
                  barPointers: [
                    LinearBarPointer(
                      value: d.toDouble(),
                      thickness: 5,
                      color: Color(0xfff05650),
                      position: LinearElementPosition.outside,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  // 'data',
                  // '${context.watch<ExerciseData>().time}',
                  '${d.round()} 칼로리',
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.normal,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        );
        // }
      },
    );
  }

  FutureBuilder getTandanziFutureBuilder() {
    // final Stream<QuerySnapshot> _usersStream = _collectionDiet.snapshots();
    // DateTime date = _selectedDay;

    late List<ChartData> data;
    late TooltipBehavior _tooltip;

    _tooltip = TooltipBehavior(enable: true);

    return FutureBuilder(
      future: getTandanzidata(_selectedDay),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          double d1 = 33;
          double d2 = 33;
          double d3 = 34;

          return Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffeeeeee),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '탄단지 비율',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 200,
                    child: SfLinearGauge(
                      minorTicksPerInterval: 4,
                      useRangeColorForAxis: true,
                      animateAxis: true,
                      axisTrackStyle: LinearAxisTrackStyle(thickness: 1),
                      ranges: <LinearGaugeRange>[
                        LinearGaugeRange(
                            startValue: 0,
                            endValue: d1,
                            position: LinearElementPosition.outside,
                            color: Color(0xffF45656)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    '기다려주세요!',
                    // '${todayExerciseHours}시간 ${todayExerciseMinutes}분',
                    // '$docSnapshots[i]['time']',
                    style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        } else {
          // num d1 = (snapshot.data[0] == 0) ? 33 : snapshot.data[0];
          // num d2 = (snapshot.data[1] == 0) ? 33 : snapshot.data[1];
          // num d3 = (snapshot.data[2] == 0) ? 34 : snapshot.data[2];
          num d1 = snapshot.data[0] ?? 33;
          num d2 = snapshot.data[1] ?? 33;
          num d3 = snapshot.data[2] ?? 33;

          data = [
            ChartData('탄수화물', d1.toDouble(), Color(0xff8CAAD8)),
            ChartData('단백질', d2.toDouble(), Color(0xff6990CC)),
            ChartData('지방', d3.toDouble(), Color(0xff4675C0)),
          ];

          // return Text('${d1} 과 ${d2} 과 ${d3}');
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffeeeeee),
            ),
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '탄단지 비율',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // SfLinearGauge(
                  //   minorTicksPerInterval: 4,
                  //   useRangeColorForAxis: true,
                  //   animateAxis: true,
                  //   axisTrackStyle: LinearAxisTrackStyle(thickness: 1),
                  //   ranges: <LinearGaugeRange>[
                  //     LinearGaugeRange(
                  //         startValue: 0,
                  //         endValue: d1.toDouble(),
                  //         position: LinearElementPosition.outside,
                  //         color: Color(0xffF45656)),
                  //     LinearGaugeRange(
                  //         startValue: d1.toDouble(),
                  //         endValue: d2.toDouble(),
                  //         position: LinearElementPosition.outside,
                  //         color: Color(0xffFFC93E)),
                  //     LinearGaugeRange(
                  //         startValue: d2.toDouble(),
                  //         endValue: 100,
                  //         position: LinearElementPosition.outside,
                  //         color: Color(0xff0DC9AB)),
                  //   ],
                  // ),
                  // SfCartesianChart(
                  //     primaryXAxis: CategoryAxis(),
                  //     primaryYAxis:
                  //         NumericAxis(minimum: 0, maximum: 100, interval: 10),
                  //     tooltipBehavior: _tooltip,
                  //     series: <ChartSeries<_ChartData, String>>[
                  //       ColumnSeries<_ChartData, String>(
                  //         dataSource: data,
                  //         xValueMapper: (_ChartData data, _) => data.x,
                  //         yValueMapper: (_ChartData data, _) => data.y,
                  //         name: '탄단지',
                  //         color: Color(0xff19335A),
                  //       ),
                  //     ]),
                  Container(
                    height: 140,
                    child: SfCircularChart(
                        // legend: Legend(
                        //     isVisible: true,
                        //     position: LegendPosition.bottom,
                        //     overflowMode: LegendItemOverflowMode.wrap),
                        series: <CircularSeries>[
                          // Render pie chart
                          PieSeries<ChartData, String>(
                            dataSource: data,
                            pointColorMapper: (ChartData data, _) => data.color,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            radius: '110%',
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    (d1 == 0 && d2 == 0 && d3 == 0)
                        ? '데이터를 입력해주세요!'
                        : '탄수화물은 ${d1}%\n단백질은 ${d2}%\n지방은 ${d3}%',
                    // '${todayExerciseHours}시간 ${todayExerciseMinutes}분',
                    // '$docSnapshots[i]['time']',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  FutureBuilder getSugarFutureBuilder() {
    return FutureBuilder(
      future: getSugarData(_selectedDay),
      builder: (context, snapshot) {
        final double d = snapshot.data ?? 0;

        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xffeeeeee),
          ),
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '섭취한 당류',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 140,
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                          showLabels: false,
                          showAxisLine: false,
                          showTicks: false,
                          minimum: 0,
                          maximum: 99,
                          ranges: <GaugeRange>[
                            GaugeRange(
                                startValue: 0,
                                endValue: 50,
                                color: Color(0xFFf05650),
                                label: '위험!',
                                sizeUnit: GaugeSizeUnit.factor,
                                labelStyle: GaugeTextStyle(
                                    fontSize: 16, color: Colors.white),
                                startWidth: 0.65,
                                endWidth: 0.65),
                            GaugeRange(
                              startValue: 50,
                              endValue: 100,
                              color: Color(0xFF4675C0),
                              label: '양호',
                              labelStyle: GaugeTextStyle(fontSize: 16),
                              sizeUnit: GaugeSizeUnit.factor,
                              startWidth: 0.65,
                              endWidth: 0.65,
                            ),
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(
                              needleStartWidth: 1,
                              needleEndWidth: 3,
                              value: (d > _suggestedSugar) ? 25 : 75,
                            ),
                          ])
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  // '${todayExerciseHours}시간 ${todayExerciseMinutes}분',
                  '${d}g',
                  // '$docSnapshots[i]['time']',
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.normal,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        );
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
          padding: EdgeInsets.symmetric(vertical: 20),
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xffeeeeee),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
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
                SizedBox(
                  height: 10,
                ),
                SfLinearGauge(
                  interval: 30,
                  maximum: 180,
                  barPointers: [
                    LinearBarPointer(
                      value: d.toDouble(),
                      thickness: 4,
                      color: Color(0xfff05650),
                      position: LinearElementPosition.outside,
                    ),
                  ],
                  markerPointers: [
                    LinearWidgetPointer(
                      value: suggestedExerciseTime,
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: new BoxDecoration(
                          color: Color(0xffFFCD00),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            // '${_suggestedExerciseTime.round()}',
                            '🎯',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  '${todayExerciseHours}시간 ${todayExerciseMinutes}분',
                  // '$docSnapshots[i]['time']',
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.normal,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<int> getExerciseData(DateTime date) async {
    // DateTime _now = date;
    // DateTime _now = date.toUtc();
    DateTime _now = date;
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

  Future<num> getCalData(DateTime date) async {
    // DateTime _now = date;
    DateTime _now = date;
    // print(_now);
    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
    DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

    QuerySnapshot querySnapshot = await _collectionDiet
        .where('date', isGreaterThanOrEqualTo: _start)
        .where('date', isLessThanOrEqualTo: _end)
        .orderBy('date')
        .get();
    var docSnapshots = querySnapshot.docs;

    num return_int = 0;
    num cals;

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

  Future<List> getTandanzidata(DateTime date) async {
    // DateTime _now = date;
    DateTime _now = date;
    // print(_now);
    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
    DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

    QuerySnapshot querySnapshot = await _collectionDiet
        .where('date', isGreaterThanOrEqualTo: _start)
        .where('date', isLessThanOrEqualTo: _end)
        .orderBy('date')
        .get();
    var docSnapshots = querySnapshot.docs;

    double tans = 0;
    double dans = 0;
    double zis = 0;

    // int tan;
    // int dan;
    // int zi;
    num tan;
    num dan;
    num zi;

    for (int i = 0; i < docSnapshots.length; i++) {
      tan = docSnapshots[i]['tan'];
      dan = docSnapshots[i]['dan'];
      zi = docSnapshots[i]['zi'];
      tans += tan;
      dans += dan;
      zis += zi;
    }

    num t;
    num d;
    num z;

    num sum = tans + dans + zis;
    if (sum == 0) {
      t = 0;
      d = 0;
      z = 0;
    } else {
      // t = (tans * 100 ~/ sum) as double;
      t = tans * 100 ~/ sum;
      d = dans * 100 ~/ sum;
      z = zis * 100 ~/ sum;
    }

    // var list = [t.round(), d.round(), z.round()];
    var list = [t, d, z];
    // var list = [tans, dans, zis];

    return list;
  }

  Future<double> getTanData(DateTime date) async {
    // DateTime _now = date;
    DateTime _now = date;
    // print(_now);
    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
    DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

    QuerySnapshot querySnapshot = await _collectionDiet
        .where('date', isGreaterThanOrEqualTo: _start)
        .where('date', isLessThanOrEqualTo: _end)
        .orderBy('date')
        .get();
    var docSnapshots = querySnapshot.docs;

    double returnValue = 0;
    double value;

    for (int i = 0; i < docSnapshots.length; i++) {
      value = docSnapshots[i]['tan'];
      returnValue += value;
    }

    return returnValue;
  }

  Future<double> getDanData(DateTime date) async {
    // DateTime _now = date;
    DateTime _now = date;
    // print(_now);
    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
    DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

    QuerySnapshot querySnapshot = await _collectionDiet
        .where('date', isGreaterThanOrEqualTo: _start)
        .where('date', isLessThanOrEqualTo: _end)
        .orderBy('date')
        .get();
    var docSnapshots = querySnapshot.docs;

    double returnValue = 0;
    double value;

    for (int i = 0; i < docSnapshots.length; i++) {
      // print(docSnapshots[i].data());
      // int timess = docSnapshots[i]['time'];
      // print(docSnapshots[i]['time']);
      // print(timess);
      // todayExerciseTimes += timess;
      value = docSnapshots[i]['dan'];
      // todayExerciseTimes += timess;
      // print(todayExerciseTimes);
      returnValue += value;
    }

    return returnValue;
  }

  Future<double> getZiData(DateTime date) async {
    // DateTime _now = date;
    DateTime _now = date;
    // print(_now);
    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
    DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

    QuerySnapshot querySnapshot = await _collectionDiet
        .where('date', isGreaterThanOrEqualTo: _start)
        .where('date', isLessThanOrEqualTo: _end)
        .orderBy('date')
        .get();
    var docSnapshots = querySnapshot.docs;

    double returnValue = 0;
    double value;

    for (int i = 0; i < docSnapshots.length; i++) {
      // print(docSnapshots[i].data());
      // int timess = docSnapshots[i]['time'];
      // print(docSnapshots[i]['time']);
      // print(timess);
      // todayExerciseTimes += timess;
      value = docSnapshots[i]['zi'];
      // todayExerciseTimes += timess;
      // print(todayExerciseTimes);
      returnValue += value;
    }

    return returnValue;
  }

  Future<double> getSugarData(DateTime date) async {
    // DateTime _now = date;
    DateTime _now = date;
    // print(_now);
    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
    DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

    QuerySnapshot querySnapshot = await _collectionDiet
        .where('date', isGreaterThanOrEqualTo: _start)
        .where('date', isLessThanOrEqualTo: _end)
        .orderBy('date')
        .get();
    var docSnapshots = querySnapshot.docs;

    double returnValue = 0;
    num value;

    for (int i = 0; i < docSnapshots.length; i++) {
      // print(docSnapshots[i].data());
      // int timess = docSnapshots[i]['time'];
      // print(docSnapshots[i]['time']);
      // print(timess);
      // todayExerciseTimes += timess;
      value = docSnapshots[i]['sugar'];
      // todayExerciseTimes += timess;
      // print(todayExerciseTimes);
      returnValue += value;
    }

    return returnValue.toDouble();
  }

  Future<num> getStepsData(DateTime date) async {
    // DateTime _now = date;

    DateTime _now = date;
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

    num return_int = 0;
    num stepss;

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
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
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
