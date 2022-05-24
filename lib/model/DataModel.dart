import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class DataModel extends ChangeNotifier {

// }

class ExerciseData extends ChangeNotifier {
  late DateTime _date;
  int _time = 0; // 0으로 초기화할 것
  late final int _key;

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

  // ExerciseData(this._date, this._time, this._key);
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

class DietData extends ChangeNotifier {
  late DateTime _date;
  late int _type; // 0 = 아침 1 = 점심 2 = 저녁 3 = 간식
  late String _food;
  late int _score; // 0 = bad 1 = soso 2 = good
  double _calories = 0;

  // final _iconList = {
  //   1: Icon(Icons.sentiment_very_satisfied, color: Color(0xffFFCD00)),
  //   2: Icon(Icons.sentiment_satisfied, color: Color(0xff4675C0)),
  //   3: Icon(Icons.mood_bad, color: Color(0xffB8BFD6)),
  //   4: Icon(Icons.sentiment_satisfied, color: Color(0xffbbbbbb)),
  // };

  DateTime get date => _date;
  int get type => _type;
  String get food => _food;
  int get score => _score;
  double get calories => _calories;
  // Map<int, Icon> get iconList => _iconList;

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

  // void setDietData(DateTime date, int type, String food, int score) {
  //   _date = date;
  //   _type = type;
  //   _food = food;
  //   _score = score;
  // }

  void addCalories(double num) {
    _calories += num;
    notifyListeners();
  }
}

class StepData extends ChangeNotifier {
  int _steps = 0;

  int get steps => _steps;
}

class UserData extends ChangeNotifier {
  late String _email;
  late int gender;
  late int age;
  late double cm;
  late double kg;
  late int usual;

  late double bmi;
  late double bmr; // 기초대사량
  late double amr; // 활동대사량
  late int suggestedKcal; // 권장or목표 칼로리 섭취량

}
