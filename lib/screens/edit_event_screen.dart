import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:events_manager_app/screens/loading_screen.dart';
import 'package:events_manager_app/utils/alert.dart';
import 'package:events_manager_app/utils/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class EditEventScreen extends StatefulWidget {
  static const String id = '/edit';

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

DateTime editEventDate = DateTime.now();
String editEventTitle = '';
String editEventUid = '';
String editEventBoard = '';
String editEventDateString = editEventDate.toString();

class _EditEventScreenState extends State<EditEventScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.red,
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
                      'Manage Event',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextField(
                  onChanged: (val){
                    editEventTitle=val;
                  },
                  decoration: InputDecoration(
                    hintText: 'Event title: '+editEventTitle,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(
                          // color: Colors.redAccent,
                          width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(
                          // color: Colors.redAccent,
                          width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
                DateTimePicker(
                  type: DateTimePickerType.date,
                  firstDate: kFirstDay,
                  lastDate: kLastDay,
                  initialDate: editEventDate,
                  icon: Icon(
                      Icons.event
                  ),
                  dateLabelText: editEventDateString.substring(0, 10),
                  onChanged: (val){
                    editEventDateString = val;
                    print(editEventDateString);
                  },
                ),
                DropdownButton(
                  // dropdownColor: Colors.red,
                  hint: Text(
                    'Board: ',
                  ),
                  value: editEventBoard,
                  onChanged: (String? val){
                    setState(() {
                      editEventBoard = val!;
                    });
                  },
                  items: <String>['Technical Board', 'Cultural Board', 'Sports Board', 'Welfare Board']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () async{
                    int date = int.parse(editEventDateString[9]) + (int.parse(editEventDateString[8]) * 10);
                    int month = int.parse(editEventDateString[6]) + (int.parse(editEventDateString[5]) * 10);
                    int year = int.parse(editEventDateString[3]) + (int.parse(editEventDateString[2]) * 10) + (int.parse(editEventDateString[1]) * 100) + (int.parse(editEventDateString[0]) * 1000);
                    editEventDate = DateTime(year, month, date);
                    print(editEventDateString+editEventTitle);
                    FirebaseFirestore.instance.collection('events')
                      .doc(editEventUid)
                      .delete()
                        .then((value) {
                          FirebaseFirestore.instance.collection('events')
                            .doc(editEventDateString+editEventTitle)
                            .set({
                              'date' : date,
                              'month' : month,
                              'year' : year,
                              'title' : editEventTitle,
                              'board' : editEventBoard,
                          })
                          .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(mySnackBar(context, 'Edit successful. Restart app to see changes.'));
                            Navigator.pushNamed(context, LoadingScreen.id);
                          })
                          .catchError((err) {
                            showAlert(context, err.toString());
                          });
                        })
                        .catchError((err) {
                          showAlert(context, err);
                        });
                  },
                  style: ButtonStyle(
                    // backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: Text(
                      'Edit Event'
                  ),
                ),
                ElevatedButton(
                  onPressed: () async{
                    FirebaseFirestore.instance.collection('events')
                        .doc(editEventUid)
                        .delete()
                        .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(mySnackBar(context, 'Event deleted. Restart app to see changes.'));
                          Navigator.pushNamed(context, LoadingScreen.id);
                      })
                        .catchError((err) {
                          showAlert(context, err);
                      });
                  },
                  style: ButtonStyle(
                    // backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: Text(
                      'Delete Event'
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );;
  }
}
