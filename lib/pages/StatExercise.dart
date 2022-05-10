import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AverExerScreen extends StatefulWidget {
  const AverExerScreen({Key? key}) : super(key: key);

  @override
  State<AverExerScreen> createState() => _AverExerScreenState();
}

class _AverExerScreenState extends State<AverExerScreen> {
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
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
