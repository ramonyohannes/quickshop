import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
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
}
