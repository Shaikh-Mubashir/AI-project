import 'package:flutter/material.dart';

class AlertBoxes {
  Future<Widget> loadingAlertBox(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please Wait..'),
            content: Container(
              height: 50.0,
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal)),
              ),
            ),
          );
        });
  }

  Future<Widget> simpleAlertBox(context, String title, String body) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Container(
                height: 50.0,
                child: Text(
                  body,
                )),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.teal),
                ),
              )
            ],
          );
        });
  }
}
