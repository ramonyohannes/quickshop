import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Product with ChangeNotifier {
  final String creatorId;
  final String productId;
  final String productTitle;
  final String productDiscription;
  final double productPrice;
  final String productImageUrl;
  bool isProductFavorite;
  Product({
    required this.creatorId,
    required this.productId,
    required this.productTitle,
    required this.productDiscription,
    required this.productPrice,
    required this.productImageUrl,
    this.isProductFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final url =
        "https://quickcart-8cf4a-default-rtdb.firebaseio.com/userFavorites/$userId/$productId.json?auth=$authToken";
    final oldStatus = isProductFavorite;

    try {
      isProductFavorite = !isProductFavorite;
      notifyListeners();

      if (isProductFavorite == false) {
        delete(Uri.parse(url));
        return;
      }

      final responce = await put(Uri.parse(url),
          body: jsonEncode(
            {
              "isUserFavorite": true,
            },
          ));

      if (responce.statusCode >= 400) {
        isProductFavorite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isProductFavorite = oldStatus;
      notifyListeners();
    }
  }

  bool get getIsProductFavorite {
    return isProductFavorite;
  }
}
