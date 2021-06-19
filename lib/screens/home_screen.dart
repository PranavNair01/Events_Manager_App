import 'package:events_manager_app/main.dart';
import 'package:events_manager_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String id = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;

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
    );
  }
}
