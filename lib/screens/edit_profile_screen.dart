import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_manager_app/main.dart';
import 'package:events_manager_app/screens/loading_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  static const String id = '/profile';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  String editProfileName = '';
  File imageFile = File(profileImagePath);
  final ImagePicker picker = ImagePicker();

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
            Navigator.pushNamed(context, LoadingScreen.id);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Edit Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0
                ),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (val){
                  editProfileName=val;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your new profile name: ',
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
              Image(
                image: FileImage(
                  imageFile,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async{
                      try{
                        final pickedFile = await picker.getImage(
                          source: ImageSource.gallery,
                          maxHeight: 300.0,
                        );
                        setState(() {
                          imageFile = File(pickedFile!.path);
                        });
                      } catch (err){
                        print(err);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: Text(
                        'Pick from gallery'
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async{
                      try{
                        final pickedFile = await picker.getImage(
                          source: ImageSource.camera,
                          maxHeight: 300.0,
                        );
                        setState(() {
                          imageFile = File(pickedFile!.path);
                        });
                      } catch (err){
                        print(err);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: Text(
                        'Take a photo'
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
        ),
        backgroundColor: Colors.red,
        onPressed: () async{
          FirebaseFirestore.instance.collection('users')
              .doc(email)
              .update({
                'name' : editProfileName,
              })
              .then((value) async{
                try{
                  await FirebaseStorage.instance
                      .ref('$email/profile.png')
                      .putFile(imageFile);
                  Navigator.pushNamed(context, LoadingScreen.id);
                } on FirebaseException catch (err){
                  print(err);
                }
              })
              .catchError((err){
                print(err);
              });
        },
      ),
    );
  }
}
