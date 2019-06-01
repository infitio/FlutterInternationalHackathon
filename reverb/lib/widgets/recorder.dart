import 'package:flutter/material.dart';
import 'package:adhara/adhara.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reverb/widgets/speech_to_text.dart';
import 'package:reverb/res/InfitioColors.dart';
import 'package:flutter_sound/android_encoder.dart';
import 'package:flutter_sound/ios_quality.dart';

typedef OnRecordedMessage(String message);


class Recorder extends AdharaStatefulWidget{

  final String language;
  final OnRecordedMessage onMessage;

  Recorder(this.language, this.onMessage);

  @override
  _RecorderState createState() => _RecorderState();
}

class _RecorderState extends AdharaState<Recorder>{

  String get tag => "Recorder";
  FlutterSound flutterSound;
  var _recorderSubscription;
  var recording = false;
  String soundFilePath;

  @override
  void initState() {
    flutterSound = new FlutterSound();
    super.initState();
  }

  @override
  fetchData(Resources r) async {
    final dir = await getApplicationDocumentsDirectory();
    print("dir ${dir.path}");
    soundFilePath = dir.path+"/sd5.amr";
    print("path $soundFilePath");
  }

  @override
  Widget build(BuildContext context) {
    return (flutterSound == null) ? Container(): IconButton(
        icon: Icon(recording?Icons.stop:Icons.mic, color: InfitioColors.cool_grey,),
        onPressed: recording? stopRecorder: startRecorder
    );
  }

  startRecorder() async{
    await flutterSound.startRecorder(soundFilePath,
        sampleRate: 8000,
        androidEncoder: AndroidEncoder.AMR_NB,
        iosQuality: IosQuality.HIGH
    );
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
    Map<String, Object> response = await speechToText(soundFilePath, widget.language);
    List<Map> alternatives = response['alternatives'];
    if(alternatives.length > 0){
      widget.onMessage(alternatives[0]['transcript']);
    }
    setState((){ recording = false; });
  }
}