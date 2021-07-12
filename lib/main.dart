import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_manager_app/screens/add_event_screen.dart';
import 'package:events_manager_app/screens/admin_home_screen.dart';
import 'package:events_manager_app/screens/edit_profile_screen.dart';
import 'package:events_manager_app/utils/events.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:path_provider/path_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/signup_page.dart';
import 'screens/home_screen.dart';
import 'screens/login_page.dart';
import 'screens/todo_screen.dart';
import 'screens/edit_event_screen.dart';
import 'screens/loading_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  email = prefs.getString('email');
  validateAdmin(email);
  await getProfileImage();
  runApp(
      RestartWidget(
        child: Phoenix(
            child: MyApp(),
        ),
      ),
  );
}

void validateAdmin(var check){
  FirebaseFirestore.instance
      .collection('admins')
      .doc(check)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if(documentSnapshot.exists)
      isAdmin = true;
    else
      isAdmin = false;
  });
}

Future<void> getProfileImage() async{
  if(email == null){
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    profileImagePath = '${appDocDirectory.path}/profile.png';
    File pathProfileImage = File(profileImagePath);
    try{
      await FirebaseStorage.instance
          .ref('profile.png')
          .writeToFile(pathProfileImage);
    } on FirebaseException catch (err){
      print(err);
    }
  }
  else{
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    profileImagePath = '${appDocDirectory.path}/profile.png';
    File pathProfileImage = File(profileImagePath);
    try{
      await FirebaseStorage.instance
          .ref('$email/profile.png')
          .writeToFile(pathProfileImage);
    } on FirebaseException catch (err){
      print(err);
    }
  }
  print(profileImagePath);
}

var email;
String profileImagePath = '';
bool isAdmin = false;

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events Manager App',
      routes: {
        WelcomeScreen.id : (context) => WelcomeScreen(),
        SignUpPage.id : (context) => SignUpPage(),
        LoginPage.id : (context) => LoginPage(),
        AdminHomeScreen.id : (context) => AdminHomeScreen(),
        HomeScreen.id : (context) => HomeScreen(),
        ToDoScreen.id : (context) => ToDoScreen(),
        AddEventScreen.id : (context) => AddEventScreen(),
        EditEventScreen.id : (context) => EditEventScreen(),
        EditProfileScreen.id : (context) => EditProfileScreen(),
        LoadingScreen.id : (context) => LoadingScreen(),
      },
      //initialRoute: email != null ? HomeScreen.id : WelcomeScreen.id,
      home: email != null ? LoadingScreen(): WelcomeScreen(),
    );
  }
}

class RestartWidget extends StatefulWidget {
  RestartWidget({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
