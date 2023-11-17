import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String token = "";
  String userId = "";
  DateTime expiryDate = DateTime.now();
  Timer? expiryTimer;

  bool get isAuth {
    return token.isNotEmpty;
  }

  String get getToken {
    if (expiryDate.isAfter(DateTime.now()) && token.isNotEmpty) {
      return token;
    }
    return "";
  }

  Future<void> authenticate(
    String email,
    String password,
    String urlSegnment,
  ) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegnment?key=AIzaSyD-nvfc0AJl1FCsPlTDd5MhLYTNlNO_M2o");

    try {
      final response = await post(
        url,
        body: jsonEncode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }),
      );
      //print(jsonDecode(response.body));
      final responseData = jsonDecode(response.body);
      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]["message"]);
      }

      token = responseData["idToken"];
      userId = responseData["localId"];
      expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData["expiresIn"],
          ),
        ),
      );
      autoLogout();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return authenticate(email, password, "signUp");
  }

  Future<void> signIn(String email, String password) async {
    return authenticate(email, password, "signInWithPassword");
  }

  Future<void> logout() async {
    token = "";
    userId = "";
    expiryDate = DateTime.now();
    if (expiryTimer != null) {
      expiryTimer!.cancel();
    }
    expiryTimer = Timer(Duration.zero, () {});
    notifyListeners();
  }

  Future<void> autoLogout() async {
    final timeToExpiry = expiryDate.difference(DateTime.now()).inSeconds;
    if (expiryTimer != null) {
      expiryTimer!.cancel();
    }
    expiryTimer = Timer(Duration(seconds: timeToExpiry), logout);
    notifyListeners();
  }
}
