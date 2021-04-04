import 'package:flutter/material.dart';

class AlertBoxes{

  Future<Widget> loadingAlertBox(context){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Please Wat..'),
            content: Container(
              height: 50.0,
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal)
                ),
              ),
            ),
          );
        });
  }
}