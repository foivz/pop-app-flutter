import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pop_app/models/user.dart';

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
  static String? _token;

  static String? getToken() => _token;

  /// Call an API route
  static Uri route(Routes route) => Uri.parse("$root${route.name}.php");

  static Future login(String username, String password) async {
    var fm = {"KorisnickoIme": username, "Lozinka": password};
    http.Response response = await http.post(
      body: fm,
      route(Routes.login),
    );
    var responseData = json.decode(response.body);
    _updateTokenData(responseData);
    return responseData;
  }

  static void _updateTokenData(responseData) {
    try {
      var tokenData = responseData["DATA"]["Token"];
      _token = tokenData;
    } catch (e) {}
  }

  static Future register(User user) async {
    var fm = {
      "Ime": user.firstName,
      "Prezime": user.lastName,
      "Lozinka": user.password,
      "Email": user.email,
      "KorisnickoIme": user.username
    };

    http.Response response = await http.post(
      body: fm,
      route(Routes.registracija),
    );

    var responseData = json.decode(response.body);

    _updateTokenData(responseData);

    return responseData;
  }

  static Future<dynamic?> getAllStores(User user) async {
    var fm = {
      "Token": _token,
      "KorisnickoIme": user.username,
      "Readall": "True",
    };

    dynamic responseData;

    responseData = await _executeWithToken(user, () async {
      http.Response response = await http.post(
        body: fm,
        route(Routes.trgovine),
      );
      String body = response.body;

      return body;
    });

    return responseData;
  }

  /// Wraps whatever fetching logic into a token check.
  /// If the server reports token is invalid, this method attempts login once.
  /// If the new token is still invalid, method returns null instead of response.
  /// [requestCallback] should return a response body!
  static Future<dynamic> _executeWithToken(
      User user, Future<String> Function() requestCallback) async {
    int attempts = 0;

    dynamic responseData;
    bool isTokenValid = false;
    do {
      String body = await requestCallback();
      responseData = jsonDecode(body);
      isTokenValid = _isTokenValid(responseData);
      if (!isTokenValid) {
        login(user.username, user.password);
      }
    } while (!isTokenValid && ++attempts != 2);

    if (attempts == 2) {
      responseData = null;
    }

    return responseData;
  }

  static bool _isTokenValid(responseData) {
    return responseData["STATUSMESSAGE"] != "OLD TOKEN";
  }
}
