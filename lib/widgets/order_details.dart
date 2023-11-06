import 'dart:math';

import 'package:flutter/material.dart';

import '../providers/order.dart';

class OrderDetails extends StatelessWidget {
  final OrderItem orderItemValue;
  const OrderDetails(this.orderItemValue, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: min(orderItemValue.orderProducts.length * 20.0 + 10, 100),
        child: ListView.builder(
          itemCount: orderItemValue.orderProducts.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    orderItemValue.orderProducts[index].productTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${orderItemValue.orderProducts[index].quantity}x \$${orderItemValue.orderProducts[index].productPrice}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
