import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event{
  String name;
  String board;
  String description;
  String date;
  String month;
  String year;

  Event(this.name, this.board, this.description, this.date, this.month, this.year);
}

List<Event> getEventsForDay(DateTime day){
  List<Event> events = [];
  FirebaseFirestore.instance.collection('events').get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      if((doc['date'] == day.day.toString())
          && (doc['month'] == day.month.toString())
          && (doc['year'] == day.year.toString())){
        events.add(
            Event(doc['name'], doc['board'], doc['description'], doc['date'], doc['month'], doc['year'])
        );
      }
    });
  });
  return events;
}