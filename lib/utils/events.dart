import 'dart:collection';
import 'package:events_manager_app/main.dart';
import 'package:events_manager_app/utils/todo.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_manager_app/screens/loading_screen.dart';

/// Example event class.
class Event {
  final String title;
  final String board;
  final String uid;

  const Event({required this.title, required this.board, required this.uid});

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(kEventSource);

Map<DateTime, List<Event>> kEventSource = {};

Future<void> loadEvents() async{
  kEventSource = {};
  myToDoEvents = [];
  CollectionReference _collectionReference = FirebaseFirestore.instance.collection('events');
  QuerySnapshot querySnapshot = await _collectionReference.get();

  allEvents = querySnapshot.docs.map((doc) => doc.data()).toList();

  for(var entry in allEvents){
    DateTime thisDate = DateTime(entry['year'], entry['month'], entry['date']);
    String thisTitle = entry['title'];
    String thisBoard = entry['board'];
    String dateString = (entry['date'] < 10) ? '0'+entry['date'].toString() : entry['date'].toString();
    String monthString = (entry['month'] < 10) ? '0'+entry['month'].toString() : entry['month'].toString();
    String yearString = entry['year'].toString();
    String thisUid = yearString+'-'+monthString+'-'+dateString+thisTitle;
    if(kEventSource.containsKey(thisDate))
      kEventSource[thisDate]!.add(Event(title: thisTitle, board: thisBoard, uid: thisUid));
    else
      kEventSource[thisDate] = [Event(title: thisTitle, board: thisBoard, uid: thisUid)];
    for(var uid in myToDo){
      if(uid == thisUid)
        myToDoEvents.add(Event(title: thisTitle, board: thisBoard, uid: thisUid));
    }
  }
  print('Updated');
}


int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
