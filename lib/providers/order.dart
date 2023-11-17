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
  // ignore: prefer_final_fields
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;
  Order(this.authToken, this.userId, List<OrderItem> orderItems)
      : _orders = orderItems;

  List<OrderItem> get getOrders {
    return [..._orders];
  }

  int orderCount() {
    return _orders.length;
  }

  Future<void> fetchandResetOrders() async {
    final url =
        "https://quickcart-8cf4a-default-rtdb.firebaseio.com/orders.json?auth=$authToken";

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
    final url =
        "https://quickcart-8cf4a-default-rtdb.firebaseio.com/orders.json?auth=$authToken";
    var currentDateTime = DateTime.now();

    final response = await post(
      Uri.parse(url),
      body: jsonEncode({
        "orderTime": currentDateTime.toIso8601String(),
        "orderAmount": total,
        "orderProducts": cartProducts
            .map((cartProduct) => {
                  "cartId": cartProduct.cartId,
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
