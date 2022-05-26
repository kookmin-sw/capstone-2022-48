import 'dart:developer';

import 'package:capstone_2022_48/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
// import 'package:syncfusion_flutter_gauges/gauges.dart';

class AverStepsScreen extends StatefulWidget {
  const AverStepsScreen({Key? key}) : super(key: key);

  @override
  State<AverStepsScreen> createState() => _AverStepsScreenState();
}

class _AverStepsScreenState extends State<AverStepsScreen> {
  CollectionReference _collectionSteps =
      FirebaseFirestore.instance.collection('StepDataCollection');

  bool isWeek = true;
  bool isMonth = false;
  late List<bool> isSelected;

//
  bool isWeekorMonth = true;

  int touchedIndex = -1;

  final Color barBackgroundColor = const Color(0xff72d8bf);

  final Duration animDuration = const Duration(milliseconds: 250);

  int showingTooltip = -1;
  // List<bool> _selections = List.generate(3, (_) => false);

  @override
  void initState() {
    isSelected = [isWeek, isMonth];
    super.initState();
  }

  List<Color> gradientColors = [
    const Color(0xff8CAAD8),
    const Color(0xff4675C0),
  ];

  bool showAvg = false;

  double shapePointerValue = 25;

  Future<List> getSevenDaysData() async {
    // DateTime _now = date;
    // DateTime _now = date.toUtc().add(Duration(hours: -9));
    // DateTime _now = DateTime.now().subtract(Duration(days: 1));
    DateTime _now = DateTime.now();
    // print(_now);
    DateTime _start;
    DateTime _end;

    List<num> list = [0, 0, 0, 0, 0, 0, 0, 0, 0];

    // _now = DateTime.now()
    //     .toUtc()
    //     .subtract(Duration(days: i))
    //     .add(Duration(hours: -9));
    // _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
    // _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

    // QuerySnapshot querySnapshot = await _collectionSteps
    //     .where('date', isGreaterThanOrEqualTo: _start)
    //     .where('date', isLessThanOrEqualTo: _end)
    //     .orderBy('date')
    //     .get();
    // var docSnapshots = querySnapshot.docs;

    for (int i = 1; i < 9; i++) {
      _now = DateTime.now().subtract(Duration(days: i));
      _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
      _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

      QuerySnapshot querySnapshot = await _collectionSteps
          .where('date', isGreaterThanOrEqualTo: _start)
          .where('date', isLessThanOrEqualTo: _end)
          .orderBy('date')
          .get();
      var docSnapshots = querySnapshot.docs;
      if (docSnapshots != null && docSnapshots.length != 0) {
        list[i - 1] = docSnapshots[0]['step'];
        // for (int i = 0; i < docSnapshots.length; i++) {
        //   list[i] = docSnapshots[0]['step'];
        // }
      }
    }

    return list;
  }

  Future<List> getMonthData() async {
    // DateTime _now = date;
    // DateTime _now = date.toUtc().add(Duration(hours: -9));
    // DateTime _now = DateTime.now().subtract(Duration(days: 1));
    DateTime _now = DateTime.now();
    // .subtract(Duration(days: 1));
    // DateTime _start = _now.subtract(Duration(days: 1));
    // DateTime _end = _now.subtract(Duration(days: 37));
    DateTime _start;
    DateTime _end;
    // print(_now);
    // DateTime _start;

    // List<num> list = [0, 0, 0, 0, 0, 0, 0];
    List<num> list = List.filled(40, 0);

    // for (int i = 0; i < 7; i++) {
    //   // _now = DateTime.now().toUTC().subtract(Duration(days: i));
    //   var day = (i & 7) + 1;
    //   // _start = _now.subtract(Duration(days: 1 + (i * 7)));
    //   _start = _now.subtract(Duration(days: day));
    //   _end = _start.subtract(Duration(days: 6));

    //   QuerySnapshot querySnapshot = await _collectionSteps
    //       .where('date', isGreaterThanOrEqualTo: _start)
    //       .where('date', isLessThanOrEqualTo: _end)
    //       .orderBy('date')
    //       .get();
    //   var docSnapshots = querySnapshot.docs;
    //   if (docSnapshots != null && docSnapshots.length != 0) {
    //     // list[i - 1] = docSnapshots[0]['step'];
    //     // for (int j = 0; j < 7; j++) {
    //     // for (int j = 0; j < docSnapshots.length; j++) {
    //     for (int j = 0; j < 7; j++) {
    //       list[i] = docSnapshots[j]['step'];
    //     }
    //   }
    // }

    // for (int i = 0; i < docSnapshots.length; i++) {
    //   tan = docSnapshots[0]['step'];
    // }

    // var list = [t.round(), d.round(), z.round()];
    // var list = [mon, tues, weds, thurs, fri, sat, sun];
    // var list = [tans, dans, zis];

    for (int i = 1; i < 40; i++) {
      _now = DateTime.now().subtract(Duration(days: i));
      _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
      _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

      QuerySnapshot querySnapshot = await _collectionSteps
          .where('date', isGreaterThanOrEqualTo: _start)
          .where('date', isLessThanOrEqualTo: _end)
          .orderBy('date')
          .get();
      var docSnapshots = querySnapshot.docs;
      if (docSnapshots != null && docSnapshots.length != 0) {
        list[i - 1] = docSnapshots[0]['step'];
        // for (int i = 0; i < docSnapshots.length; i++) {
        //   list[i] = docSnapshots[0]['step'];
        // }
      }
    }

    // QuerySnapshot querySnapshot = await _collectionSteps
    //     .where('date', isGreaterThanOrEqualTo: _end)
    //     .where('date', isLessThanOrEqualTo: _start)
    //     .orderBy('date')
    //     .get();
    // var docSnapshots = querySnapshot.docs;
    // if (docSnapshots != null && docSnapshots.length != 0) {
    //   // list[i - 1] = docSnapshots[0]['step'];
    //   // for (int j = 0; j < 7; j++) {
    //   // for (int j = 0; j < docSnapshots.length; j++) {
    //   for (int j = 0; j < docSnapshots.length; j++) {
    //     list[j] = docSnapshots[0]['step'];
    //   }
    // }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  color: Colors.black,
                  iconSize: 30,
                  onPressed: () {},
                ),
                Text(
                  '일주일간의 걸음수',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  color: Colors.black,
                  iconSize: 30,
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            // ToggleButtons(
            //   fillColor: Color(0xff8CAAD8),
            //   // selectedColor: Color(0xff000000),
            //   selectedColor: Color(0xffffffff),
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 10),
            //       child: Text(
            //         '최근 7일',
            //         style: TextStyle(fontSize: 14),
            //       ),
            //     ),
            //     Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 10),
            //       child: Text(
            //         '최근 30일',
            //         style: TextStyle(fontSize: 14),
            //       ),
            //     ),
            //   ],
            //   // isSelected: isSelected,
            //   // onPressed: toggleSelect,
            //   isSelected: isSelected,
            //   // onPressed: (int index) {
            //   //   setState(() {
            //   //     // _selections[index] = !_selections[index];
            //   //     for (int i = 0; i < _selections.length; i++) {
            //   //       _selections[i] = i == index;
            //   //     }
            //   //   });
            //   // },
            //   // renderBorder: false,
            //   onPressed: toggleSelect,
            // ),
            SizedBox(
              height: 15.0,
            ),
            Flexible(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                    color: Color(0xffeeeeee)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 20, left: 20, top: 24, bottom: 12),
                  child: weekData(),
                  // child: LineChart(
                  //   // showAvg ? avgData() : mainData(),
                  //   showAvg ? mainData() : avgData(),
                  // ),
                  // child: BarChart(
                  //   isWeekorMonth ? weekData() : monthData(),
                  //   swapAnimationDuration: animDuration,
                  // ),
                ),
              ),
            ),
            // showAvg ? showMessage30() : showMessage7(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(
                //   height: MediaQuery.of(context).size.height * 0.2,
                //   width: MediaQuery.of(context).size.width * 0.4,
                //   child: SfLinearGauge(
                //     axisLabelStyle: TextStyle(
                //         color: Colors.black,
                //         fontSize: 10,
                //         fontStyle: FontStyle.italic,
                //         fontFamily: 'Pretendard'),
                //     interval: 20,
                //     markerPointers: [
                //       LinearShapePointer(
                //         // value: 50,
                //         value: shapePointerValue,
                //         onChanged: (value) {
                //           setState(() {
                //             shapePointerValue = value;
                //           });
                //         },
                //       ),
                //     ],
                //     // ranges: [
                //     //   LinearGaugeRange(
                //     //     startValue: 0,
                //     //     endValue: 100,
                //     //   ),
                //     // ],
                //     barPointers: [LinearBarPointer(value: 80)],
                //   ),
                // ),
                // showAvg ? showMessage7() : showMessage30(),
                Text(
                  '💡',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                // isWeekorMonth ? showMessage7() : showMessage30(),
                showMessage7(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void toggleSelect(value) {
    if (value == 0) {
      isWeek = true;
      isMonth = false;
      isWeekorMonth = true;
      // print(showAvg);
    } else {
      isWeek = false;
      isMonth = true;
      isWeekorMonth = false;
      // print(showAvg);
    }
    setState(() {
      isSelected = [isWeek, isMonth];
    });
  }

  FutureBuilder weekData() {
    return FutureBuilder(
      future: getSevenDaysData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return Container();
        } else {
          return BarChart(
            BarChartData(
              maxY: 7000,
              alignment: BarChartAlignment.spaceAround,
              barGroups: [
                generateGroupData(1, snapshot.data[7] ?? 0),
                generateGroupData(2, snapshot.data[6] ?? 0),
                generateGroupData(3, snapshot.data[5] ?? 0),
                generateGroupData(4, snapshot.data[4] ?? 0),
                generateGroupData(5, snapshot.data[3] ?? 0),
                generateGroupData(6, snapshot.data[2] ?? 0),
                generateGroupData(7, snapshot.data[1] ?? 0),
              ],
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Color(0xffFFCD00),
                  tooltipRoundedRadius: 33,
                ),
                enabled: true,
                handleBuiltInTouches: false,
                touchCallback: (event, response) {
                  if (response != null &&
                      response.spot != null &&
                      event is FlTapUpEvent) {
                    setState(() {
                      final x = response.spot!.touchedBarGroup.x;
                      final isShowing = showingTooltip == x;
                      if (isShowing) {
                        showingTooltip = -1;
                      } else {
                        showingTooltip = x;
                      }
                    });
                  }
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: getTitles,
                    reservedSize: 38,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: leftTitleWidgets7,
                    interval: 1000,
                    reservedSize: 50,
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: Color(0xffdddddd),
                ),
              ),
              gridData: FlGridData(show: false),
            ),
          );
        }
      },
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    DateTime date = DateTime.now().subtract(Duration(days: 1));

    const style = TextStyle(
      fontFamily: 'Pretandard',
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text('${date.subtract(Duration(days: 7)).day}일', style: style);
        break;
      case 1:
        text = Text('${date.subtract(Duration(days: 6)).day}일', style: style);
        break;
      case 2:
        text = Text('${date.subtract(Duration(days: 5)).day}일', style: style);
        break;
      case 3:
        text = Text('${date.subtract(Duration(days: 4)).day}일', style: style);
        break;
      case 4:
        text = Text('${date.subtract(Duration(days: 3)).day}일', style: style);
        break;
      case 5:
        text = Text('${date.subtract(Duration(days: 2)).day}일', style: style);
        break;
      case 6:
        text = Text('${date.subtract(Duration(days: 1)).day}일', style: style);
        break;
      case 7:
        text = Text('${date.day}일', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: text,
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isWeekorMonth) {
      await refreshState();
    }
  }

  BarChartGroupData generateGroupData(int x, int y) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: showingTooltip == x ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: y.toDouble(),
          color: Color(0xff4675C0),
        ),
      ],
    );
  }

  Widget leftTitleWidgets7(double value, TitleMeta meta) {
    const style = TextStyle(
      fontFamily: 'Pretendard',
      color: Color(0xff000000),
      fontWeight: FontWeight.normal,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1000:
        text = '1000';
        break;
      case 2000:
        text = '2000';
        break;
      case 3000:
        text = '3000';
        break;
      case 4000:
        text = '4000';
        break;
      case 5000:
        text = '5000';
        break;
      case 6000:
        text = '6000';
        break;
      case 7000:
        text = '7000';
        break;
      default:
        text = '';
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  // Widget leftTitleWidgets30(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     fontFamily: 'Pretendard',
  //     color: Color(0xff000000),
  //     fontWeight: FontWeight.bold,
  //     fontSize: 14,
  //   );
  //   String text;
  //   switch (value.toInt()) {
  //     case 1000:
  //       text = '1000';
  //       break;
  //     case 2000:
  //       text = '2000';
  //       break;
  //     case 3000:
  //       text = '3000';
  //       break;
  //     case 4000:
  //       text = '4000';
  //       break;
  //     case 5000:
  //       text = '5000';
  //       break;
  //     case 6000:
  //       text = '6000';
  //       break;
  //     case 7000:
  //       text = '7000';
  //       break;
  //     case 8000:
  //       text = '8000';
  //       break;
  //     case 9000:
  //       text = '9000';
  //       break;
  //     case 1000:
  //       text = '10000';
  //       break;
  //     default:
  //       text = '';
  //   }

  //   return Text(text, style: style, textAlign: TextAlign.left);
  // }

  FutureBuilder showMessage7() {
    num avgStepsForWeek = 0;
    return FutureBuilder(
        future: getSevenDaysData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return Flexible(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffdddddd),
                ),
                child: Text(
                  // '생존률이 30% \n증가했습니다!\n\n잘하고 있어요! \n화이팅😆',
                  '기다려주세요!',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                  ),
                ),
              ),
            );
          } else {
            for (int i = 0; i < 7; i++) {
              avgStepsForWeek += snapshot.data[i];
            }
            return Flexible(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffdddddd),
                ),
                child: Text(
                  // '생존률이 30% \n증가했습니다!\n\n잘하고 있어요! \n화이팅😆',
                  '최근 7일간 평균적으로 ${avgStepsForWeek ~/ 7} 걸음만큼 걸으셨습니다!',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }
        });
  }

  FutureBuilder showMessage30() {
    num avgStepsForMonth = 0;
    return FutureBuilder(
        future: getMonthData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return Flexible(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffdddddd),
                ),
                child: Text(
                  '기다려주세요!',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                  ),
                ),
              ),
            );
          } else {
            for (int i = 0; i < snapshot.data.length; i++) {
              avgStepsForMonth += snapshot.data[i];
            }
            // print(snapshot.data.length);
            // for (int i = 1; i < 28; i++) {
            //   avgStepsForMonth += snapshot.data[i] ?? 0;
            // }
            return Flexible(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffdddddd),
                ),
                child: Text(
                  // '생존률이 30% \n증가했습니다!\n\n잘하고 있어요! \n화이팅😆',
                  // '30일 메세지',
                  '최근 30일간 평균적으로 ${avgStepsForMonth ~/ snapshot.data.length}걸음 만큼 걸으셨습니다!',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }
        });
  }
}
