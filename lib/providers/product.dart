import 'package:flutter/material.dart';

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

  void toggleFavoriteStatus() {
    isProductFavorite = !isProductFavorite;
    notifyListeners();
  }

  bool get getIsProductFavorite {
    return isProductFavorite;
  }
}
