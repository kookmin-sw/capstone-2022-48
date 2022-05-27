import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AverDietScreen extends StatefulWidget {
  const AverDietScreen({Key? key}) : super(key: key);

  @override
  State<AverDietScreen> createState() => _AverDietScreenState();
}

class _AverDietScreenState extends State<AverDietScreen> {
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

  CollectionReference _collectionKcals =
      FirebaseFirestore.instance.collection('DietDataCollection');
  int showingTooltip = -1;

  bool isWeek = true;
  bool isMonth = false;
  late List<bool> isSelected;

  int touchedIndex = -1;

  bool showAvg = false;

  void initState() {
    isSelected = [isWeek, isMonth];
    super.initState();
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
                  '일주일간의 섭취 칼로리',
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
              height: 10.0,
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
            // showAvg ? showMessage30() : showMessage7(),
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
                // showAvg ? showMessage30() : showMessage7(),
              ],
            ),
          ],
        ),
      ),
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
      num cals = 0;
      _now = DateTime.now().subtract(Duration(days: i));
      _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
      _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

      QuerySnapshot querySnapshot = await _collectionKcals
          .where('date', isGreaterThanOrEqualTo: _start)
          .where('date', isLessThanOrEqualTo: _end)
          .orderBy('date')
          .get();
      var docSnapshots = querySnapshot.docs;
      if (docSnapshots != null && docSnapshots.length != 0) {
        for (int j = 0; j < docSnapshots.length; j++) {
          cals += docSnapshots[j]['cal'];
        }
        list[i - 1] = cals;
      }
    }

    return list;
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
              maxY: 3000,
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
                    getTitlesWidget: bottomTitleWidgets7,
                    reservedSize: 38,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: leftTitleWidgets,
                    interval: 500,
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

  FutureBuilder showMessage7() {
    num avgKcalsForWeek = 0;
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
              avgKcalsForWeek += snapshot.data[i];
            }
            avgKcalsForWeek = avgKcalsForWeek ~/ 7;
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
                  '최근 7일간 평균적으로 ${avgKcalsForWeek} Kcal만큼 섭취하셨습니다!',
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
      case 500:
        text = '500';
        break;
      case 1000:
        text = '1000';
        break;
      case 1500:
        text = '1500';
        break;
      case 2000:
        text = '2000';
        break;
      case 2500:
        text = '2500';
        break;
      case 3000:
        text = '3000';
        break;
      case 3500:
        text = '3500';
        break;
      case 4000:
        text = '4000';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}
