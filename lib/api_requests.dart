import 'package:http/http.dart' as http;
import 'dart:convert';

List<Map<String, String>> routes = [
  {"route": "login", "method": "POST"},
  {"route": "registracija", "method": "POST"},
  {"route": "proizvodi", "method": "GET"},
  {"route": "proizvodi", "method": "POST"},
  {"route": "paketi", "method": "POST"},
  {"route": "novcanik", "method": "POST"},
  {"route": "racuni", "method": "POST"},
  {"route": "trgovine", "method": "POST"},
];

enum Routes { login, registracija, proizvodi, paketi, novcanik, racuni, trgovine }

class ApiRequestManager {
  static const String root = "https://cortex.foi.hr/pop/api/v1/";
  static var token;

  /// Call an API route
  static Uri route(Routes route) => Uri.parse("$root${route.name}.php");

  static Future login(String username, String password) async {
    var fm = {"KorisnickoIme": username, "Lozinka": password};
    http.Response response = await http.post(
      body: fm,
      route(Routes.login),
    );
    var responseData = json.decode(response.body);
    try {
      var tokenData = responseData["DATA"]["Token"];
      token = tokenData;
    } catch (e) {}
    return responseData;
  }
}
