import 'package:adhara/adhara.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';


const String API_KEY = "AIzaSyBIY6nxJjyES9Bxtcmuh6TkAozvkXhqfIY";
class AppDataInterface extends DataInterface{

  AppDataInterface(Config config):super(config);

  storeUser(Map user) async {
    await this.keyValueStorageProvider.setData("user", user);
  }

  Future<Map> getLoggedInUser() async {
    return await this.keyValueStorageProvider.getData("user");
  }

  removeUser() async {
    await this.keyValueStorageProvider.remove("user");
  }

}

const String BASE_URL = "https://translation.googleapis.com/language/translate/v2?key=$API_KEY";
http.Client client = http.Client();
Map<String, String> localTranslations = {};

Future<String> translateText({String text, String language}) async{
  language = language.split('-')[0];
  if(localTranslations[text+"--"+language] != null){
    return localTranslations[text+"--"+language];
  }
  http.Response response= await client.get("$BASE_URL&q=$text&target=$language");
  dynamic responseBody = jsonDecode(response.body);
  String ttext = responseBody['data']['translations'][0]['translatedText'];
  localTranslations[text+"--"+language] = ttext;
  return ttext;
}