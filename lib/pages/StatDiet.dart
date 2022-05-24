import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AverDietScreen extends StatefulWidget {
  const AverDietScreen({Key? key}) : super(key: key);

  @override
  State<AverDietScreen> createState() => _AverDietScreenState();
}

class _AverDietScreenState extends State<AverDietScreen> {
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
                  '섭취 칼로리 통계',
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
              fillColor: Color(0xff8CAAD8),
              selectedColor: Color(0xffffffff),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '최근 7일',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '최근 30일',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
              // isSelected: isSelected,
              // onPressed: toggleSelect,
              isSelected: isSelected,
              onPressed: toggleSelect,
              // renderBorder: false,
            ),
            SizedBox(
              height: 10.0,
            ),
            // Row(
            //   mainAxisSize: MainAxisSize.max,
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: <Widget>[
            //     Indicator(
            //       color: Color(0xff19335A),
            //       text: '탄수화물',
            //       isSquare: false,
            //       size: touchedIndex == 0 ? 16 : 12,
            //       textColor: touchedIndex == 0 ? Colors.black : Colors.grey,
            //     ),
            //     Indicator(
            //       color: Color(0xff19335A),
            //       text: '단백질',
            //       isSquare: false,
            //       size: touchedIndex == 1 ? 16 : 12,
            //       textColor: touchedIndex == 1 ? Colors.black : Colors.grey,
            //     ),
            //     Indicator(
            //       color: Color(0xff697A98),
            //       text: '지방',
            //       isSquare: false,
            //       size: touchedIndex == 2 ? 16 : 12,
            //       textColor: touchedIndex == 2 ? Colors.black : Colors.grey,
            //     ),
            //     // Indicator(
            //     //   color: Color(0xff13d38e),
            //     //   text: 'Four',
            //     //   isSquare: false,
            //     //   size: touchedIndex == 3 ? 16 : 12,
            //     //   textColor: touchedIndex == 3 ? Colors.black : Colors.grey,
            //     // ),
            //   ],
            // ),
            // SizedBox(
            //   height: 20.0,
            // ),
            // // PieChart(
            // //   PieChartData(
            // //     // centerSpaceRadius: 5,
            // //     // borderData: FlBorderData(show: false),
            // //     // sections: [
            // //     //   PieChartSectionData(
            // //     //       value: 1, color: Colors.purple, radius: 10),
            // //     //   PieChartSectionData(
            // //     //       value: 2, color: Colors.amber, radius: 11),
            // //     //   PieChartSectionData(
            // //     //       value: 3, color: Colors.green, radius: 12),
            // //     // ],
            // //     sections: piedata,
            // //   ),
            // // ),
            // // Expanded(
            // //   child: AspectRatio(
            // //     aspectRatio: 1,
            // //     child: PieChart(
            // //       PieChartData(
            // //           pieTouchData: PieTouchData(touchCallback:
            // //               (FlTouchEvent event, pieTouchResponse) {
            // //             setState(() {
            // //               if (!event.isInterestedForInteractions ||
            // //                   pieTouchResponse == null ||
            // //                   pieTouchResponse.touchedSection == null) {
            // //                 touchedIndex = -1;
            // //                 return;
            // //               }
            // //               touchedIndex = pieTouchResponse
            // //                   .touchedSection!.touchedSectionIndex;
            // //             });
            // //           }),
            // //           startDegreeOffset: 180,
            // //           borderData: FlBorderData(
            // //             show: false,
            // //           ),
            // //           sectionsSpace: 1,
            // //           centerSpaceRadius: 0,
            // //           sections: showingSections()),
            // //     ),
            // //   ),
            // // ),
            // Expanded(
            //   // height: MediaQuery.of(context).size.height * 0.4,
            //   // width: MediaQuery.of(context).size.width * 0.4,
            //   child: PieChart(
            //     PieChartData(
            //         pieTouchData: PieTouchData(
            //             touchCallback: (FlTouchEvent event, pieTouchResponse) {
            //           setState(() {
            //             if (!event.isInterestedForInteractions ||
            //                 pieTouchResponse == null ||
            //                 pieTouchResponse.touchedSection == null) {
            //               touchedIndex = -1;
            //               return;
            //             }
            //             touchedIndex = pieTouchResponse
            //                 .touchedSection!.touchedSectionIndex;
            //           });
            //         }),
            //         borderData: FlBorderData(
            //           show: false,
            //         ),
            //         sectionsSpace: 0,
            //         centerSpaceRadius: 50,
            //         sections: showingSections()),
            //   ),
            // ),
            // SizedBox(
            //   height: 15.0,
            // ),
            // Row(
            //   children: [
            //     // SfRadialGauge(axes: <RadialAxis>[
            //     //   RadialAxis(minimum: 0, maximum: 100, ranges: <GaugeRange>[
            //     //     GaugeRange(
            //     //         startValue: 0, endValue: 30, color: Colors.green),
            //     //     GaugeRange(
            //     //         startValue: 30, endValue: 60, color: Colors.orange),
            //     //     GaugeRange(startValue: 60, endValue: 100, color: Colors.red)
            //     //   ], pointers: <GaugePointer>[
            //     //     NeedlePointer(value: 90)
            //     //   ], annotations: <GaugeAnnotation>[
            //     //     GaugeAnnotation(
            //     //         widget: Container(
            //     //             child: Text('90.0',
            //     //                 style: TextStyle(
            //     //                     fontSize: 12,
            //     //                     fontWeight: FontWeight.bold))),
            //     //         angle: 90,
            //     //         positionFactor: 0.5)
            //     //   ])
            //     // ]),
            //     Container(
            //       height: MediaQuery.of(context).size.height * 0.2,
            //       width: MediaQuery.of(context).size.width * 0.4,
            //       child: SfRadialGauge(
            //         axes: <RadialAxis>[
            //           RadialAxis(
            //               showLabels: false,
            //               showAxisLine: false,
            //               showTicks: false,
            //               minimum: 0,
            //               maximum: 99,
            //               ranges: <GaugeRange>[
            //                 GaugeRange(
            //                     startValue: 0,
            //                     endValue: 33,
            //                     color: Color(0xFFFE2A25),
            //                     label: '경고!',
            //                     sizeUnit: GaugeSizeUnit.factor,
            //                     labelStyle: GaugeTextStyle(
            //                         fontFamily: 'Pretendard', fontSize: 12),
            //                     startWidth: 0.65,
            //                     endWidth: 0.65),
            //                 GaugeRange(
            //                   startValue: 33,
            //                   endValue: 66,
            //                   color: Color(0xFFFFBA00),
            //                   label: '조금만 더 힘내세요',
            //                   labelStyle: GaugeTextStyle(
            //                       fontFamily: 'Pretendard', fontSize: 12),
            //                   startWidth: 0.65,
            //                   endWidth: 0.65,
            //                   sizeUnit: GaugeSizeUnit.factor,
            //                 ),
            //                 GaugeRange(
            //                   startValue: 66,
            //                   endValue: 99,
            //                   color: Color(0xFF00AB47),
            //                   label: '좋아요!',
            //                   labelStyle: GaugeTextStyle(
            //                       fontFamily: 'Pretendard', fontSize: 12),
            //                   sizeUnit: GaugeSizeUnit.factor,
            //                   startWidth: 0.65,
            //                   endWidth: 0.65,
            //                 ),
            //               ],
            //               pointers: <GaugePointer>[
            //                 NeedlePointer(value: 60)
            //               ])
            //         ],
            //       ),
            //     ),
            //     Container(
            //       height: MediaQuery.of(context).size.height * 0.2,
            //       width: MediaQuery.of(context).size.width * 0.4,
            //       margin: EdgeInsets.all(10),
            //       padding: EdgeInsets.all(20),
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(20),
            //         color: Color(0xffdddddd),
            //       ),
            //       child: Text(
            //         '평균 권장 섭취율보다 n% 많이 섭취했어요! 탄수화물을 과다 섭취하면 비만, 고혈압의 위험이 있어요😥',
            //         style: TextStyle(
            //           fontFamily: 'Pretendard',
            //           fontSize: 16,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
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
                  child: LineChart(
                    // showAvg ? avgData() : mainData(),
                    showAvg ? mainData() : avgData(),
                  ),
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
                showAvg ? showMessage30() : showMessage7()
                // showAvg ? showMessage30() : showMessage7(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitleWidgets30(double value, TitleMeta meta) {
    const style = TextStyle(
      fontFamily: 'Pretendard',
      color: Color(0xff000000),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('-5', style: style);
        break;
      case 1:
        text = const Text('-4', style: style);
        break;
      case 2:
        text = const Text('-3', style: style);
        break;
      case 3:
        text = const Text('-2', style: style);
        break;
      case 4:
        text = const Text('-1', style: style);
        break;
      case 5:
        text = const Text('0', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return Padding(child: text, padding: const EdgeInsets.only(top: 8.0));
  }

  Widget bottomTitleWidgets7(double value, TitleMeta meta) {
    const style = TextStyle(
      fontFamily: 'Pretendard',
      color: Color(0xff000000),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('-6', style: style);
        break;
      case 1:
        text = const Text('-5', style: style);
        break;
      case 2:
        text = const Text('-4', style: style);
        break;
      case 3:
        text = const Text('-3', style: style);
        break;
      case 4:
        text = const Text('-2', style: style);
        break;
      case 5:
        text = const Text('-1', style: style);
        break;
      case 6:
        text = const Text('0', style: style);
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
        text = '500';
        break;
      case 2:
        text = '1000';
        break;
      case 3:
        text = '1500';
        break;
      case 4:
        text = '2000';
        break;
      case 5:
        text = '2500';
        break;
      case 6:
        text = '3000';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    // 최근 30일
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
            getTitlesWidget: bottomTitleWidgets30,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 50,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff19335A), width: 1)),
      minX: 0,
      maxX: 4,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(1, 2),
            FlSpot(2, 5),
            FlSpot(3, 3.1),
            FlSpot(4, 3),
          ],
          isCurved: false,
          // gradient: LinearGradient(
          //   colors: gradientColors,
          //   begin: Alignment.centerLeft,
          //   end: Alignment.centerRight,
          // ),

          color: Color(0xff19335A),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    // 최근 7일
    return LineChartData(
      // lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            // color: const Color(0xff19335A),
            color: Color(0xff000000),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            // color: const Color(0xff19335A),
            color: Color(0xff000000),
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
            getTitlesWidget: bottomTitleWidgets7,
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
          border: Border.all(color: const Color(0xff000000), width: 1)),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(1, 1),
            FlSpot(2, 5),
            FlSpot(3, 4.7),
            FlSpot(4, 3),
            FlSpot(5, 2.5),
            FlSpot(6, 4),
          ],
          isCurved: false,
          // gradient: LinearGradient(
          //   colors: [
          //     ColorTween(begin: gradientColors[0], end: gradientColors[1])
          //         .lerp(0.2)!,
          //     ColorTween(begin: gradientColors[0], end: gradientColors[1])
          //         .lerp(0.2)!,
          //   ],
          //   begin: Alignment.centerLeft,
          //   end: Alignment.centerRight,
          // ),
          color: Color(0xff19335A),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),
      ],
    );
  }

  void toggleSelect(value) {
    if (value == 0) {
      isWeek = true;
      isMonth = false;
      showAvg = false;
      // print(showAvg);
    } else {
      isWeek = false;
      isMonth = true;
      showAvg = true;
      // print(showAvg);
    }
    setState(() {
      isSelected = [isWeek, isMonth];
    });
  }

  Widget showMessage7() {
    var avgCalsForWeek = 1600;
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
          // '최근 7일간 ${avgCalsForWeek}만큼 걸으셨습니다!',
          '최근 7일간 평균적으로 ${avgCalsForWeek}kcal을 섭취하셨습니다!',

          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget showMessage30() {
    var avgCalsForMonth = 1400;
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
          '최근 30일간 평균적으로 ${avgCalsForMonth}kcal을 섭취하셨습니다!',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
          ),
        ),
      ),
    );
  }
//   List<PieChartSectionData> showingSections() {
//     return List.generate(
//       4,
//       (i) {
//         final isTouched = i == touchedIndex;
//         final opacity = isTouched ? 1.0 : 0.6;

//         const color0 = Color(0xff0293ee);
//         const color1 = Color(0xfff8b250);
//         const color2 = Color(0xff845bef);
//         const color3 = Color(0xff13d38e);

//         switch (i) {
//           case 0:
//             return PieChartSectionData(
//               color: color0.withOpacity(opacity),
//               value: 25,
//               title: '',
//               radius: 80,
//               titleStyle: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff044d7c)),
//               titlePositionPercentageOffset: 0.55,
//               borderSide: isTouched
//                   ? BorderSide(color: color0.darken(40), width: 6)
//                   : BorderSide(color: color0.withOpacity(0)),
//             );
//           case 1:
//             return PieChartSectionData(
//               color: color1.withOpacity(opacity),
//               value: 25,
//               title: '',
//               radius: 65,
//               titleStyle: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff90672d)),
//               titlePositionPercentageOffset: 0.55,
//               borderSide: isTouched
//                   ? BorderSide(color: color1.darken(40), width: 6)
//                   : BorderSide(color: color2.withOpacity(0)),
//             );
//           case 2:
//             return PieChartSectionData(
//               color: color2.withOpacity(opacity),
//               value: 25,
//               title: '',
//               radius: 60,
//               titleStyle: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff4c3788)),
//               titlePositionPercentageOffset: 0.6,
//               borderSide: isTouched
//                   ? BorderSide(color: color2.darken(40), width: 6)
//                   : BorderSide(color: color2.withOpacity(0)),
//             );
//           case 3:
//             return PieChartSectionData(
//               color: color3.withOpacity(opacity),
//               value: 25,
//               title: '',
//               radius: 70,
//               titleStyle: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff0c7f55)),
//               titlePositionPercentageOffset: 0.55,
//               borderSide: isTouched
//                   ? BorderSide(color: color3.darken(40), width: 6)
//                   : BorderSide(color: color2.withOpacity(0)),
//             );
//           default:
//             throw Error();
//         }
//       },
//     );
//   }
// }

  // List<PieChartSectionData> showingSections() {
  //   return List.generate(3, (i) {
  //     final isTouched = i == touchedIndex;
  //     final fontSize = isTouched ? 25.0 : 16.0;
  //     final radius = isTouched ? 110.0 : 100.0;
  //     switch (i) {
  //       case 0:
  //         return PieChartSectionData(
  //           color: Color(0xff19335A),
  //           value: 40,
  //           title: '40%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //               fontSize: fontSize,
  //               fontWeight: FontWeight.bold,
  //               color: Color(0xffffffff)),
  //         );
  //       case 1:
  //         return PieChartSectionData(
  //           color: Color(0xff697A98),
  //           value: 30,
  //           title: '30%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //               fontSize: fontSize,
  //               fontWeight: FontWeight.bold,
  //               color: Color(0xffffffff)),
  //         );
  //       case 2:
  //         return PieChartSectionData(
  //           color: Color(0xffB8BFD6),
  //           value: 15,
  //           title: '15%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //               fontSize: fontSize,
  //               fontWeight: FontWeight.bold,
  //               color: Color(0xffffffff)),
  //         );
  //       default:
  //         throw Error();
  //     }
  //   });
  // }
}
