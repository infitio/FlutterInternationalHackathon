import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adhara/adhara.dart';
import 'package:reverb/datainterface/AppDataInterface.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reverb',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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


  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  bool isLoggedIn = false;

  Future<Map> _signIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    Map userMap = {
      'email': googleUser.email,
      'name': googleUser.displayName,
      'photo': googleUser.photoUrl
    };
    await (r.dataInterface as AppDataInterface).storeUser(userMap);
    setState(() {});
  }

  @override
  fetchData(Resources r) async {
    // TODO: implement fetchData
    user = await (r.dataInterface as AppDataInterface).getLoggedInUser();
    if(user != null){
      isLoggedIn = true;
    }
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              onPressed: () => _signIn(),
              child: Text("Sign in"),
              color: Colors.green,
            ),
            Padding(
                padding: EdgeInsets.all(30.0)
            ),
            RaisedButton(
              onPressed: null,
              child: Text("Sign out"),
              color: Colors.red,
            ),
            Container(
              child: (user!= null)?Image.network(user["photo"]):Image.asset('assets/DRVED.png'),
            )
          ],
        ),
      ),
    );
  }
}

