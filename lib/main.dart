import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:capstone_2022_48/pages/HomeCalendar.dart';
import 'package:capstone_2022_48/pages/Exercise.dart';
import 'package:capstone_2022_48/pages/Diet.dart';
import 'package:capstone_2022_48/pages/Stats.dart';

// import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  runApp(MyApp());
  // initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        // debugShowCheckedModeBanner: false,
        // title: 'test',
        // home: HomeCalendar(),
        // home: StopWatch(),
        // home: Diet(),
        // home: Stats(),
        // initialIndex: 1,
        length: 4,
        child: Scaffold(
          // body: HomeCalendar(),
          body: TabBarView(
            children: [
              HomeCalendar(),
              StopWatch(),
              Diet(),
              Stats(),
            ],
          ),
          bottomNavigationBar: TabBar(
            labelStyle: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.bold,
                fontSize: 12),
            tabs: <Widget>[
              Tab(
                height: 50,
                icon: Icon(Icons.favorite),
                text: 'home',
              ),
              Tab(
                  height: 50,
                  icon: Icon(Icons.directions_run),
                  text: 'exercise'),
              Tab(
                height: 50,
                icon: Icon(Icons.restaurant),
                text: 'diet',
              ),
              Tab(
                height: 50,
                icon: Icon(Icons.assessment),
                text: 'stats',
              ),
            ],
            labelColor: Color(0xff4675C0),
          ),
        ),
      ),
    );
  }
}
