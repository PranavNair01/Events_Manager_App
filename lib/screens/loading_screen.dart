import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_manager_app/main.dart';
import 'package:events_manager_app/screens/admin_home_screen.dart';
import 'package:events_manager_app/screens/home_screen.dart';
import 'package:events_manager_app/utils/events.dart';
import 'package:events_manager_app/utils/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  static const String id = '/loading';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

var allEvents;

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    super.initState();
    loader();
  }

  void loader() async{
      await loadToDo();
      await loadEvents();
      isAdmin ? Navigator.pushNamed(context, AdminHomeScreen.id) : Navigator.pushNamed(context, HomeScreen.id);

    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SpinKitDoubleBounce(
        color: Colors.redAccent,
      ),
    );
  }
}
