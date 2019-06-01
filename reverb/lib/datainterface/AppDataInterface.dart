import 'package:adhara/adhara.dart';
import 'package:http/http.dart' as http;


const String API_KEY = "AIzaSyBIY6nxJjyES9Bxtcmuh6TkAozvkXhqfIY";
class AppDataInterface extends DataInterface{

  AppDataInterface(Config config):super(config);

  final String _baseUrl = "https://translation.googleapis.com/language/translate/v2?key=$API_KEY";
  http.Client client = http.Client();
  translateText({String text, String language}) async{
    http.Response response= await client.get("$_baseUrl&q=$text&target=$language");
  }
}
