import 'package:capstone_2022_48/pages/HomeCalendar.dart';
import 'package:capstone_2022_48/pages/Exercise.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:provider/provider.dart';
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
      title: 'test',
      // home: HomeCalendar(),
      home: StopWatch(),
    );
  }
}