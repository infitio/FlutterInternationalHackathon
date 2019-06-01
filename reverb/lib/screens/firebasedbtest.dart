import 'package:flutter/material.dart';
import 'package:adhara/adhara.dart';
import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDBTest extends AdharaStatefulWidget{
  @override
  _FirebaseDBTestState createState() => _FirebaseDBTestState();
}

class _FirebaseDBTestState extends AdharaState<FirebaseDBTest>{

  addToDb(){
    /*final FirebaseApp app = await FirebaseApp.configure(
      name: 'db2',
      options: Platform.isIOS
          ? const FirebaseOptions(
        googleAppID: '1:683606981936:android:a3d41c0d821ab1b8',
        gcmSenderID: '683606981936',
        databaseURL: 'https://reverb-242404.firebaseio.com/',
      )
          : const FirebaseOptions(
        googleAppID: '1:683606981936:android:a3d41c0d821ab1b8',
        apiKey: 'AIzaSyBkS0GZeVKPk0ks8cBpQjLpMdbU5r_Wo2o',
        databaseURL: 'https://reverb-242404.firebaseio.com/',
      ),
    );*/
    FirebaseDatabase.instance.reference().child('recent').child('id').set({
      'title': 'Realtime db rocks',
      'created_at': DateTime.now().toIso8601String()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Text("testing firebase DB"),
            FlatButton(
              child: Text("add"),
              onPressed: addToDb,
            )
          ],
        ),
      ),
    );
  }

  String get tag => "FirebaseDBTest";
}