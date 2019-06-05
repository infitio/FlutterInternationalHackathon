import 'package:adhara/adhara.dart';
import 'package:flutter/material.dart';
import 'package:reverb/res/InfitioColors.dart';
import 'package:reverb/res/InfitioStyles.dart';
import 'package:reverb/datainterfaces.dart';
import 'package:reverb/screens/ChatView.dart';

class ChatTile extends AdharaStatefulWidget{
  
  Map user;
  
  ChatTile(this.user);
  @override
  _ChatTileState createState() => new _ChatTileState();
}

class _ChatTileState extends AdharaState<ChatTile>{

  String get tag => "ChatThread";

  Map _user;

  @override
  fetchData(Resources r) async{
    _user = await (r.dataInterface as AppDataInterface).getLoggedInUser();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatView()));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0,top: 5.0, right: 10.0, bottom: 5.0),
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(widget.user['photo']),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.0),
                      child: Text('${widget.user['name']}', style: InfitioStyles.boldTitle),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 0.0),
                      child: Text('The Thope ', style: InfitioStyles.subtitle),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  alignment: Alignment(0.0, 0.0),
                  width: 20.0,
                  height: 20.0,
                  decoration: new BoxDecoration(
                    color: InfitioColors.dark_mint,
                    shape: BoxShape.circle,
                  ),
                  child: Text('1', style: InfitioStyles.indicator, textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text('12:00 PM', style: InfitioStyles.textStyle15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}