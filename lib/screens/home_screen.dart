import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_manager_app/utils/events.dart';
import 'package:events_manager_app/main.dart';
import 'package:events_manager_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  static const String id = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final ValueNotifier<List<Event>> _selectedEvents;



  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(getEventsForDay(_selectedDay!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Home',
        ),
        leading: IconButton(
          icon: Icon(
            Icons.power_settings_new,
            color: Colors.white,
          ),
          onPressed: () async{
            auth.signOut();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
            email = null;
            Navigator.popAndPushNamed(context, WelcomeScreen.id);
          },
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day){
              // print(day);
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focussedDay){
              print(selectedDay);
              print(focussedDay);
              if(!isSameDay(_selectedDay, selectedDay)){
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focussedDay;
                });
              }
            },
            onFormatChanged: (format){
              if(_calendarFormat != format){
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focussedDay){
              // print(focussedDay);
              _focusedDay = focussedDay;
            },
            eventLoader: getEventsForDay,
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index].name}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
