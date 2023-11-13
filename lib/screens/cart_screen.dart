import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/order.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart-screen";

  const CartScreen({Key? key}) : super(key: key);

  Chip buildChip(BuildContext context, String label) {
    return Chip(
      label: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.cartItems.values.toList();
    final order = Provider.of<Order>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Total",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    buildChip(context,
                        cart.totalCartProductsAmount.toStringAsFixed(2)),
                    const SizedBox(
                      width: 10,
                    ),
                    OrderButton(order: order, cartItems: cartItems, cart: cart)
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                String key = cart.cartItems.keys.toList()[index];
                return CartItems(
                  productId: key,
                  title: cartItems[index].productTitle,
                  price: cartItems[index].productPrice,
                  quantity: cartItems[index].quantity,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.order,
    required this.cartItems,
    required this.cart,
  });

  final Order order;
  final List<CartItem> cartItems;
  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await widget.order.addOrder(
                widget.cartItems,
                widget.cart.totalCartProductsAmount,
              );
              setState(() {
                isLoading = false;
              });
              widget.cart.clearCart();
            },
      child: isLoading
          ? const CircularProgressIndicator()
          : Text(
              "Order Now",
              style: Theme.of(context).textTheme.labelLarge,
            ),
    );
  }
}
