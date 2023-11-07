import 'package:flutter/material.dart';

class CartItem {
  final String cartId;
  final String productTitle;
  final String productDiscription;
  final double productPrice;
  final int quantity;

  CartItem({
    required this.cartId,
    required this.productTitle,
    required this.productDiscription,
    required this.productPrice,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems {
    return {..._cartItems};
  }

  int get getCartItemCount {
    return _cartItems.length;
  }

  void addCartItem(
      String productId, String title, String discription, double price) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (existingCartItem) => CartItem(
                cartId: existingCartItem.cartId,
                productTitle: existingCartItem.productTitle,
                productDiscription: existingCartItem.productDiscription,
                productPrice: existingCartItem.productPrice,
                quantity: existingCartItem.quantity + 1,
              ));
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => CartItem(
          cartId: DateTime.now().toString(),
          productTitle: title,
          productDiscription: discription,
          productPrice: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  double get totalCartProductsAmount {
    var total = 0.0;
    _cartItems.forEach(
      (key, cartItem) {
        total += cartItem.productPrice * cartItem.quantity;
      },
    );

    return total;
  }

  void removeCartItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_cartItems.containsKey(productId)) {
      return;
    }
    if (_cartItems[productId]!.quantity > 1) {
      _cartItems.update(
          productId,
          (existingCartItem) => CartItem(
                cartId: existingCartItem.cartId,
                productTitle: existingCartItem.productTitle,
                productDiscription: existingCartItem.productDiscription,
                productPrice: existingCartItem.productPrice,
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      _cartItems.remove(productId);
    }
    notifyListeners();
  }
}
