import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class DataModel extends ChangeNotifier {}

class ExerciseData extends ChangeNotifier {
  DateTime _date;
  int _time = 0; // 0으로 초기화할 것
  final int _key;

  DateTime get date => _date;
  int get time => _time;
  int get key => _key;

  void addTime(int t) {
    _time += t;
    notifyListeners();
  }

  set date(DateTime date) {
    _date = date;
  }

  ExerciseData(this._date, this._time, this._key);
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
  DateTime _date;
  int _type; // 0 = 아침 1 = 점심 2 = 저녁 3 = 간식
  String _food;
  int _score; // 0 = bad 1 = soso 2 = good

  DateTime get date => _date;
  int get type => _type;
  String get food => _food;
  int get score => _score;

  set date(DateTime date) {
    _date = date;
  }

  set type(int num) {
    _type = num;
  }

  set food(String str) {
    _food = str;
  }

  set score(int num) {
    _score = num;
  }

  DietData(this._date, this._type, this._food, this._score);
}
