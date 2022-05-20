//ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:capstone_2022_48/model/DataModel.dart';

class Diet extends StatefulWidget {
  const Diet({Key? key}) : super(key: key);

  @override
  State<Diet> createState() => _DietState();
}

class _DietState extends State<Diet> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late DietData _dietData;

  DateTime date = DateTime.now();
  late int type; // 1:아침 2:점심 3:저녁 4:간식
  late String food;
  late int score; // 1:bad 2:soso 3:good

  int value = 0;
  var _selected = null;
  String inputs = '';

  Widget CustomRadio(String text, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          value = index;
          type = index;
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
            score = index;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CustomRadio("아침", 1),
                  SizedBox(width: 10),
                  CustomRadio("점심", 2),
                  SizedBox(width: 10),
                  CustomRadio("저녁", 3),
                  SizedBox(width: 10),
                  CustomRadio("간식", 4),
                ]),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextField(
                        style: TextStyle(
                            fontSize: 15,
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
                        onChanged: (String str) {
                          setState(() {
                            inputs = str;
                            food = str;
                          });
                        },
                      ),
                      padding: EdgeInsets.only(top: 30, bottom: 20),
                      width: 200,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _icon(
                          3,
                          Icons.sentiment_very_satisfied,
                        ),
                        SizedBox(width: 5),
                        _icon(
                          2,
                          Icons.sentiment_satisfied,
                        ),
                        SizedBox(width: 5),
                        _icon(
                          1,
                          Icons.sentiment_very_dissatisfied,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.add),
                          onPressed: () {},
                          label: Text('삭제'),
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
                          onPressed: () {
                            context
                                .read<DietData>()
                                .setDietData(date, type, food, score);
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
        ),
      ),
    );
  }
}
