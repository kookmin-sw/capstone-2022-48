import 'package:flutter/material.dart';

class DataModel extends ChangeNotifier {}

class ExerciseData {
  DateTime _date;
  int _time; // 0으로 초기화할 것
  final int key;

  ExerciseData(this.date, this.time, this.key);
}

class ExerciseDataCode {
  // Map<int, String> exerciseCode = Map();
  // exerciseCode[1] = '조깅';

  Map<int, String> exerciseCode = {
    1: '조깅',
    2: '요가',
    3: '자전거',
  };
}

class DietData {
  DateTime date;
  int type; // 0 = 아침 1 = 점심 2 = 저녁 3 = 간식
  String food;
  int score; // 0 = bad 1 = soso 2 = good

  DietData(this.date, this.type, this.food, this.score);
}
