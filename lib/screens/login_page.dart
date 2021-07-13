import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_manager_app/main.dart';
import 'package:events_manager_app/screens/loading_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  static const String id = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String loginEmail = '';
  String loginPassword = '';

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
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
                      'Login',
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
                    loginEmail=val;
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
                TextField(
                  obscureText: true,
                  onChanged: (val){
                    loginPassword=val;
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
                ElevatedButton(
                  onPressed: () async{
                    try {
                      UserCredential userCredential = await auth.signInWithEmailAndPassword(
                          email: loginEmail,
                          password: loginPassword,
                      );
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('email', loginEmail);
                      email = loginEmail;
                      validateAdmin(email);
                      Directory appDocDirectory = await getApplicationDocumentsDirectory();
                      File pathProfileImage = File('${appDocDirectory.path}/profile.png');
                      try{
                        await FirebaseStorage.instance
                            .ref('$email/profile.png')
                            .writeToFile(pathProfileImage);
                      } on FirebaseException catch (err){
                        print(err);
                      }
                      Navigator.pushNamed(context, LoadingScreen.id);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    }
                  },
                  style: ButtonStyle(
                    // backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: Text(
                      'Login'
                  ),
                ),
                Divider(),
                SignInButton(
                  Buttons.Google,
                  onPressed: () async{
                    final GoogleSignIn googleSignIn = GoogleSignIn();
                    try{
                      await googleSignIn.signIn().
                      then((value) async{
                        final GoogleSignInAccount? googleUser = value;
                        final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
                        final credential = GoogleAuthProvider.credential(
                            accessToken: googleAuth.accessToken,
                            idToken: googleAuth.idToken
                        );
                        auth.signInWithCredential(credential);
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('email', googleUser.email);
                        email = googleUser.email;
                        validateAdmin(email);
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(email)
                            .get()
                            .then((DocumentSnapshot documentSnapshot) async {
                          if (documentSnapshot.exists) {
                            try{
                              await FirebaseStorage.instance
                                  .ref('$email/profile.png')
                                  .writeToFile(File(profileImagePath));
                            } on FirebaseException catch (err){
                              print(err);
                            }
                            Navigator.pushNamed(context, LoadingScreen.id);
                          }
                          else{
                            FirebaseFirestore.instance.collection('users')
                                .doc(email)
                                .set({
                              'todo' : [],
                              'email' : email,
                              'name' : googleUser.displayName,
                            })
                                .then((value) async{
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
                          }
                        });

                      });
                    }
                    catch (err){
                      print(err);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
