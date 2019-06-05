import 'package:flutter/material.dart';
import 'package:adhara/adhara.dart';
import 'package:reverb/screens/ChatView.dart';
import 'package:reverb/res/InfitioColors.dart';
import 'package:reverb/res/AppStyles.dart';
import 'package:reverb/res/InfitioStyles.dart';

class MessageContainer extends AdharaStatefulWidget{

  final Message message;
  final bool isMine;
  MessageContainer(this.message, this.isMine);

  @override
  _MessageContainerState createState() => _MessageContainerState();

}

class _MessageContainerState extends AdharaState<MessageContainer>{

  String get tag => "MessageContainer";

  Widget messageBox(){
    Color bodyColor, contentColor;
    Alignment bodyAlignment;
    TextStyle textStyle;
    BorderRadius borderRadius;
    double borderRad = 25.0;

    if(widget.isMine){
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
        child: messageContent(bodyColor, contentColor, textStyle, borderRadius)
    );
  }

  Widget messageContent(
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
                      child: Text('${widget.message.content}', style: _textStyle,),
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return messageBox();
  }
}