import 'package:flutter/material.dart';
import 'package:adhara/adhara.dart';
import 'package:reverb/res/InfitioColors.dart';
import 'package:reverb/res/InfitioStyles.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:reverb/datainterface/AppDataInterface.dart';
import 'package:reverb/widgets/recorder.dart';
import 'package:reverb/widgets/messageContainer.dart';

import 'dart:async';


class ChatView extends AdharaStatefulWidget{
  @override
  _ChatViewState createState() => _ChatViewState();
}

class Message{

  String content;
  String userId;
  String language;

  Message(
      this.userId,
      this.content,
      {this.language:""}
      );

  isMine(String myId){
    return this.userId == myId;
  }

  toJSON(){
    return {
      'sender': this.userId,
      'content': this.content,
      'language': this.language
    };
  }

}

class _ChatViewState extends AdharaState<ChatView> with SingleTickerProviderStateMixin{
  List<Message> messages = [];
  List<String> languages = ["en-IN", "es-US", "fr-FR", "ta-IN", "te-IN", "hi-IN", "ml-IN"];
  String _selectedLanguage = "te-IN";
  String userId = DateTime.now().millisecondsSinceEpoch.toString();

  int _counter;
  DatabaseReference _counterRef;
  DatabaseReference _messagesRef;
  StreamSubscription<Event> _counterSubscription;
  StreamSubscription<Event> _messagesSubscription;
  bool _anchorToBottom = false;

  String _kTestKey = 'content';
  DatabaseError _error;

  //BackDrop animations
  AnimationController _controller;
  static const _PANEL_HEADER_HEIGHT = 450.0;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100),
        value: 1.0
    );

    _counterRef = FirebaseDatabase.instance.reference().child('counter');
    // Demonstrates configuring the database directly
    final FirebaseDatabase database = FirebaseDatabase();
    _messagesRef = database.reference().child('messages');
    database.reference().child('counter').once().then((DataSnapshot snapshot) {
    });
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    _counterRef.keepSynced(true);
    _counterSubscription = _counterRef.onValue.listen((Event event) {
      setState(() {
        _error = null;
        _counter = event.snapshot.value ?? 0;
      });
    }, onError: (Object o) {
      final DatabaseError error = o;
      setState(() {
        _error = error;
      });
    });
    _messagesSubscription =
        _messagesRef.limitToLast(10).onChildAdded.listen((Event event) {
        }, onError: (Object o) {
          final DatabaseError error = o;
          print('Error: ${error.code} ${error.message}');
        });
  }

  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }

  bool get _isPanelVisible{
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final double height = constraints.biggest.height;
    final double top = height - _PANEL_HEADER_HEIGHT;
    final double bottom = -_PANEL_HEADER_HEIGHT;
    return new RelativeRectTween(
      begin: new RelativeRect.fromLTRB(0.0, top, 0.0, bottom),
      end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(new CurvedAnimation(parent: _controller, curve: Curves.linear));
  }


  //Reply-Box and Submit button
  final TextEditingController _chatController = new TextEditingController();
  void _handleSubmit(String text) async{
//    String translatedText = await translateText(text: text, language: _selectedLanguage);
    Message m = Message(userId, text, language: _selectedLanguage);

    final TransactionResult transactionResult =
    await _counterRef.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + 1;
      return mutableData;
    });

    if (transactionResult.committed) {
      _messagesRef.push().set(m.toJSON());
    } else {
      print('Transaction not committed.');
      if (transactionResult.error != null) {
        print(transactionResult.error.message);
      }
    }
    messages.insert(0, m);
    _chatController.clear();

    setState(() {
    });
  }
  Widget chatEnvironment() {
    return IconTheme(
      data: new IconThemeData(color: Colors.blue),
      child: new Container(
        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                style: InfitioStyles.farmerMessage,
                decoration: new InputDecoration.collapsed(
                  hintText: "Type a message",
                  hintStyle: InfitioStyles.hint,
                ),
                controller: _chatController,
                onSubmitted: _handleSubmit,
              ),
            ),
            new Row(
              children: <Widget>[
                Recorder(_selectedLanguage, (String message){
                  _handleSubmit(message);
                }),
                IconButton(
                  icon: new Icon(Icons.send, color: InfitioColors.denim_blue,),
                  onPressed: () => _handleSubmit(_chatController.text),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<Message> onIncomingMessage(Map message) async{
    String translatedText = await translateText(text: message['content'], language: _selectedLanguage);
    return Message(message['sender'],translatedText);
  }
  
  //Creating chat body
  Widget chatBody(List<Message> data) {
    List<Widget> sliverChildList = [];
    data.forEach((_){
      sliverChildList.add(MessageContainer(_,_.isMine(userId)));
    });
    return SliverPadding(
        padding: EdgeInsets.all(20.0),
        sliver: SliverList(delegate: SliverChildListDelegate(sliverChildList))
    );
  }

  //main build
  @override
  Widget build(BuildContext context) {
    return container();
  }


  //Screen Container
  Widget container(){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: InfitioColors.denim_blue,
        title: Text("Reverb"),
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(
              icon: AnimatedIcon(
                  icon: AnimatedIcons.arrow_menu,
                  progress: _controller.view
              ),
              onPressed : () {
                _controller.fling(velocity: _isPanelVisible? -1.0 : 1.0);
              }
          )
        ],
      ),
      body: LayoutBuilder(builder: _buildStack),
    );
  }


  //chat body
  Widget _buildStack(BuildContext context, BoxConstraints constraints){
    final Animation<RelativeRect> animation = _getPanelAnimation(constraints);
    final ThemeData theme = Theme.of(context);
    return Container(
      color: InfitioColors.denim_blue,
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[
                DropdownButton(
                  hint: Text("Please choose language"),
                  style: InfitioStyles.farmerMessage,
                  value: _selectedLanguage,
                  items: languages.map((lang) {
                    return DropdownMenuItem(
                      child: Text(lang),
                      value: lang,
                    );}).toList(),
                  onChanged: (newValue){
                    setState(() {
                      _selectedLanguage = newValue;
                    });
                  },
                  iconEnabledColor: InfitioColors.white_three,
                ),
                Text("Please select your language", style: InfitioStyles.agronomistMessage,),
                Padding(
                  padding: EdgeInsets.all(30.0),
                ),
              ],
            ),
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight
            ),
            padding: EdgeInsets.all(30.0),
          ),
          new PositionedTransition(
            rect: animation,
            child: Material(
                borderRadius: const BorderRadius.only(
                  topRight: const Radius.circular(16.0),
                  topLeft: const Radius.circular(16.0),
                ),
                elevation: 12.0,
                child: Column(
                  children: <Widget>[
                    StreamBuilder(builder: (context, snapshot){
                      if(snapshot.hasData){
                        return Flexible(
                          child: CustomScrollView(
                            reverse: true,
                            slivers: <Widget>[
                              chatBody(snapshot.data)
                            ],
                          ),
                        );
                      }else{
                        return Container();
                      }
                    }, stream: getMessagesFromFireBase(),),
                    Divider(),
                    chatEnvironment()
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }

  Stream<List<Message>> getMessagesFromFireBase(){
    return _messagesRef.orderByKey().onValue.asyncMap((e) async {
      Map<String, dynamic> mappedData = Map.castFrom<dynamic, dynamic, String, dynamic>(e.snapshot.value);
      List<dynamic>  messages = mappedData.values.toList();
      List<Message> ms = [];
      if(messages.isEmpty){

      }else{
        for(int i=0; i<messages.length; i++){
          ms.add(await onIncomingMessage(messages[i]));
        }
      }
      return ms;
    });
  }

  String get tag => "ChatView";
}
