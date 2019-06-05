import 'package:google_sign_in/google_sign_in.dart';
import 'package:adhara/adhara.dart';
import 'package:reverb/datainterface/AppDataInterface.dart';

final GoogleSignIn _googleSignIn = new GoogleSignIn();

Future<void> googleSignIn(Resources r) async {
  GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  Map userMap = {
    'email': googleUser.email,
    'name': googleUser.displayName,
    'photo': googleUser.photoUrl
  };
  await (r.dataInterface as AppDataInterface).storeUser(userMap);
}
Future<void> googleSignOut(Resources r) async{
  _googleSignIn.signOut();
  await (r.dataInterface as AppDataInterface).removeUser();
}
Future<void> googleChangeAccount(Resources r) async{
  _googleSignIn.signOut();
  await (r.dataInterface as AppDataInterface).removeUser();
  googleSignIn(r);
  print("User Resigned In ");
}