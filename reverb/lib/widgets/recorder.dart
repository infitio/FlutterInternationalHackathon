import 'dart:async';
import 'package:flutter/material.dart';
import 'package:adhara/adhara.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class Recorder extends AdharaStatefulWidget{
  @override
  _RecorderState createState() => _RecorderState();
}

class _RecorderState extends AdharaState<Recorder>{

  String get tag => "Recorder";
  FlutterSound flutterSound;
  var _recorderSubscription;
  var recording = false;

  @override
  void initState() {
    flutterSound = new FlutterSound();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(flutterSound);
    return (flutterSound == null) ? Container(): IconButton(
        icon: recording? Icon(Icons.stop): Icon(Icons.mic),
        onPressed: recording? stopRecorder: startRecorder
    );
  }

  startRecorder() async{
    final dir = await getTemporaryDirectory();
    print("dir $dir");
    String path = await flutterSound.startRecorder(dir.toString()+"/sd5.mp4");
    print('startRecorder: $path');

    _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
      DateTime date = new DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt());
//      String txt = DateFormat('mm:ss:SS', 'en_US').format(date);
    });
    setState((){
      recording = true;
    });
  }

  stopRecorder() async{
    String result = await flutterSound.stopRecorder();
    print('stopRecorder: $result');

    if (_recorderSubscription != null) {
      _recorderSubscription.cancel();
      _recorderSubscription = null;
    }
    setState((){
      recording = false;
    });
  }
}