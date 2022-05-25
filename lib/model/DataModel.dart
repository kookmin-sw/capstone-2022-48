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
  double _tan = 0;
  double _dan = 0;
  double _zi = 0;
  double _sugar = 0;

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

  // Map<int, Icon> get iconList => _iconList;
  double get calories => _calories;
  double get tan => _tan;
  double get dan => _dan;
  double get zi => _zi;
  double get sugar => _sugar;

  // set date(DateTime date) {
  //   _date = date;
  // }

  // set type(int num) {
  //   _type = num;
  // }

  // set food(String str) {
  //   _food = str;
  // }

  // set score(int num) {
  //   _score = num;
  // }

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

  void addTan(double num) {
    _tan += num;
    notifyListeners();
  }

  void addDan(double num) {
    _dan += num;
    notifyListeners();
  }

  void addZi(double num) {
    _zi += num;
    notifyListeners();
  }

  void addSugar(double num) {
    _sugar += num;
    notifyListeners();
  }
}

class StepData extends ChangeNotifier {
  int _steps = 0;

  int get steps => _steps;
}

class UserData extends ChangeNotifier {
  late String _email;
  late bool _gender; // 0(false)남 1(true)여
  late int _age;
  late double _cm;
  late double _kg;
  late int _usual;

  late double _bmi;
  late double _bmr; // 기초대사량
  late double _amr; // 활동대사량
  late int _suggestedKcal; // 권장or목표 칼로리 섭취량

  String get email => _email;
  bool get gender => _gender;
  int get age => _age;
  double get cm => _cm;
  double get kg => _kg;
  int get usual => _usual;

  double get bmi => _bmi;
  double get bmr => _bmr;
  double get amr => _amr;
  int get suggestedKcal => _suggestedKcal;

  void setBMI() {
    _bmi = cm * 0.01 * kg * kg;
    notifyListeners();
  }

  void setBMR() {
    if (gender == false) {
      _bmr = 66.47 + (13.75 * kg) + (5 * cm) - (6.76 * age);
    } else if (gender == true) {
      _bmr = 655.1 + (9.56 * kg) + (1.85 * cm) - (4.68 * age);
    }
    notifyListeners();
  }

  void setAMR() {
    final pounds = kg * 2.2;

    if (usual == 1) {
      _amr = pounds * 13;
    } else if (usual == 2) {
      _amr = pounds * 14;
    } else if (usual == 3) {
      _amr = pounds * 15;
    } else if (usual == 4) {
      _amr = pounds * 16;
    } else if (usual == 5) {
      _amr = pounds * 17;
    }
    notifyListeners();
  }

  void setSuggestedKcal(bool b, int n) {
    final sug = kg.round() * 24;

    if (b == true) {
      // 목표
      _suggestedKcal = n;
    } else {
      // 권장
      if (usual == 1) {
        _suggestedKcal = sug * 13;
      } else if (usual == 2) {
        _suggestedKcal = sug * 14;
      } else if (usual == 3) {
        _suggestedKcal = sug * 15;
      } else if (usual == 4) {
        _suggestedKcal = sug * 16;
      } else if (usual == 5) {
        _suggestedKcal = sug * 17;
      }
    }
  }
}
