import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../widgets/order_details.dart';

import '../providers/order.dart';

class OrderItems extends StatefulWidget {
  final OrderItem orderItemValue;
  const OrderItems(this.orderItemValue, {super.key});

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "\$${widget.orderItemValue.orderTotalAmount}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              DateFormat.yMEd().format(widget.orderItemValue.orderTime),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: expanded
                  ? const Icon(Icons.expand_more)
                  : const Icon(Icons.expand_less),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
            ),
          ),
          if (expanded) OrderDetails(widget.orderItemValue),
        ],
      ),
    );
  }
}
