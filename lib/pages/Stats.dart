import 'package:flutter/material.dart';
import 'StatSteps.dart';
import 'StatDiet.dart';
import 'StatExercise.dart';
import 'CompareStat.dart';
// import 'package:capstone_2022_48/drawer/main_drawer.dart';

import 'package:capstone_2022_48/navigator/sidemenu.dart';

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
      drawer: SideMenu(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: PageView(
        controller: _pagecontroller,
        children: [
          AverStepsScreen(),
          AverDietScreen(),
          AverExerScreen(),
        ],
      ),
      // drawer: MainDrawer(),
    );
  }
}
