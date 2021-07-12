import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_manager_app/main.dart';
import 'package:events_manager_app/screens/home_screen.dart';
import 'package:events_manager_app/screens/loading_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class SignUpPage extends StatefulWidget {
  static const String id = '/signup';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  String signUpName = '';
  String signUpEmail = '';
  String signUpPassword = '';

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val){
                    signUpName=val;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your name: ',
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
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val){
                    signUpEmail=val;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your email id: ',
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
                TextField(
                  obscureText: true,
                  onChanged: (val){
                    signUpPassword=val;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your password: ',
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
                ElevatedButton(
                  onPressed: () async{
                    try {
                      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
                          email: signUpEmail,
                          password: signUpPassword,
                      );
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('email', signUpEmail);
                      email = signUpEmail;
                      validateAdmin(email);
                      FirebaseFirestore.instance.collection('users')
                        .doc(email)
                        .set({
                          'todo' : [],
                          'email' : email,
                          'name' : signUpName,
                        })
                        .then((value) async {
                          File file = File(profileImagePath);
                          try{
                            await FirebaseStorage.instance
                                .ref('$email/profile.png')
                                .putFile(file);
                          } on FirebaseException catch (err){
                            print(err);
                          }
                          Navigator.pushNamed(context, LoadingScreen.id);
                        })
                        .catchError((err) {
                          print(err);
                        });

                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: Text(
                    'Sign Up'
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
