import 'package:capstone_2022_48/pages/HomeCalendar.dart';
import 'package:flutter/material.dart';
import 'package:capstone_2022_48/navigator/sidemenu.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _selectedGender = '여성';
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffdddddd),
                ),
                child: Text(
                  '기초 대사량과 BMI 지수, 필요 섭취 칼로리량을 계산하기 위해 필요한 정보들입니다. 반드시 입력해주세요😆',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(Icons.people),
                    ),
                    TextSpan(
                      text: "    성별을 선택해주세요.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '여성',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                title: const Text(
                  '여성',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
              ListTile(
                leading: Radio<String>(
                  value: '남성',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                title: const Text(
                  '남성',
                  style: TextStyle(fontFamily: 'Pretendard'),
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                      ),
                      onSaved: (value) {},
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return '나이를 입력해주세요';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: '나이를 입력해주세요.',
                          labelText: '나이'),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                      ),
                      onSaved: (value) {},
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return '키를 입력해주세요';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          icon: Icon(Icons.height),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: '키를 입력해주세요.',
                          labelText: '키'),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                      ),
                      onSaved: (value) {},
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return '체중을 입력해주세요';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          icon: Icon(Icons.monitor_weight),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: '체중을 입력해주세요.',
                          labelText: '체중'),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 102, 160, 207),
                            textStyle: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    width: 200,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    backgroundColor:
                                        Color.fromARGB(255, 183, 179, 179),
                                    content: Text(
                                      '제출 되었습니다!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: 16,
                                          color: Colors.white),
                                    )),
                              );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeCalendar()));
                            }
                          },
                          child: Text('제출 하기')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
