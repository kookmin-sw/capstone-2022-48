import 'package:capstone_2022_48/pages/ExercisePage.dart';
import 'package:capstone_2022_48/pages/Signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:capstone_2022_48/pages/HomeCalendar.dart';
import 'package:capstone_2022_48/pages/Exercise.dart';
import 'package:capstone_2022_48/pages/Diet.dart';
import 'package:capstone_2022_48/pages/Stats.dart';

class TabNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;

  TabNavigationItem(
      {required this.page, required this.title, required this.icon});

  static List<TabNavigationItem> get items => [
        TabNavigationItem(
          page: HomeCalendar(),
          icon: Icon(Icons.favorite),
          title: Text("Home"),
        ),
        TabNavigationItem(
          page: StopWatch(),
          icon: Icon(Icons.directions_run),
          title: Text("Exercise"),
        ),
        TabNavigationItem(
          page: Diet(),
          icon: Icon(Icons.restaurant),
          title: Text("Diet"),
        ),
        TabNavigationItem(
          page: Stats(),
          icon: Icon(Icons.assessment),
          title: Text("Stats"),
        ),
      ];
}
