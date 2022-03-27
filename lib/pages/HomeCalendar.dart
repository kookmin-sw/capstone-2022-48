import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:capstone_2022_48/Utilities.dart';

class HomeCalendar extends StatefulWidget {
  const HomeCalendar({Key? key}) : super(key: key);

  @override
  _HomeCalendarState createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  CalendarFormat _calendarFormat = CalendarFormat.month;

  // CalendarFormat format = CalendarFormat.month;
  // DateTime selectedDay = DateTime.now();
  // DateTime focusedDay = DateTime.now();
  //
  // DateTime? rangeStart;
  // DateTime? rangeEnd;
  // late final ValueNotifier<List<Event>> selectedEvents;
  // RangeSelectionMode rangeSelectionMode = RangeSelectionMode
  //     .toggledOff; // Can be toggled on/off by longpressing a date
  //
  // void onDaySelected(selectedDay, focusedDay) {
  //   if (!isSameDay(selectedDay, selectedDay)) {
  //     setState(() {
  //       selectedDay = selectedDay;
  //       focusedDay = focusedDay;
  //       rangeStart = null; // Important to clean those
  //       rangeEnd = null;
  //       rangeSelectionMode = RangeSelectionMode.toggledOff;
  //     });
  //
  //     selectedEvents.value = getEventsForDay(selectedDay);
  //   }
  // }
  //
  // List<Event> getEventsForDay(DateTime day) {
  //   // Implementation example
  //   return kEvents[day] ?? [];
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 120,
              color: Colors.yellow,
              child: Text(
                'view1',
                style: TextStyle(
                    fontFamily: 'Pretendard', fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: TableCalendar(
                locale: 'ko-KR',

                focusedDay: DateTime.now(),
                firstDay: DateTime(2020),
                lastDay: DateTime(2030),

                selectedDayPredicate: (DateTime date) {
                  return isSameDay(_selectedDay, date);
                },
                onDaySelected: (selectDay, focusDay) {
                  setState(() {
                    _selectedDay = selectDay;
                    _focusedDay = focusDay;
                  });
                },

                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },

                startingDayOfWeek: StartingDayOfWeek.monday,
                // daysOfWeekVisible: true,
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },

                // header style
                headerVisible: true,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  // centerHeaderTitle: true,
                  leftChevronIcon: Icon(Icons.arrow_back_ios_rounded),
                  rightChevronIcon: Icon(Icons.arrow_forward_ios_rounded),
                  // titleTextStyle: const TextStyle(fontSize: 15.0),
                ),
                daysOfWeekHeight: 20,

                // calendar style
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(color: Colors.grey),
                  weekendTextStyle: TextStyle(color: Colors.grey),
                  isTodayHighlighted: true,

                  // selectedDecoration: BoxDecoration(
                  //   color: Colors.blue,
                  //   shape: BoxShape.circle,
                  // ),
                  // selectedTextStyle: TextStyle(color: Colors.white),

                  // today style
                  todayDecoration: BoxDecoration(
                      color: Color(0xffc1c1c1), shape: BoxShape.circle),
                  // color: Color(0xff6fa8dc), shape: BoxShape.circle),
                  todayTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                      fontSize: 16),

                  // selected day style
                  selectedDecoration: BoxDecoration(
                    color: Color(0xff6fa8dc),
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                      fontSize: 16),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                    child: Text(
                      '운동시간 기록 view2',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.bold),
                    )),
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                  child: Text(
                    '식단기록 view3',
                    style: TextStyle(
                        fontFamily: 'Pretendard', fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
