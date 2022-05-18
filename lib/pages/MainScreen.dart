import 'package:flutter/material.dart';

import 'package:capstone_2022_48/pages/HomeCalendar.dart';
import 'package:capstone_2022_48/pages/Exercise.dart';
import 'package:capstone_2022_48/pages/Diet.dart';
import 'package:capstone_2022_48/pages/Stats.dart';

import 'package:intl/date_symbol_data_local.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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

    // int _selectedIndex = 0;

    // initializeDateFormatting();
    // return Scaffold(
    //   body: IndexedStack(
    //     index: _selectedIndex,
    //     children: [
    //       HomeCalendar(),
    //       StopWatch(),
    //       Diet(),
    //       Stats(),
    //     ],
    //   ),
    //   bottomNavigationBar: BottomNavigationBar(
    //     showSelectedLabels: false,
    //     showUnselectedLabels: false,
    //     currentIndex: _selectedIndex,
    //     backgroundColor: Colors.grey[100],
    //     selectedItemColor: Colors.black,
    //     unselectedItemColor: Colors.black54,
    //     onTap: (index) {
    //       setState(() {
    //         _selectedIndex = index;
    //       });
    //     },
    //     items: [
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.favorite),
    //         label: "",
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.directions_run),
    //         label: "",
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.restaurant),
    //         label: "",
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.assessment),
    //         label: "",
    //       ),
    //     ],
    //   ),
    // );
  }
}