import 'package:flutter/material.dart';
import 'package:quickcart_app/screens/cart_screen.dart';

import '../providers/cart.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

import 'package:provider/provider.dart';

enum MenuOption {
  onlyFavorited,
  showAll,
}

class ProductsOverViewScreen extends StatefulWidget {
  const ProductsOverViewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverViewScreen> createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  bool _showOnlyFavorites = false;

  void selectProduct(BuildContext context) {
    Navigator.of(context).pushNamed(
      CartScreen.routeName,
    );
  }

  PopupMenuButton<MenuOption> buildPopupMenuButton() {
    return PopupMenuButton<MenuOption>(
      onSelected: (MenuOption choice) {
        setState(() {
          _showOnlyFavorites = choice == MenuOption.onlyFavorited;
        });
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<MenuOption>>[
          const PopupMenuItem<MenuOption>(
            value: MenuOption.showAll,
            child: Text('Show All'),
          ),
          const PopupMenuItem<MenuOption>(
            value: MenuOption.onlyFavorited,
            child: Text('Only Favorite'),
          ),
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickCart'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                buildPopupMenuButton(),
                InkWell(
                  onTap: () => selectProduct(context),
                  child: CartBadge(
                    value: cart.getItemCount.toString(),
                    child: const Icon(
                      Icons.shopping_cart_rounded,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
