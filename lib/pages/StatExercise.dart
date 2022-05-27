import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AverExerScreen extends StatefulWidget {
  const AverExerScreen({Key? key}) : super(key: key);

  @override
  State<AverExerScreen> createState() => _AverExerScreenState();
}

class _AverExerScreenState extends State<AverExerScreen> {
  final spinkit = SpinKitPumpingHeart(
    color: Color(0xFFf05650),
    size: 120,
    // itemBuilder: (BuildContext context, int) {
    //   return DecoratedBox(
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //     ),
    //   );
    // },
  );

  CollectionReference _collectionExc =
      FirebaseFirestore.instance.collection('ExerciseDataCollection');
  int showingTooltip = -1;

  bool isWeek = true;
  bool isMonth = false;
  late List<bool> isSelected;

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
                  '일주일간의 운동시간',
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
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '💡',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                showMessage7()
              ],
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder weekData() {
    return FutureBuilder(
      future: getSevenDaysData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return Center(child: spinkit);
        } else {
          return BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barGroups: [
                generateGroupData(1, snapshot.data[6] ?? 0),
                generateGroupData(2, snapshot.data[5] ?? 0),
                generateGroupData(3, snapshot.data[4] ?? 0),
                generateGroupData(4, snapshot.data[3] ?? 0),
                generateGroupData(5, snapshot.data[2] ?? 0),
                generateGroupData(6, snapshot.data[1] ?? 0),
                generateGroupData(7, snapshot.data[0] ?? 0),
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
                    getTitlesWidget: bottomTitleWidgets7,
                    reservedSize: 38,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: leftTitleWidgets,
                    interval: 30,
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
      num times = 0;
      _now = DateTime.now().subtract(Duration(days: i));
      _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
      _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

      QuerySnapshot querySnapshot = await _collectionExc
          .where('date', isGreaterThanOrEqualTo: _start)
          .where('date', isLessThanOrEqualTo: _end)
          .orderBy('date')
          .get();
      var docSnapshots = querySnapshot.docs;
      if (docSnapshots != null && docSnapshots.length != 0) {
        for (int j = 0; j < docSnapshots.length; j++) {
          times += docSnapshots[j]['time'];
        }
        list[i - 1] = times;
      }
    }

    return list;
  }

  Widget bottomTitleWidgets7(double value, TitleMeta meta) {
    DateTime date = DateTime.now().subtract(Duration(days: 1));

    const style = TextStyle(
      fontFamily: 'Pretendard',
      color: Color(0xff000000),
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

    return Padding(child: text, padding: const EdgeInsets.only(top: 8.0));
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontFamily: 'Pretendard',
      color: Color(0xff000000),
      fontWeight: FontWeight.normal,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 30:
        text = '30분';
        break;
      case 60:
        text = '1시간';
        break;
      case 90:
        text = '1시간 30분';
        break;
      case 120:
        text = '2시간';
        break;
      case 150:
        text = '2시간 30분';
        break;
      case 180:
        text = '3시간';
        break;
      case 210:
        text = '3시간 30분';
        break;
      case 240:
        text = '4시간';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  FutureBuilder showMessage7() {
    num avgExersForWeek = 0;
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
              avgExersForWeek += snapshot.data[i];
            }

            num avgExersForWeekMinutes = avgExersForWeek ~/ 7;
            avgExersForWeekMinutes = avgExersForWeekMinutes % 60;
            num avgExersForWeekHours = avgExersForWeek ~/ 7;
            avgExersForWeekHours = avgExersForWeekHours ~/ 60;
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
                  '최근 7일간 평균적으로 ${avgExersForWeekHours}시간 ${avgExersForWeekMinutes}분만큼 운동하셨어요!',
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
