import 'package:flutter/material.dart';
import 'StatSteps.dart';
import 'StatDiet.dart';
import 'StatExercise.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: Color(0xffeeeeee),
    //   body: Center(
    //     child: Text(
    //       '통계 페이지',
    //       style: TextStyle(
    //         fontFamily: 'Pretendard',
    //         fontWeight: FontWeight.bold,
    //         fontSize: 24,
    //       ),
    //     ),
    //   ),
    // );
    return AverStepsScreen();
    // return AverDietScreen();
    // return AverExerScreen();
  }
}
