import 'package:flutter/material.dart';
import 'StatSteps.dart';
import 'StatDiet.dart';
import 'StatExercise.dart';
import 'CompareStat.dart';
import 'package:capstone_2022_48/drawer/main_drawer.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  PageController _pagecontroller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pagecontroller,
        children: [
          AverStepsScreen(),
          AverDietScreen(),
          AverExerScreen(),
          CompareStatDiet(),
        ],
      ),
      // drawer: MainDrawer(),
    );
  }
}
