import 'package:flutter/material.dart';

import '../providers/cart.dart';

class OrderItem {
  final String orderId;
  final DateTime orderTime;
  final double orderTotalAmount;
  final List<CartItem> orderProducts;

  OrderItem({
    required this.orderId,
    required this.orderTime,
    required this.orderTotalAmount,
    required this.orderProducts,
  });
}

class Order with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get getOrders {
    return [..._orders];
  }

  int orderCount() {
    return _orders.length;
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
        0,
        OrderItem(
          orderId: DateTime.now().toString(),
          orderTime: DateTime.now(),
          orderTotalAmount: total,
          orderProducts: cartProducts,
        ));
    notifyListeners();
  }
}
