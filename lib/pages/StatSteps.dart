import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AverStepsScreen extends StatefulWidget {
  const AverStepsScreen({Key? key}) : super(key: key);

  @override
  State<AverStepsScreen> createState() => _AverStepsScreenState();
}

class _AverStepsScreenState extends State<AverStepsScreen> {
  bool isWeek = true;
  bool isMonth = false;
  late List<bool> isSelected;
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 30.0,
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
                  '평균 걸음수',
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
            ToggleButtons(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('최근 7일', style: TextStyle(fontSize: 14))),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('최근 30일', style: TextStyle(fontSize: 14))),
              ],
              // isSelected: isSelected,
              // onPressed: toggleSelect,
              isSelected: isSelected,
              // onPressed: (int index) {
              //   setState(() {
              //     // _selections[index] = !_selections[index];
              //     for (int i = 0; i < _selections.length; i++) {
              //       _selections[i] = i == index;
              //     }
              //   });
              // },
              // renderBorder: false,
              onPressed: toggleSelect,
            ),
            SizedBox(
              height: 15.0,
            ),
            AspectRatio(
              aspectRatio: 1.5,
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                    color: Color(0xffeeeeee)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 20, left: 20, top: 24, bottom: 12),
                  child: LineChart(
                    showAvg ? avgData() : mainData(),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: SfLinearGauge(
                    axisLabelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Pretendard'),
                    interval: 20,
                    markerPointers: [
                      LinearShapePointer(
                        // value: 50,
                        value: shapePointerValue,
                        onChanged: (value) {
                          setState(() {
                            shapePointerValue = value;
                          });
                        },
                      ),
                    ],
                    // ranges: [
                    //   LinearGaugeRange(
                    //     startValue: 0,
                    //     endValue: 100,
                    //   ),
                    // ],
                    barPointers: [LinearBarPointer(value: 80)],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.4,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xffdddddd),
                  ),
                  child: Text(
                    '생존률이 30% \n증가했습니다!\n\n잘하고 있어요! \n화이팅😆',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontFamily: 'Pretendard',
      color: Color(0xff000000),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('3월', style: style);
        break;
      case 5:
        text = const Text('4월', style: style);
        break;
      case 8:
        text = const Text('5월', style: style);
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
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1000';
        break;
      case 3:
        text = '3000';
        break;
      case 5:
        text = '5000';
        break;
      case 7:
        text = '7000';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff000000),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff000000),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff19335A), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff19335A),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff19335A),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff19335A), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }

  void toggleSelect(value) {
    if (value == 0) {
      isWeek = true;
      isMonth = false;
    } else {
      isWeek = false;
      isMonth = true;
    }
    setState(() {
      isSelected = [isWeek, isMonth];
    });
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
