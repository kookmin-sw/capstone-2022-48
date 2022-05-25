import 'package:capstone_2022_48/pages/HomeCalendar.dart';
import 'package:flutter/material.dart';
import 'package:capstone_2022_48/navigator/tabspage.dart';
import 'package:capstone_2022_48/navigator/profile.dart';
import 'package:capstone_2022_48/pages/Signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SideMenu extends StatefulWidget {
  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 300,
            child: DrawerHeader(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 150,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ]),
            ),
          ),
          ListTile(
              leading: Icon(Icons.home),
              title: Text(
                'Home',
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              onTap: () => {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => TabsPage(selectedIndex: 0)),
                      ),
                    ),
                  }),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(
              'Profile',
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            onTap: () => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: ((context) => Profile()),
                ),
              ),
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(
              'Log In',
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            onTap: () => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: ((context) => SignInScreen()),
                ),
              ),
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              'Log Out',
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            onTap: () => {
              flutterToast(),
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => HomeCalendar()),
                  ),
                );
              })
            },
          ),
        ],
      ),
    );
  }
}

void flutterToast() {
  Fluttertoast.showToast(
      msg: '로그아웃 됐습니다.',
      gravity: ToastGravity.BOTTOM, // 토스트 위치
      backgroundColor: Colors.grey,
      fontSize: 15.0,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT);
}
