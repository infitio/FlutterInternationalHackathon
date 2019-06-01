import 'package:flutter/material.dart';
import 'package:adhara/adhara.dart';
import 'firebasedbtest.dart';

class ChatView extends AdharaStatefulWidget{
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends AdharaState<ChatView>{
  @override
  Widget build(BuildContext context) {
    return FirebaseDBTest();
  }

  String get tag => "ChatView";
}