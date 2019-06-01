import 'package:flutter/material.dart';
import 'package:adhara/adhara.dart';
import 'package:reverb/res/InfitioColors.dart';
import 'package:reverb/res/AppStyles.dart';
import 'package:reverb/res/InfitioStyles.dart';
import 'package:reverb/datainterface/AppDataInterface.dart';
import 'package:reverb/widgets/recorder.dart';
import 'package:firebase_database/firebase_database.dart';

import 'dart:async';


class ChatView extends AdharaStatefulWidget{
  @override
  _ChatViewState createState() => _ChatViewState();
}

class Message{
  String content;
  bool isUser;
  Message(
      this.isUser,
      this.content
      );
}

class _ChatViewState extends AdharaState<ChatView> with SingleTickerProviderStateMixin{
  List<Message> messages = [];
  List<String> languages = ["te","en", "hi", "ta", "kn", "ml"];
  String _selectedLanguage;

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
      print('Connected to second database and read ${snapshot.value}');
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
          print('Child added: ${event.snapshot.value}');
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
  void _handleSubmit(String message) async{
    //String translatedText = await translateText(text: message, language: _selectedLanguage);
    Message m = Message(false, message);

    final TransactionResult transactionResult =
    await _counterRef.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + 1;
      return mutableData;
    });

    if (transactionResult.committed) {
      _messagesRef.push().set(<String, String>{
        'content': message,
        'language': 'en',
        'sender': '1'
      });
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
                Recorder('en', (String message) async{
                  final TransactionResult transactionResult =
                      await _counterRef.runTransaction((MutableData mutableData) async {
                    mutableData.value = (mutableData.value ?? 0) + 1;
                    return mutableData;
                  });

                  if (transactionResult.committed) {
                    _messagesRef.push().set(<String, String>{
                      'content': message,
                      'language': 'en',
                      'sender': '1'
                    });
                  } else {
                    print('Transaction not committed.');
                    if (transactionResult.error != null) {
                      print(transactionResult.error.message);
                    }
                  }
                }),
                new IconButton(
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


  //Format for Farmer's message
  Widget messageBox(dynamic agronomistMessage){

    Color bodyColor, contentColor;
    Alignment bodyAlignment;
    TextStyle textStyle;
    BorderRadius borderRadius;
    double borderRad = 25.0;

    if(!agronomistMessage.isUser){
      bodyColor = InfitioColors.white_three;
      contentColor = InfitioColors.charcoal_grey;
      bodyAlignment = Alignment.topLeft;
      textStyle = AppStyles.farmerMessage;
      borderRadius = BorderRadius.only(
        topRight: Radius.circular(borderRad),
        topLeft: Radius.circular(borderRad),
        bottomRight: Radius.circular(borderRad),
      );
    }else{
      bodyColor = InfitioColors.cool_blue;
      contentColor = InfitioColors.white_three;
      bodyAlignment = Alignment.topRight;
      textStyle = AppStyles.agronomistMessage;
      borderRadius = BorderRadius.only(
        topRight: Radius.circular(borderRad),
        topLeft: Radius.circular(borderRad),
        bottomLeft: Radius.circular(borderRad),
      );
    }
    return Container(
        alignment: bodyAlignment,
        padding: EdgeInsets.all(10.0),
        child: messageContent(agronomistMessage, bodyColor, contentColor, textStyle, borderRadius)
    );
  }


  //message content
  Widget messageContent(
      dynamic agronomistMessage,
      Color _bodyColor,
      Color _contentColor,
      TextStyle _textStyle,
      BorderRadius _borderRadius
      ){
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        Wrap(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(right: 30.0),
                constraints: BoxConstraints(
                  maxWidth: 300.0,
                ),
                decoration: new BoxDecoration(
                    color: _bodyColor,
                    borderRadius: _borderRadius
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: Text('${agronomistMessage['content']}', style: _textStyle,),
                      padding: EdgeInsets.all(15.0),
                    ),
                    Container(
                      child: Text('12:00 PM', style: AppStyles.timestamp1, textAlign: TextAlign.right,),
                      padding: EdgeInsets.only(right: 15.0, bottom: 10.0),
                    )
                  ],
                )
            )
          ],
        ),
        Container(
          alignment: Alignment(0.0, 0.0),
          width: 36.0,
          height: 36.0,
          decoration: new BoxDecoration(
              color: _bodyColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.0)
          ),
          child: Icon(Icons.volume_up, color: _contentColor,),
        ),
      ],
    );
  }

  //Creating chat body
  Widget chatBody(dynamic data) {

    List<Widget> sliverChildList = [];
    Map<String, dynamic> mappedData = Map.castFrom<dynamic, dynamic, String, dynamic>(data);
    List<dynamic>  messages = mappedData.values.toList();
    if(messages.isEmpty){
      sliverChildList.add(Text("Welcome"));
    }else{
      sliverChildList = messages.map((dynamic n) {
        return messageBox(n);
      }).toList();
    }

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
      color: theme.primaryColor,
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
                Text("Please select your language", style: InfitioStyles.agronomistMessage,)
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

  Stream<Map<dynamic, dynamic>> getMessagesFromFireBase(){
    return _messagesRef.onValue.map((e) => e.snapshot.value);
  }

  String get tag => "ChatView";
}
