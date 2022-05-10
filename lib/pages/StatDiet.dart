import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';

class AverDietScreen extends StatefulWidget {
  const AverDietScreen({Key? key}) : super(key: key);

  @override
  State<AverDietScreen> createState() => _AverDietScreenState();
}

class _AverDietScreenState extends State<AverDietScreen> {
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
            Text(
              '평균 영양 섭취 비율',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            PieChart(
              PieChartData(
                // centerSpaceRadius: 5,
                // borderData: FlBorderData(show: false),
                // sections: [
                //   PieChartSectionData(
                //       value: 1, color: Colors.purple, radius: 10),
                //   PieChartSectionData(
                //       value: 2, color: Colors.amber, radius: 11),
                //   PieChartSectionData(
                //       value: 3, color: Colors.green, radius: 12),
                // ],
                sections: piedata,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<PieChartSectionData> piedata = [
  PieChartSectionData(title: "A", color: Colors.red),
  PieChartSectionData(title: "B", color: Colors.blue),
  PieChartSectionData(title: "C", color: Colors.green),
  PieChartSectionData(title: "D", color: Colors.yellow),
];
