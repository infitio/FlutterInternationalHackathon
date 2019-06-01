import 'package:flutter/material.dart';
import 'package:adhara/adhara.dart';
import 'package:reverb/res/InfitioColors.dart';
import 'package:reverb/res/AppStyles.dart';
import 'package:reverb/res/InfitioStyles.dart';

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



  //BackDrop animations
  AnimationController _controller;
  static const _PANEL_HEADER_HEIGHT = 300.0;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100),
        value: 1.0
    );
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
  void _handleSubmit(String text) {
    Message m = Message(true, text);
    _chatController.clear();

    setState(() {
      messages.insert(0, m);
    });
  }
  Widget chatEnvironment() {
    return IconTheme(
      data: new IconThemeData(color: Colors.blue),
      child: new Container(
        margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 30.0),
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
                new IconButton(
                  icon: new Icon(Icons.mic_none, color: InfitioColors.cool_grey,),
                  onPressed: null,
                ),
                new IconButton(
                  icon: new Icon(Icons.attach_file, color: InfitioColors.dark_grey_blue,),
                  onPressed: null,
                ),
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
  Widget messageBox(Message agronomistMessage){

    Color bodyColor, contentColor;
    Alignment bodyAlignment;
    TextStyle textStyle;
    BorderRadius borderRadius;
    double borderRad = 25.0;

    if(agronomistMessage.isUser){
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
      Message agronomistMessage,
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
                      child: Text('${agronomistMessage.content}', style: _textStyle,),
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
  Widget chatBody(List<Message> p) {

    List<Widget> sliverChildList = [];

    if(p.isEmpty){
      sliverChildList.add(Text("Please enter some shit first before looking for my beautiful designs"));
    }else{
      sliverChildList = p.map((Message n) {
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
    return Container();
  }

  String get tag => "ChatView";
}