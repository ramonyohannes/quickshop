import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart';

import '../providers/cart.dart';

class OrderItem {
  final String orderId;
  final DateTime orderTime;
  final double orderAmount;
  final List<CartItem> orderProducts;

  OrderItem({
    required this.orderId,
    required this.orderTime,
    required this.orderAmount,
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

  Future<void> fetchandResetOrders() async {
    const url =
        "https://quickcart-8cf4a-default-rtdb.firebaseio.com/orders.json";

    final response = await get(Uri.parse(url));
    final resposeData = jsonDecode(response.body) as Map<String, dynamic>;

    if (resposeData.isEmpty) {
      return;
    }
    final List<OrderItem> fetchedOrders = [];

    resposeData.forEach((orderId, orderData) {
      final newOrder = OrderItem(
        orderId: orderId,
        orderTime: DateTime.parse(orderData['orderTime']),
        orderAmount: orderData['orderAmount'],
        orderProducts: (orderData['orderProducts'] as List<dynamic>)
            .map(
              (orderProduct) => CartItem(
                cartId: orderProduct['productId'],
                productTitle: orderProduct['productTitle'],
                productDiscription: "",
                productPrice: orderProduct['productPrice'],
                quantity: orderProduct['quantity'],
              ),
            )
            .toList(),
      );
      fetchedOrders.add(newOrder);
      _orders.clear();
      _orders.addAll(fetchedOrders.reversed);
      notifyListeners();
    });
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url =
        "https://quickcart-8cf4a-default-rtdb.firebaseio.com/orders.json";
    var currentDateTime = DateTime.now();

    final response = await post(
      Uri.parse(url),
      body: jsonEncode({
        "orderTime": currentDateTime.toIso8601String(),
        "orderAmount": total,
        "orderProducts": cartProducts
            .map((cartProduct) => {
                  "productId": cartProduct.cartId,
                  "productTitle": cartProduct.productTitle,
                  "productPrice": cartProduct.productPrice,
                  "quantity": cartProduct.quantity,
                })
            .toList(),
      }),
    );

    _orders.insert(
        0,
        OrderItem(
          orderId: jsonDecode(response.body)["name"],
          orderTime: DateTime.now(),
          orderAmount: total,
          orderProducts: cartProducts,
        ));
    notifyListeners();
  }
}
