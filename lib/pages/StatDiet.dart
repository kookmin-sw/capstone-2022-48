import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AverDietScreen extends StatefulWidget {
  const AverDietScreen({Key? key}) : super(key: key);

  @override
  State<AverDietScreen> createState() => _AverDietScreenState();
}

class _AverDietScreenState extends State<AverDietScreen> {
  bool isDay = false;
  bool isWeek = true;
  bool isMonth = false;
  late List<bool> isSelected;
  List<bool> _selections = List.generate(3, (_) => false);

  int touchedIndex = -1;

  void initState() {
    isSelected = [isDay, isWeek, isMonth];
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
                  '평균 영양 섭취 비율',
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
                    child: Text('오늘', style: TextStyle(fontSize: 14))),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('최근 7일', style: TextStyle(fontSize: 14))),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('최근 30일', style: TextStyle(fontSize: 14))),
              ],
              // isSelected: isSelected,
              // onPressed: toggleSelect,
              isSelected: _selections,
              onPressed: (int index) {
                setState(() {
                  // _selections[index] = !_selections[index];
                  for (int i = 0; i < _selections.length; i++) {
                    _selections[i] = i == index;
                  }
                });
              },
              // renderBorder: false,
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Indicator(
                  color: Color(0xff19335A),
                  text: '탄수화물',
                  isSquare: false,
                  size: touchedIndex == 0 ? 16 : 12,
                  textColor: touchedIndex == 0 ? Colors.black : Colors.grey,
                ),
                Indicator(
                  color: Color(0xff19335A),
                  text: '단백질',
                  isSquare: false,
                  size: touchedIndex == 1 ? 16 : 12,
                  textColor: touchedIndex == 1 ? Colors.black : Colors.grey,
                ),
                Indicator(
                  color: Color(0xff697A98),
                  text: '지방',
                  isSquare: false,
                  size: touchedIndex == 2 ? 16 : 12,
                  textColor: touchedIndex == 2 ? Colors.black : Colors.grey,
                ),
                // Indicator(
                //   color: Color(0xff13d38e),
                //   text: 'Four',
                //   isSquare: false,
                //   size: touchedIndex == 3 ? 16 : 12,
                //   textColor: touchedIndex == 3 ? Colors.black : Colors.grey,
                // ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            // PieChart(
            //   PieChartData(
            //     // centerSpaceRadius: 5,
            //     // borderData: FlBorderData(show: false),
            //     // sections: [
            //     //   PieChartSectionData(
            //     //       value: 1, color: Colors.purple, radius: 10),
            //     //   PieChartSectionData(
            //     //       value: 2, color: Colors.amber, radius: 11),
            //     //   PieChartSectionData(
            //     //       value: 3, color: Colors.green, radius: 12),
            //     // ],
            //     sections: piedata,
            //   ),
            // ),
            // Expanded(
            //   child: AspectRatio(
            //     aspectRatio: 1,
            //     child: PieChart(
            //       PieChartData(
            //           pieTouchData: PieTouchData(touchCallback:
            //               (FlTouchEvent event, pieTouchResponse) {
            //             setState(() {
            //               if (!event.isInterestedForInteractions ||
            //                   pieTouchResponse == null ||
            //                   pieTouchResponse.touchedSection == null) {
            //                 touchedIndex = -1;
            //                 return;
            //               }
            //               touchedIndex = pieTouchResponse
            //                   .touchedSection!.touchedSectionIndex;
            //             });
            //           }),
            //           startDegreeOffset: 180,
            //           borderData: FlBorderData(
            //             show: false,
            //           ),
            //           sectionsSpace: 1,
            //           centerSpaceRadius: 0,
            //           sections: showingSections()),
            //     ),
            //   ),
            // ),
            Expanded(
              // height: MediaQuery.of(context).size.height * 0.4,
              // width: MediaQuery.of(context).size.width * 0.4,
              child: PieChart(
                PieChartData(
                    pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    }),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 50,
                    sections: showingSections()),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              children: [
                // SfRadialGauge(axes: <RadialAxis>[
                //   RadialAxis(minimum: 0, maximum: 100, ranges: <GaugeRange>[
                //     GaugeRange(
                //         startValue: 0, endValue: 30, color: Colors.green),
                //     GaugeRange(
                //         startValue: 30, endValue: 60, color: Colors.orange),
                //     GaugeRange(startValue: 60, endValue: 100, color: Colors.red)
                //   ], pointers: <GaugePointer>[
                //     NeedlePointer(value: 90)
                //   ], annotations: <GaugeAnnotation>[
                //     GaugeAnnotation(
                //         widget: Container(
                //             child: Text('90.0',
                //                 style: TextStyle(
                //                     fontSize: 12,
                //                     fontWeight: FontWeight.bold))),
                //         angle: 90,
                //         positionFactor: 0.5)
                //   ])
                // ]),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.4,
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
                                endValue: 33,
                                color: Color(0xFFFE2A25),
                                label: '경고!',
                                sizeUnit: GaugeSizeUnit.factor,
                                labelStyle: GaugeTextStyle(
                                    fontFamily: 'Pretendard', fontSize: 12),
                                startWidth: 0.65,
                                endWidth: 0.65),
                            GaugeRange(
                              startValue: 33,
                              endValue: 66,
                              color: Color(0xFFFFBA00),
                              label: '조금만 더 힘내세요',
                              labelStyle: GaugeTextStyle(
                                  fontFamily: 'Pretendard', fontSize: 12),
                              startWidth: 0.65,
                              endWidth: 0.65,
                              sizeUnit: GaugeSizeUnit.factor,
                            ),
                            GaugeRange(
                              startValue: 66,
                              endValue: 99,
                              color: Color(0xFF00AB47),
                              label: '좋아요!',
                              labelStyle: GaugeTextStyle(
                                  fontFamily: 'Pretendard', fontSize: 12),
                              sizeUnit: GaugeSizeUnit.factor,
                              startWidth: 0.65,
                              endWidth: 0.65,
                            ),
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(value: 60)
                          ])
                    ],
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
                    '평균 권장 섭취율보다 n% 많이 섭취했어요! 탄수화물을 과다 섭취하면 비만, 고혈압의 위험이 있어요😥',
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

  void toggleSelect(value) {
    if (value == 0) {
      isWeek = true;
      isMonth = false;
      isDay = false;
    } else if (value == 1) {
      isWeek = false;
      isMonth = true;
      isDay = false;
    } else {
      isWeek = false;
      isMonth = false;
      isDay = true;
    }
    setState(() {
      isSelected = [isWeek, isMonth, isDay];
    });
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

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color(0xff19335A),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: Color(0xff697A98),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: Color(0xffB8BFD6),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}
