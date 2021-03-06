import 'package:capstone_2022_48/pages/MainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:capstone_2022_48/reusable_widgets/reusable_widget.dart';
import 'package:capstone_2022_48/pages/Signup_screen.dart';

import 'package:fluttertoast/fluttertoast.dart';

class SignInScreen extends StatefulWidget {
  // const SignInScreen({Key? key}) : super(key: key);
  // static final route = 'signin-screen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/images/logo.png",
                    width: 220, height: 250, fit: BoxFit.fill),
                SizedBox(
                  height: 30,
                ),
                reusableTextField("이메일을 입력하세요.", Icons.person_outline, false,
                    _emailTextController),
                SizedBox(height: 20),
                reusableTextField("비밀번호를 입력하세요.", Icons.lock_outline, true,
                    _passwordTextController),
                SizedBox(height: 20),
                signInSignUpButton(context, true, () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    flutterToast_true();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainScreen()));
                  });
                }),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("계정이 없으신가요? ",
            style: TextStyle(fontFamily: 'Pretendard', color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: Text(
            " Sign Up",
            style: TextStyle(
                fontFamily: 'Pretendard',
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

void flutterToast_true() {
  Fluttertoast.showToast(
      msg: '로그인 됐습니다.',
      gravity: ToastGravity.BOTTOM, // 토스트 위치
      backgroundColor: Colors.grey,
      fontSize: 15.0,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT);
}
