import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/welcome_screen.dart';
import 'screens/signup_page.dart';
import 'screens/home_screen.dart';
import 'screens/login_page.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  email = prefs.getString('email');
  runApp(MyApp());
}

var email;

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events Manager App',
      routes: {
        WelcomeScreen.id : (context) => WelcomeScreen(),
        SignUpPage.id : (context) => SignUpPage(),
        LoginPage.id : (context) => LoginPage(),
        HomeScreen.id : (context) => HomeScreen(),
      },
      //initialRoute: email != null ? HomeScreen.id : WelcomeScreen.id,
      home: email != null ? HomeScreen(): WelcomeScreen(),
    );
  }
}
