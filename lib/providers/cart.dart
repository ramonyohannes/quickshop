import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final String discription;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.discription,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get getItems {
    return {..._items};
  }

  int get getItemCount {
    return _items.length;
  }

  void addCartItem(
      String productId, String title, String discription, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                discription: existingCartItem.discription,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          discription: discription,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach(
      (key, cartItem) {
        total += cartItem.price * cartItem.quantity;
      },
    );

    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
