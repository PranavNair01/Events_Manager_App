import 'package:events_manager_app/main.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

dynamic showAlert(BuildContext context, String message) {
  return Alert(
    context: context,
    type: AlertType.warning,
    title: "ALERT",
    desc: message,
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
}

SnackBar mySnackBar(BuildContext context, String message) {
  return SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          style: TextStyle(
            color: isDark ? Colors.red : Colors.white,
          ),
        ),
      ],
    ),
    backgroundColor: isDark ? Colors.black : Colors.red,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    duration: Duration(milliseconds: 1500),
    behavior: SnackBarBehavior.floating,
    // width: MediaQuery.of(context).size.width*0.7,
    );
}