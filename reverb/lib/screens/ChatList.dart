import 'package:adhara/adhara.dart';
import 'package:flutter/material.dart';
import 'package:reverb/res/InfitioColors.dart';
import 'package:reverb/res/InfitioStyles.dart';
import 'package:reverb/datainterfaces.dart';
import 'package:reverb/screens/ChatView.dart';
import 'package:reverb/widgets/chatTile.dart';
import 'package:reverb/google_auth.dart';
import 'package:reverb/screens/AuthScreen.dart';

class Chatlist extends AdharaStatefulWidget{
  @override
  _ChatlistState createState() => new _ChatlistState();
}

class _ChatlistState extends AdharaState<Chatlist>{

  String get tag => "ChatThread";
  Map user;
  bool isLoggedIn;


  @override
  fetchData(Resources r) async{
    user = await (r.dataInterface as AppDataInterface).getLoggedInUser();
    if(user != null){
      isLoggedIn = true;
    }
    setState((){});
  }

  Future<void> _signOut() async {
    await googleSignOut(r);
    Navigator.push(context, MaterialPageRoute(builder: (context) => AuthenticationApp()));
  }

  @override
  Widget build(BuildContext context) {

    Widget titleSeparator = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 54.0, height: 2.0, margin: EdgeInsets.only(left: 16.0),
          decoration: BoxDecoration(
            color: InfitioColors.denim_blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4.0),
          ),
        )
      ],
    );

    Widget _buildWidgetList(){
      List<Widget> sliverChildList = [SizedBox(height: 6.0,)];
      for(int i=0;i<=1;i++){
        sliverChildList.add(ChatTile(user));
        sliverChildList.add(Divider(indent: 70.0,));
      }
      return SliverList(delegate: SliverChildListDelegate(sliverChildList));
    }

    Scaffold homeScaffold = Scaffold(
      body: !isFirstLoadComplete? Text("Loading.."):
      Paginator(
        listType: PaginatorTypes.CUSTOM_SCROLL_VIEW,
        children: <Widget>[
          SliverAppBar(
            title: Text("Chats", style: InfitioStyles.title),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  color: InfitioColors.denim_blue,
                  onPressed: () {_signOut();}
              )
            ],
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            bottom: PreferredSize(child: titleSeparator, preferredSize: Size(64.0, 2.0)),
          ),
          _buildWidgetList()
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_circle, color: InfitioColors.white, size: 24.0,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatView()));
          }
      ),
    );
    return homeScaffold;
  }
}