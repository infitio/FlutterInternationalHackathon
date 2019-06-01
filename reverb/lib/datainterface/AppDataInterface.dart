import 'package:adhara/adhara.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';


const String API_KEY = "AIzaSyBIY6nxJjyES9Bxtcmuh6TkAozvkXhqfIY";
class AppDataInterface extends DataInterface{

  AppDataInterface(Config config):super(config);



}

const String BASE_URL = "https://translation.googleapis.com/language/translate/v2?key=$API_KEY";
http.Client client = http.Client();
Future<String> translateText({String text, String language}) async{
  http.Response response= await client.get("$BASE_URL&q=$text&target=$language");
  dynamic responseBody = jsonDecode(response.body);
  return responseBody['data']['translations'][0]['translatedText'];
}