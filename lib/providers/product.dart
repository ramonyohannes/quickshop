import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Product with ChangeNotifier {
  final String productId;
  final String productTitle;
  final String productDiscription;
  final double productPrice;
  final String productImageUrl;
  bool isProductFavorite;
  Product({
    required this.productId,
    required this.productTitle,
    required this.productDiscription,
    required this.productPrice,
    required this.productImageUrl,
    this.isProductFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String authToken) async {
    final url =
        "https://quickcart-8cf4a-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken";
    final oldStatus = isProductFavorite;

    try {
      isProductFavorite = !isProductFavorite;
      notifyListeners();

      final responce = await patch(Uri.parse(url),
          body: jsonEncode({
            "isProductFavorite": !isProductFavorite,
          }));

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
