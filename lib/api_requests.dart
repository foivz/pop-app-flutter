// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print, unnecessary_string_interpolations

import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/packages_tab/package_data.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/product_data.dart';
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

  static void _updateTokenData(responseData) {
    try {
      var tokenData = responseData["DATA"]["Token"];
      _token = tokenData;
    } catch (e) {
      SecureStorage.setUserData(json.encode("{}"));
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
    if (user.role == null) {
      return false;
    }

    var fm = {
      "Token": _token,
      "KorisnickoIme": user.username,
      "SETOWNROLE": "True",
      "RoleId": user.role!.roleId.toString()
    };

    dynamic responseData;
    responseData = await _executeWithToken(user, () async {
      http.Response response = await http.post(body: fm, route(Routes.korisnici));
      return response.bodyBytes;
    });

    return (responseData["STATUSMESSAGE"] == "OWN ROLE SET");
  }

  static Future<double> getBalance(User user) async {
    if (user.role == null) {
      throw Exception("Can't get balance: user's role not set!");
    }

    final roleMap = {
      "buyer": "GETCLIENT",
      "seller": "GETSTORE",
    };

    var fm = {
      "Token": _token,
      "KorisnickoIme": user.username,
      roleMap[user.role!.roleName]: "True",
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

  static bool _isTokenValid(responseData) {
    return responseData["STATUSMESSAGE"] != "OLD TOKEN";
  }

  static Future<List> getAllPackages() async {
    User user = await SecureStorage.getUser();
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

  static Future addProductToStore(ConstantProductData product) async {
    http.MultipartRequest req = http.MultipartRequest('POST', route(Routes.proizvodi));
    req.fields.addAll({
      "Token": _token!,
      "Naziv": product.title,
      "Opis": product.description,
      "Cijena": product.price.toString(),
      "Kolicina": product.amount.toString(),
      "KorisnickoIme": await SecureStorage.getUsername(),
    });
    if (product.imageFile != null)
      req.files.add(
        http.MultipartFile.fromBytes(
          'Slika',
          filename: 'Slika',
          await product.imageFile!.readAsBytes(),
        ),
      );
    http.StreamedResponse responseData;
    try {
      responseData = await req.send();
      return responseData;
    } catch (e) {
      throw Exception("Failed to connect");
    }
  }

  static Future addPackageToStore(PackageData package) async {
    http.MultipartRequest req = http.MultipartRequest('POST', route(Routes.paketi));
    req.fields.addAll({
      "Token": _token!,
      "ADD": "True",
      "Naziv": package.title,
      "Opis": package.description,
      "Popust": package.discount.toString(),
      "KolicinaPaketa": package.itemCount.toString(),
      "KorisnickoIme": await SecureStorage.getUsername(),
    });
    if (package.imageFile != null)
      req.files.add(
        http.MultipartFile.fromBytes(
          'Slika',
          filename: 'Slika',
          await package.imageFile!.readAsBytes(),
        ),
      );
    http.StreamedResponse responseData;
    try {
      responseData = await req.send();
      return responseData;
    } catch (e) {
      throw Exception("Failed to connect");
    }
  }

  static Future addProductsToPackage(List<int> ids, List<int> amounts, int packageId) async {
    String username = await SecureStorage.getUsername();
    List<http.MultipartRequest> reqs = List.generate(ids.length, (index) {
      http.MultipartRequest req = http.MultipartRequest('POST', route(Routes.paketi));
      req.fields.addAll({
        "Token": _token!,
        "ADDTOPACKET": true.toString(),
        "Id_Paket": packageId.toString(),
        "KorisnickoIme": username,
      });
      req.fields.addEntries([MapEntry("Id_Proizvod[]", ids[index].toString())]);
      req.fields.addEntries([MapEntry("Kolicina[]", amounts[index].toString())]);
      return req;
    });

    for (var req in reqs) {
      try {
        // NOTE: using keyword "await" makes it only add 1 item to the package for some reason
        // I think the backend code might delete the old package and create an entirely new one, every time it adds a product
        req.send(); // adding Future.delayed(Duration(milliseconds(100 * i), () => req.send)) didnt solve the issue
      } catch (e) {
        throw Exception("Failed to connect");
      }
    }
    // TODO: for some reason sends up to only 2 requests, or maybe the third gets
    // cut off midway by the processing of the first two - adding delay didn't help, same issue
    return 200;
  }

  static Future deletePackage(int packageId) async {
    http.MultipartRequest req = http.MultipartRequest('POST', route(Routes.paketi));
    req.fields.addAll({
      "Token": _token!,
      "Id": packageId.toString(),
      "DELETE": true.toString(),
      "KorisnickoIme": await SecureStorage.getUsername(),
    });
    http.StreamedResponse responseData;
    try {
      responseData = await req.send();
      return responseData;
    } catch (e) {
      throw Exception("Failed to connect");
    }
  }

  static Future deleteProduct(int productId) async {
    http.MultipartRequest req = http.MultipartRequest('POST', route(Routes.proizvodi));
    req.fields.addAll({
      "Token": _token!,
      "Id": productId.toString(),
      "KorisnickoIme": await SecureStorage.getUsername(),
    });
    http.StreamedResponse responseData;
    try {
      responseData = await req.send();
      return responseData;
    } catch (e) {
      throw Exception("Failed to connect");
    }
  }

  /*
   "Edit": Edit: Boolean,
   "Token": Token: String,
   "Id": Id: Int,
   "Naziv": Naziv: String,
   "Opis": Opis: String,
   "Cijena": Cijena: String?,
   "Kolicina": Kolicina: Int,
   "Slika": Slika: String,
   "KorisnickoIme": KorisnickoIme: String
  */

  static Future editProduct(ConstantProductData product) async {
    http.MultipartRequest req = http.MultipartRequest('POST', route(Routes.proizvodi));
    req.fields.addAll({
      "Edit": true.toString(),
      "Token": _token!,
      "Id": product.id.toString(),
      "Naziv": product.title,
      "Opis": product.description,
      "Cijena": product.price.toString(),
      "Kolicina": "1",
      "KorisnickoIme": await SecureStorage.getUsername(),
    });
    if (product.imageFile != null && product.imagePath == null)
      req.files.add(
        http.MultipartFile.fromBytes(
          'Slika',
          filename: 'Slika',
          await product.imageFile!.readAsBytes(),
        ),
      );
    else
      req.fields.addAll({"Slika": product.imagePath ?? ""});
    http.StreamedResponse responseData;
    try {
      responseData = await req.send();
      return responseData;
    } catch (e) {
      throw Exception("Failed to connect");
    }
  }
}
