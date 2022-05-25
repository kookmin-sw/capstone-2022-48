import 'package:flutter/material.dart';
import 'package:capstone_2022_48/navigator/sidemenu.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        children: <Widget>[
          SizedBox(height: 30.0),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: Icon(Icons.people),
                    title: Text('성별'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.height),
                    title: Text('키'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.monitor_weight),
                    title: Text('몸무게'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
