import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_2022_48/model/TimerModel.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  var timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Provider.of<TimerProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: exerciseScreenBody(),
    );
  }

  Widget exerciseScreenBody() {
    return Container(child: Consumer<TimerProvider>(
      builder: (context, timeprovider, widget) {
        return Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Center(
              child: Text(
                '${timer.hour} : ' + '${timer.minute} : ' + '${timer.seconds} ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                (timer.startEnable)
                    ? ElevatedButton(
                        onPressed: timer.startTimer,
                        child: Text('Start'),
                      )
                    : ElevatedButton(
                        onPressed: null,
                        child: Text('Start'),
                      ),
                (timer.stopEnable)
                    ? ElevatedButton(
                        onPressed: timer.stopTimer,
                        child: Text('Stop'),
                      )
                    : ElevatedButton(
                        onPressed: null,
                        child: Text('Stop'),
                      ),
                (timer.continueEnable)
                    ? ElevatedButton(
                        onPressed: timer.continueTimer,
                        child: Text('Continue'),
                      )
                    : ElevatedButton(
                        onPressed: null,
                        child: Text('Continue'),
                      ),
              ],
            ),
          ],
        );
      },
    ));
  }
}
