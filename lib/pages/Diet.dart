//ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:capstone_2022_48/model/DataModel.dart';
// import 'package:sqflite/sqflite.dart';

import '../Model/Food.dart';
import 'HomeCalendar.dart';
import 'package:dio/dio.dart';

import 'package:capstone_2022_48/Model/FoodRepository.dart';
import 'package:capstone_2022_48/Model/Food.dart';

import 'package:capstone_2022_48/navigator/sidemenu.dart';

class Diet extends StatefulWidget {
  // final Future<Database> db;
  const Diet({Key? key}) : super(key: key);

  @override
  State<Diet> createState() => _DietState();
}

class _DietState extends State<Diet> {
  @override
  void initState() {
    super.initState();
    // fetchData();
    // test();
  }

  // Future<double> test(String food) async {
  Future<List<num>> test(String food) async {
    // String food = '고등어구이';
    final response = await Dio().get(
        'http://openapi.foodsafetykorea.go.kr/api/de8e03e4d4884e019688/I2790/json/1/10/' +
            'DESC_KOR=' +
            food);
    var foodData = response.data['I2790']['row']
        .map(
          (item) => FoodModel.fromJson(json: item),
        )
        .toList();
    // var foodData = response.data['I2790']['row'].map();

    // print(response);
    // List<FoodModel> list = response.data['I2790']['row']
    //     .map<FoodModel>((item) => FoodModel.fromJson(json: item));
    // List<FoodModel> list = <FoodModel>[];
    // print(response.data['I2790']['row']
    // .map<FoodModel>((item) => FoodModel.fromJson(json: item)));
    // ));

    var s = food;
    int n = 0;
    FoodModel k;
    for (int i = 0; i < foodData.length; i++) {
      if (foodData[i].DESC_KOR == s) {
        n = i;
        // k = foodData[i];
        break;
      }
    }

    List<num> list = List<num>.filled(10, 0.0);

    // print(foodData[n].DESC_KOR);
    // print(foodData[n].NUTR_CONT1);
    // if (foodData[n].NUTR_CONT1 != null) {
    //   return foodData[n].NUTR_CONT1;
    // } else {
    //   return 0;
    // }
    // return foodData[n].NUTR_CONT1;

    list[0] = foodData[n].NUTR_CONT1; // kcal
    list[1] = foodData[n].NUTR_CONT2; // tan
    list[2] = foodData[n].NUTR_CONT3; // dan
    list[3] = foodData[n].NUTR_CONT4; // zi
    list[4] = foodData[n].NUTR_CONT5; // sugar

    print(foodData[n].NUTR_CONT2);
    print(foodData[n].NUTR_CONT3);
    print(foodData[n].NUTR_CONT4);
    print(foodData[n].NUTR_CONT5);

    return list;

    // print(foodData[1].DESC_KOR);
  }

  // fetchData() async {
  //   final foodModels = await FoodRepository.fetchData('고등어구이');
  //   print(foodModels);
  //   //   // var name = '고등어구이';
  //   //   // final response = await Dio().get(
  //   //   //     'http://openapi.foodsafetykorea.go.kr/api/de8e03e4d4884e019688/I2790/json/1/10/' +
  //   //   //         'DESC_KOR=' +
  //   //   //         '고등어구이');

  //   //   // print(response);

  //   //   // // List<FoodModel> list = <FoodModel>[];
  //   //   // List<FoodModel> list = response.data['I2790']['row']
  //   //   //     .map<FoodModel>((item) => FoodModel.fromJson(json: item))
  //   //   //     .toList();
  //   //   // if (response.data != null) {
  //   //   //   list = response.data['I2790']['row']
  //   //   //       .map(
  //   //   //         (item) => FoodModel.fromJson(json: item),
  //   //   //       )
  //   //   //       .toList();
  //   //   // }
  //   //   // return list;
  //   // }
  //   // fetchData() async {
  //   //   var str;
  //   //   str = '고등어구이';
  //   //   final response = await Dio().get(
  //   //       'http://openapi.foodsafetykorea.go.kr/api/de8e03e4d4884e019688/I2790/json/1/10/' +
  //   //           'DESC_KOR=' +
  //   //           str);

  //   //   // print(response.data.);
  //   //   print(
  //   //     response.data['I2790']['row'].map(
  //   //       (item) => FoodModel.fromJson(json: item),
  //   //     ),
  //   //   );
  // }

  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference dietdatas =
      FirebaseFirestore.instance.collection('DietDataCollection');

  Future<void> addFoodData(List<num> list) {
    // Call the user's CollectionReference to add a new user
    return dietdatas
        .add({
          // 'date': DateTime.now().toUtc().add(Duration(hours: -9)),
          'date': DateTime.now(),
          'cal': list[0],
          'tan': list[1],
          'dan': list[2],
          'zi': list[3],
          'sugar': list[4],
          // 'date': date,
          // 'cal': diet_cal,
          // 'tan': diet_tan,
          // 'dan': diet_dan,
          // 'zi': diet_zi,
          // 'sugar': diet_sugar,
        })
        .then((value) => print("add food"))
        .catchError((error) => print("Failed to add food: $error"));
  }

  // late DietData _dietData;
  late List<DietData> _dietDataList;

  DateTime date = DateTime.now();
  // late int diet_type = 0; // 1:아침 2:점심 3:저녁 4:간식
  // late String diet_food;
  // late int diet_score = 0; // 1:bad 2:soso 3:good
  int diet_type = 0; // 1:아침 2:점심 3:저녁 4:간식
  late String diet_food;
  int diet_score = 0; // 1:bad 2:soso 3:good
  num diet_cal = 0;
  num diet_tan = 0;
  num diet_dan = 0;
  num diet_zi = 0;
  num diet_sugar = 0;

  int value = 0;
  var _selected = null;
  String inputs = '';

  final fieldText = TextEditingController();

  Widget CustomRadio(String text, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          value = index;
          diet_type = index;
        });
      },
      child: Text(text),
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(70, 50),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        primary:
            (value == index) ? Color.fromARGB(255, 61, 67, 114) : Colors.grey,
        elevation: 0.0,
        textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pretendard'),
      ),
    );
  }

  Widget _icon(int index, IconData icon) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: InkResponse(
        child: Column(
          children: [
            Icon(
              icon,
              color: _selected == index
                  ? Color.fromARGB(255, 61, 67, 114)
                  : Colors.grey,
              size: 60.0,
            ),
          ],
        ),
        onTap: () => setState(
          () {
            _selected = index;
            diet_score = index;
          },
        ),
      ),
    );
  }

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            // body: SafeArea(
            //   child: Center(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Container(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       CustomRadio("아침", 1),
              //       SizedBox(width: 10),
              //       CustomRadio("점심", 2),
              //       SizedBox(width: 10),
              //       CustomRadio("저녁", 3),
              //       SizedBox(width: 10),
              //       CustomRadio("간식", 4),
              //     ],
              //   ),
              // ),
              Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextField(
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pretendard'),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '식단을 입력해주세요.',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 61, 67, 114)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 61, 67, 114)),
                          ),
                        ),
                        controller: fieldText,
                        onChanged: (String str) {
                          setState(() {
                            inputs = str;
                            diet_food = str;
                          });
                        },
                      ),
                      padding: EdgeInsets.only(top: 30, bottom: 20),
                      width: 200,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     _icon(
                    //       3,
                    //       Icons.sentiment_very_satisfied,
                    //     ),
                    //     SizedBox(width: 5),
                    //     _icon(
                    //       2,
                    //       Icons.sentiment_satisfied,
                    //     ),
                    //     SizedBox(width: 5),
                    //     _icon(
                    //       1,
                    //       Icons.sentiment_very_dissatisfied,
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            // value = 0;
                            // diet_type = 0; // 1:아침 2:점심 3:저녁 4:간식
                            // diet_food = '';
                            // diet_score = 0;
                            // setState(() {
                            //   diet_type = 0; // 1:아침 2:점심 3:저녁 4:간식
                            //   diet_food = '';
                            //   diet_score = 0; // 1:bad 2:soso 3:good
                            // });
                            setState(() {
                              value = 0;
                              _selected = null;
                              inputs = '';
                              fieldText.clear();
                            });
                          },
                          label: Text('리셋'),
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(100, 45),
                            primary: Color(0xffbbbbbb),
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Pretendard',
                                fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            // context
                            //     .read<DietData>()
                            //     .setDietData(date, type, food, score);
                            // if (type == 1) {
                            // } else if (type == 2) {
                            // } else if (type == 3) {
                            // } else if (type == 4) {}
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => TodayDiet(
                            //             diet_type: diet_type,
                            //             diet_food: diet_food,
                            //             diet_score: diet_score)));
                            // builder: (context) => Whatday(date, diet_type, diet_food, diet_score));
                            // test(diet_food);
                            // context
                            //     .read<DietData>()
                            //     .addCalories(test(diet_food));
                            // double dou = await test(diet_food!);
                            // context.read<DietData>().addCalories(dou);
                            late List<num> list;
                            if (await test(diet_food) != null) {
                              // dou = await test(diet_food);
                              list = await test(diet_food);
                            }
                            // context.read<DietData>().addCalories(list[0]);
                            // context.read<DietData>().addTan(list[1]);
                            // context.read<DietData>().addDan(list[2]);
                            // context.read<DietData>().addZi(list[3]);
                            // context.read<DietData>().addSugar(list[4]);
                            // diet_cal = dou.round();
                            // addFoodData();
                            addFoodData(list);
                          },
                          label: Text('추가'),
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(100, 45),
                            primary: Color(0xff19335A),
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Pretendard',
                                fontSize: 15),
                          ),
                        ),
                      ],
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ],
          ),
          // ),
        ],
      ),
      // drawer: MainDrawer(),
    );
  }
}

// class FirestoreFirstDemoState extends State<FirestoreFirstDemo> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("FirestoreFirstDemo")),
//       body: Column(
//         children: <Widget>[
//           Container(
//             height: 500,
//             child: StreamBuilder<QuerySnapshot>(
//               stream: Firestore.instance.collection("FirstDemo").snapshots(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.hasError) return Text("Error: ${snapshot.error}");
//                 switch (snapshot.connectionState) {
//                   case ConnectionState.waiting:
//                     return Text("Loading...");
//                   default:
//                     return ListView(
//                       children: snapshot.data.documents.map((DocumentSnapshot document) {
//                         Timestamp tt = document["datetime"];
//                         DateTime dt = DateTime.fromMicrosecondsSinceEpoch(
//                             tt.microsecondsSinceEpoch);

//                         return Card(
//                           elevation: 2,
//                           child: Container(
//                             padding: const EdgeInsets.all(8),
//                             child: Column(
//                               children: <Widget>[
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: <Widget>[
//                                     Text(
//                                       document["name"],
//                                       style: TextStyle(
//                                         color: Colors.blueGrey,
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Text(
//                                       dt.toString(),
//                                       style: TextStyle(color: Colors.grey[600]),
//                                     )
//                                   ],
//                                 ),
//                                 Container(
//                                   alignment: Alignment.centerLeft,
//                                   child: Text(
//                                     document["description"],
//                                     style: TextStyle(color: Colors.black54),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     );
//                 }
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }