import 'package:events_manager_app/screens/loading_screen.dart';
import 'package:events_manager_app/utils/events.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:date_time_picker/date_time_picker.dart';

class AddEventScreen extends StatefulWidget {
  static const String id = '/add';

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {

  String eventTitle = "";
  var eventDateString;
  DateTime eventDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: (){
            Phoenix.rebirth(context);
          },
        ),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Add Event',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextField(
                  onChanged: (val){
                    eventTitle=val;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter the event title: ',
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.redAccent, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.redAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
                DateTimePicker(
                  type: DateTimePickerType.date,
                  firstDate: kFirstDay,
                  lastDate: kLastDay,
                  icon: Icon(
                    Icons.event
                  ),
                  dateLabelText: 'Date',
                  onChanged: (val){
                    eventDateString = val;
                    print(eventDateString);
                  },
                ),
                ElevatedButton(
                  onPressed: () async{
                    if(eventDateString == null){
                      print('Null event');
                    }
                    else{
                      int date = int.parse(eventDateString[9]) + (int.parse(eventDateString[8]) * 10);
                      int month = int.parse(eventDateString[6]) + (int.parse(eventDateString[5]) * 10);
                      int year = int.parse(eventDateString[3]) + (int.parse(eventDateString[2]) * 10) + (int.parse(eventDateString[1]) * 100) + (int.parse(eventDateString[0]) * 1000);
                      eventDate = DateTime(year, month, date);
                      FirebaseFirestore.instance.collection('events')
                        .doc(eventDateString+eventTitle)
                        .set({
                          'date' : date,
                          'month' : month,
                          'year' : year,
                          'title' : eventTitle
                        })
                        .then((value) {
                          Navigator.pushNamed(context, LoadingScreen.id);
                        })
                        .catchError((err) {
                          print(err);
                        });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: Text(
                      'Add Event'
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
