import 'package:events_manager_app/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:events_manager_app/screens/signup_page.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = '/welcome';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontFamily: 'Agne',
                    fontWeight: FontWeight.bold,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText('Events Manager App'), //TODO: Give good name to app
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, LoginPage.id);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),

                ),
                child: Text(
                  'Log In',
                  style: TextStyle(
                    //fontSize: 25.0,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, SignUpPage.id);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),

                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    //fontSize: 25.0,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
