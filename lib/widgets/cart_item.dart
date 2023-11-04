import 'package:flutter/material.dart';

class CartItems extends StatelessWidget {
  final String title;
  final double price;
  final int quantity;

  const CartItems({
    super.key,
    required this.title,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: FittedBox(
            fit: BoxFit.cover,
            child: Text(
              "\$${price.toStringAsFixed(1)}",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ),
        title: Text(title),
        subtitle: Text(
          "Total: \$${(price * quantity)}",
        ),
        trailing: Text("$quantity x"),
      ),
    );
  }
}
