import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AverStepsScreen extends StatefulWidget {
  const AverStepsScreen({Key? key}) : super(key: key);

  @override
  State<AverStepsScreen> createState() => _AverStepsScreenState();
}

class _AverStepsScreenState extends State<AverStepsScreen> {
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
              '평균 걸음수',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 8.0),
            SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <LineSeries<SalesData, String>>[
                  LineSeries<SalesData, String>(
                      dataSource: <SalesData>[
                        SalesData('Jan', 35),
                        SalesData('Feb', 28),
                        SalesData('Mar', 34),
                        SalesData('Apr', 32),
                        SalesData('May', 40)
                      ],
                      xValueMapper: (SalesData sales, _) => sales.year,
                      yValueMapper: (SalesData sales, _) => sales.sales)
                ]),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
