import 'package:pop_app/models/initial_invoice.dart';
import 'package:pop_app/models/invoice.dart';
import 'package:pop_app/models/item.dart';
import 'package:pop_app/secure_storage.dart';
import 'package:pop_app/models/store.dart';
import 'package:pop_app/models/user.dart';
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
  {"route": "korisnici", "method": "POST"},
];

enum Routes { login, registracija, proizvodi, paketi, novcanik, racuni, trgovine, korisnici }

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
    } catch (e) {
      SecureStorage.setUserData(json.encode("{}"));
    }
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

  static Future<dynamic> getAllStores(User user) async {
    var fm = {
      "Token": _token,
      "KorisnickoIme": user.username,
      "Readall": "True",
    };

    dynamic responseData;
    responseData = await _executeWithToken(user, () async {
      http.Response response = await http.post(body: fm, route(Routes.trgovine));
      return response.bodyBytes;
    });

    return responseData;
  }

  static Future<Store> createStore(User user, String storeName) async {
    var fm = {
      "Token": _token,
      "KorisnickoIme": user.username,
      "CREATESTORE": "True",
      "NazivTrgovine": storeName
    };

    dynamic responseData;

    responseData = await _executeWithToken(user, () async {
      http.Response response = await http.post(body: fm, route(Routes.trgovine));
      return response.bodyBytes;
    });

    return Store(responseData["DATA"]["Id_Trgovine"], responseData["DATA"]["NazivTrgovine"], 0, 0);
  }

  static Future<bool> assignStore(User user, Store store) async {
    var fm = {
      "Token": _token,
      "KorisnickoIme": user.username,
      "ASSIGNSTORESELF": "True",
      "Id_Trgovine": store.storeId.toString()
    };

    dynamic responseData;

    responseData = await _executeWithToken(user, () async {
      http.Response response = await http.post(body: fm, route(Routes.trgovine));
      dynamic body = response.bodyBytes;
      return body;
    });

    return (responseData["STATUSMESSAGE"] == "STORE ASSIGNED");
  }

  static Future<bool> assignRole(User user) async {
    if (user.getRole() == null) {
      return false;
    }

    var fm = {
      "Token": _token,
      "KorisnickoIme": user.username,
      "SETOWNROLE": "True",
      "RoleId": user.getRole()!.roleId.toString()
    };

    dynamic responseData;
    responseData = await _executeWithToken(user, () async {
      http.Response response = await http.post(body: fm, route(Routes.korisnici));
      return response.bodyBytes;
    });

    return (responseData["STATUSMESSAGE"] == "OWN ROLE SET");
  }

  static Future<double> getBalance(User user) async {
    if (user.getRole() == null) {
      throw Exception("Can't get balance: user's role not set!");
    }

    final roleMap = {
      "buyer": "GETCLIENT",
      "seller": "GETSTORE",
    };

    var fm = {
      "Token": _token,
      "KorisnickoIme": user.username,
      roleMap[user.getRole()!.roleName]: "True",
    };

    dynamic responseData;

    responseData = await _executeWithToken(user, () async {
      http.Response response = await http.post(
        body: fm,
        route(Routes.novcanik),
      );

      return response.bodyBytes;
    });

    double fetchedBalance;

    try {
      fetchedBalance = double.parse(responseData["DATA"]);
    } catch (e) {
      throw Exception("Can't get balance: ${responseData["STATUSMESSAGE"]}!");
    }

    return fetchedBalance;
  }

  static Future<List<Invoice>> getAllInvoices() async {
    User user = await User.loggedIn;

    var fm = {
      "Token": _token,
      "KorisnickoIme": user.username,
      "Readall": "True",
    };

    dynamic responseData;
    responseData = await _executeWithToken(user, () async {
      http.Response response = await http.post(body: fm, route(Routes.racuni));
      return response.bodyBytes;
    });

    List<Invoice> invoices = List<Invoice>.empty(growable: true);

    if (responseData["DATA"] != null) {
      for (var invoice in responseData["DATA"]) {
        invoices.add(Invoice.fromDynamicMap(invoice));
      }
    }

    return invoices;
  }

  static Future<Invoice?> finalizeInvoice(String code) async {
    User user = await User.loggedIn;

    var fm = {
      "Token": _token,
      "KorisnickoIme": user.username,
      "CONFIRMSALE": "True",
      "Id_Racuna": code
    };

    dynamic responseData;
    responseData = await _executeWithToken(user, () async {
      http.Response response = await http.post(body: fm, route(Routes.racuni));
      return response.bodyBytes;
    });

    Invoice? invoice;

    if (responseData["STATUSMESSAGE"] == "MISSING AMOUNT") {
      throw Exception("The seller can't sell this much to you!");
    } else if (responseData["STATUSMESSAGE"] == "MISSING BALANCE") {
      throw Exception("You don't have enough funds left to proceed!");
    } else if (responseData["STATUSMESSAGE"] == "NO BUYING FROM OWN STORE") {
      throw Exception("You can't buy from your own store!");
    } else if (responseData["STATUSMESSAGE"] == "INVOICE FINALIZED") {
      invoice = Invoice.fromDynamicMap(responseData["DATA"]);
    }

    return invoice;
  }

  static Future<InitialInvoice> generateInvoice(double discount, List<Item> items) async {
    User user = await User.loggedIn;

    Map<String, Object> fm = {
      "Token": _token!,
      "KorisnickoIme": user.username,
      "GENERATESALE": "True",
      "PopustRacuna": discount.toStringAsFixed(0),
    };

    for (int i = 0; i < items.length; i++) {
      fm["Itemi[$i]"] = items[i].id;
      fm["Kolicine[$i]"] = items[i].getSelectedAmount().toString();
    }

    dynamic responseData;
    responseData = await _executeWithToken(user, () async {
      http.Response response = await http.post(body: fm, route(Routes.racuni));
      return response.bodyBytes;
    });

    if (responseData["STATUSMESSAGE"] == "INVOICE GENERATED") {
      return InitialInvoice(
          id: responseData["DATA"]["Id"], code: responseData["DATA"]["Kod_Racuna"]);
    } else {
      throw Exception("Something went wrong: ${responseData["STATUSMESSAGE"]}");
    }
  }

  /// Wraps whatever fetching logic into a token check.
  /// If the server reports token is invalid, this method attempts login once.
  /// If the new token is still invalid, method returns null instead of response.
  /// [requestCallback] should return a response body!
  static Future<dynamic> _executeWithToken(User user, dynamic requestCallback) async {
    int attempts = 0;

    dynamic responseData;
    bool isTokenValid = false;
    do {
      dynamic body = await requestCallback();
      responseData = jsonDecode(utf8.decode(body));
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

  static Future<List> getAllPackages(User user) async {
    var fm = {"Token": _token, "KorisnickoIme": user.username, "GET": "True"};
    dynamic responseData;
    responseData = await _executeWithToken(user, () async {
      http.Response response = await http.post(body: fm, route(Routes.paketi));
      return response.bodyBytes;
    });
    return [responseData];
  }

  static Future<List> getAllProducts(User user) async {
    var fm = {"Readall": "True", "Token": _token, "KorisnickoIme": user.username};
    dynamic responseData;
    responseData = await _executeWithToken(user, () async {
      http.Response response = await http.post(body: fm, route(Routes.proizvodi));
      return response.bodyBytes;
    });
    return [responseData];
  }
}
