import 'package:capstone_2022_48/pages/Diet.dart';
import 'package:capstone_2022_48/pages/HomeCalendar.dart';
import 'package:capstone_2022_48/pages/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_2022_48/pages/Signin_screen.dart';

import 'package:capstone_2022_48/pages/HomeCalendar.dart';
import 'package:capstone_2022_48/pages/Exercise.dart';
import 'package:capstone_2022_48/pages/Diet.dart';
import 'package:capstone_2022_48/pages/Stats.dart';

// import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:capstone_2022_48/model/DataModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:capstone_2022_48/navigator/profile.dart';

// void main() {
//   runApp(MyApp());
//   // initializeDateFormatting().then((_) => runApp(MyApp()));
// }

// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // const MyApp({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     // initializeDateFormatting();
//     // return MaterialApp(
//     //    debugShowCheckedModeBanner: false,
//     //   home: DefaultTabController(
//     //     // debugShowCheckedModeBanner: false,
//     //     // title: 'test',
//     //     // home: HomeCalendar(),
//     //     // home: StopWatch(),
//     //     // home: Diet(),
//     //     // home: Stats(),
//     //     // initialIndex: 1,
//     //     length: 4,
//     //     child: Scaffold(
//     //       // body: HomeCalendar(),
//     //       body: TabBarView(
//     //         children: [
//     //           HomeCalendar(),
//     //           StopWatch(),
//     //           Diet(),
//     //           Stats(),
//     //         ],
//     //       ),
//     //       bottomNavigationBar: TabBar(
//     //         labelStyle: TextStyle(
//     //             fontFamily: 'Pretendard',
//     //             fontWeight: FontWeight.bold,
//     //             fontSize: 12),
//     //         tabs: <Widget>[
//     //           Tab(
//     //             height: 50,
//     //             icon: Icon(Icons.favorite),
//     //             text: 'home',
//     //           ),
//     //           Tab(
//     //               height: 50,
//     //               icon: Icon(Icons.directions_run),
//     //               text: 'exercise'),
//     //           Tab(
//     //             height: 50,
//     //             icon: Icon(Icons.restaurant),
//     //             text: 'diet',
//     //           ),
//     //           Tab(
//     //             height: 50,
//     //             icon: Icon(Icons.assessment),
//     //             text: 'stats',
//     //           ),
//     //         ],
//     //         labelColor: Color(0xff4675C0),
//     //       ),
//     //     ),
//     //   ),
//     // );

//     int _selectedIndex = 0;

//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: [
//           HomeCalendar(),
//           StopWatch(),
//           Diet(),
//           Stats(),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         showSelectedLabels: false,
//         showUnselectedLabels: false,
//         currentIndex: _selectedIndex,
//         backgroundColor: Colors.grey[100],
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.black54,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: "",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.directions_run),
//             label: "",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.restaurant),
//             label: "",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.assessment),
//             label: "",
//           ),
//         ],
//       ),
//     );
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      // MultiProvider(
      //   providers: [
      //     ChangeNotifierProvider(create: (_) => ExerciseData()),
      //     ChangeNotifierProvider(create: (_) => DietData()),
      //     ChangeNotifierProvider(create: (_) => StepData()),
      //   ],
      //   child: MyApp(),
      // ),
      MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Future<Database> diet_database = initDatabase();

    return MaterialApp(
      // initialRoute: '/',
      // routes: {
      //   // '/': (context) => HomeCalendar(db: diet_database),
      //   '/': (context) => MainScreen(db: diet_database),
      //   '/add': (context) => Diet(db: diet_database),
      // },
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ExerciseData()),
          ChangeNotifierProvider(create: (_) => DietData()),
          ChangeNotifierProvider(create: (_) => StepData()),
        ],
        // child: MainScreen(db: diet_database),
        child: MainScreen(),
      ),
      // home: SignInScreen(),
      // routes: {
      //   SignInScreen.route: (_) => SignInScreen(),
      //   HomeCalendar.route: (_) => HomeCalendar(),
      //   ProfileScreen.route: (_) => ProfileScreen(),
      // },
      // home: MainScreen(),
    );
  }

  // Future<Database> initDatabase() async {
  //   return openDatabase(
  //     join(await getDatabasesPath(), 'diet_database.db'),
  //     onCreate: (db, version) {
  //       return db.execute(
  //         "CREATE TABLE diets(id INTEGER PRIMARY KEY AUTOINCREMENT, "
  //         "name TEXT, kcal INTEGER, type INTEGER, score INTEGER)",
  //       );
  //     },
  //     version: 1,
  //   );
  // }
}

// class MainScreen extends StatefulWidget {
//   // final Future<Database> db;
//   MainScreen({Key? key}) : super(key: key);

//   // const MainScreen({Key? key}) : super(key: key);

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   @override
//   Widget build(BuildContext context) {
//     // Future<Database> diet_database = initDatabase();

//     initializeDateFormatting();
//     return MaterialApp(
//       // initialRoute: '/',
//       // routes: {
//       //   '/': (context) => HomeCalendar(db: diet_database),
//       //   '/add': (context) => Diet(db: diet_database),
//       // },
//       debugShowCheckedModeBanner: false,
//       home: DefaultTabController(
//         // debugShowCheckedModeBanner: false,
//         // title: 'test',
//         // home: HomeCalendar(),
//         // home: StopWatch(),
//         // home: Diet(),
//         // home: Stats(),
//         // initialIndex: 1,
//         length: 4,
//         child: Scaffold(
//           // body: HomeCalendar(),
//           body: TabBarView(
//             children: [
//               HomeCalendar(),
//               StopWatch(),
//               // ExerciseScreen(),
//               Diet(),
//               Stats(),
//             ],
//           ),
//           bottomNavigationBar: Container(
//             // height: MediaQuery.of(context).size.height * 0.09,
//             child: TabBar(
//               labelStyle: TextStyle(
//                   fontFamily: 'Pretendard',
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12),
//               tabs: <Widget>[
//                 Tab(
//                   height: 60,
//                   icon: Icon(Icons.favorite),
//                   text: 'home',
//                 ),
//                 Tab(
//                     height: 60,
//                     icon: Icon(Icons.directions_run),
//                     text: 'exercise'),
//                 Tab(
//                   height: 60,
//                   icon: Icon(Icons.restaurant),
//                   text: 'diet',
//                 ),
//                 Tab(
//                   height: 60,
//                   icon: Icon(Icons.assessment),
//                   text: 'stats',
//                 ),
//               ],
//               // indicator: BoxDecoration(
//               //   color: Color(0xff4675C0),
//               // ),
//               labelColor: Color(0xff4675C0),
//             ),
//           ),
//         ),
//       ),
//     );

//     // int _selectedIndex = 0;

//     // initializeDateFormatting();
//     // return Scaffold(
//     //   body: IndexedStack(
//     //     index: _selectedIndex,
//     //     children: [
//     //       HomeCalendar(),
//     //       StopWatch(),
//     //       Diet(),
//     //       Stats(),
//     //     ],
//     //   ),
//     //   bottomNavigationBar: BottomNavigationBar(
//     //     showSelectedLabels: false,
//     //     showUnselectedLabels: false,
//     //     currentIndex: _selectedIndex,
//     //     backgroundColor: Colors.grey[100],
//     //     selectedItemColor: Colors.black,
//     //     unselectedItemColor: Colors.black54,
//     //     onTap: (index) {
//     //       setState(() {
//     //         _selectedIndex = index;
//     //       });
//     //     },
//     //     items: [
//     //       BottomNavigationBarItem(
//     //         icon: Icon(Icons.favorite),
//     //         label: "",
//     //       ),
//     //       BottomNavigationBarItem(
//     //         icon: Icon(Icons.directions_run),
//     //         label: "",
//     //       ),
//     //       BottomNavigationBarItem(
//     //         icon: Icon(Icons.restaurant),
//     //         label: "",
//     //       ),
//     //       BottomNavigationBarItem(
//     //         icon: Icon(Icons.assessment),
//     //         label: "",
//     //       ),
//     //     ],
//     //   ),
//     // );
//   }
// }
