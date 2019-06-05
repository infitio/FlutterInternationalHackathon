import 'package:flutter/material.dart';
import 'package:adhara/adhara.dart';
import 'package:reverb/datainterface/AppDataInterface.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import "package:reverb/reverb_app.dart";
import 'package:reverb/google_auth.dart';
import 'package:reverb/res/InfitioStyles.dart';
import 'package:reverb/res/InfitioColors.dart';

class AuthenticationApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reverb',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Reverb'),
    );
  }
}

class MyHomePage extends AdharaStatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends AdharaState<MyHomePage> {

  String get tag => "--";
  Map user;
  bool isLoggedIn = false;

  @override
  fetchData(Resources r) async {
    // TODO: implement fetchData
    user = await (r.dataInterface as AppDataInterface).getLoggedInUser();
    if(user != null){
      isLoggedIn = true;
    }
    setState((){});
  }

  Future<void> _signIn() async {
    user = await (r.dataInterface as AppDataInterface).getLoggedInUser();
    await googleSignIn(r);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ReverbApp()));
  }

  @override
  Widget build(BuildContext context) {
    return (isLoggedIn)?ReverbApp():googleAuthScreen();
  }

  Widget googleAuthScreen() {
    return Scaffold(

      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: InfitioColors.cool_blue,
              height: 500,
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(100.0)
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/DRVED.png'),
                    radius: 75,
                  ),
                  Padding(
                      padding: EdgeInsets.all(30.0)
                  ),
                  Text("Language is no more a barrier", textAlign: TextAlign.center, style: InfitioStyles.textStyle4,),

                ],
              ),
            ),
            Container(
              child: Container(
                width: 300.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 50.0),
                child: GoogleSignInButton(
                  onPressed: () =>_signIn(),
                  darkMode: true,
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(30.0)
            ),
          ],
        ),
      ),
    );
  }
}

