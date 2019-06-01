import "package:adhara/adhara.dart";
import 'package:reverb/datainterfaces.dart';
import "package:reverb/reverb_app.dart";

class AppConfig extends Config{

  static get appVersion => "3.2.0";

  get container => ReverbApp();

  String get configFile{
    return isReleaseMode()
        ?"assets/config/production.json"
        :"assets/config/dev.json";
  }

  /*NetworkProvider get networkProvider => AppNetworkProvider(this);

  DataInterface get dataInterface => AppDataInterface(this);

  String get fetchingImage => "assets/animations/fetching.gif";*/

  Map<String, String> get languageResources => {
    "en": "assets/languages/en.properties",
  };

  List<String> get sentryIgnoreStrings => [
    "HTTP request failed, statusCode: 404",
    "Connection closed before full header was received",
    "Connection reset by peer",
    "Connection timed out",
    "SocketException: Failed host lookup",
    "The method 'inheritFromWidgetOfExactType' was called on null. Receiver: null Tried calling: inheritFromWidgetOfExactType",
  ];

}