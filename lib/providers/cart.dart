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

  void addCartItem(String id) {
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                discription: existingCartItem.discription,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          id,
          () => CartItem(
                id: DateTime.now().toString(),
                title: 'title',
                discription: 'discription',
                price: 0.0,
                quantity: 1,
              ));
    }
    notifyListeners();
  }
}
