import 'package:flutter/material.dart';
import 'package:capstone_2022_48/pages/Signin_screen.dart';
import 'package:capstone_2022_48/pages/HomeCalendar.dart';
import 'package:capstone_2022_48/pages/profile_screen.dart';
import 'package:capstone_2022_48/main.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 70,
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 10),
                width: 80,
                height: 80,
                child: Image.asset('assets/images/default-user.png'),
              ),
            ],
          ),
          SizedBox(height: 70),
          ListTile(
            onTap: () => Navigator.pushReplacementNamed(
              context,
              HomeCalendar.route,
            ),
            leading: Icon(Icons.favorite),
            title: Text(
              'Home',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          ListTile(
            onTap: () => Navigator.pushReplacementNamed(
              context,
              ProfileScreen.route,
            ),
            leading: Icon(Icons.account_circle),
            title: Text(
              'Profile',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          ListTile(
            onTap: () => Navigator.pushReplacementNamed(
              context,
              SignInScreen.route,
            ),
            leading: Icon(Icons.exit_to_app),
            title: Text(
              'Logout',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
