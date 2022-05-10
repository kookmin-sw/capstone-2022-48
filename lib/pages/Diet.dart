//ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class Diet extends StatefulWidget {
  const Diet({Key? key}) : super(key: key);

  @override
  State<Diet> createState() => _DietState();
}

class _DietState extends State<Diet> {
  bool _flag1 = true;
  bool _flag2 = true;
  bool _flag3 = true;
  bool _flag4 = true;
  String inputs = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeeeeee),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
        Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
            onPressed: () => setState(() => _flag1 = !_flag1),
            child: Text('아침'),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(80, 50),
              primary: _flag1 ? Colors.grey : Color.fromARGB(255, 61, 67, 114),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 0.0,
              textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard'),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => setState(() => _flag2 = !_flag2),
            child: Text('점심'),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(80, 50),
              primary: _flag2 ? Colors.grey : Color.fromARGB(255, 61, 67, 114),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 0.0,
              textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard'),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => setState(() => _flag3 = !_flag3),
            child: Text('저녁'),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(80, 50),
              primary: _flag3 ? Colors.grey : Color.fromARGB(255, 61, 67, 114),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 0.0,
              textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard'),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => setState(() => _flag4 = !_flag4),
            child: Text('간식'),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(80, 50),
              primary: _flag4 ? Colors.grey : Color.fromARGB(255, 61, 67, 114),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 0.0,
              textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard'),
            ),
          ),
        ])),
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
                  decoration: InputDecoration(hintText: '식단을 입력해주세요.'),
                  onChanged: (String str) {
                    setState(() => inputs = str);
                  },
                ),
                padding: EdgeInsets.only(top: 50, bottom: 50),
                width: 200,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ])),
    );
  }
}
