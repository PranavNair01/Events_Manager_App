import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/welcome_screen.dart';
import 'screens/signup_page.dart';
import 'screens/home_screen.dart';
import 'screens/login_page.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

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
      initialRoute: WelcomeScreen.id,
    );
  }
}
