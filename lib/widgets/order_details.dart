import 'dart:math';

import 'package:flutter/material.dart';

import '../providers/order.dart';

class OrderDetails extends StatelessWidget {
  final OrderItem orderItemValue;
  final bool expanded;
  const OrderDetails(this.orderItemValue, this.expanded, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: expanded
              ? min(orderItemValue.orderProducts.length * 20.0 + 110, 200)
              : 0,
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
      ),
    );
  }
}
