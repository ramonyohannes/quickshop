import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/cart.dart';

import '../providers/products.dart';
import '../screens/cart_screen.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/side_drawer.dart';

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

  AlertDialog errorAlertDialog(BuildContext ctx) {
    return const AlertDialog(
      title: Text("An error occured"),
      content: Text("Something went wrong, Retry lator!"),
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
                      value: cart.getCartItemCount.toString(),
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
        drawer: const SideDrawer(),
        body: FutureBuilder(
          future: Provider.of<Products>(context, listen: false)
              .fetchandResetUserProducts(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                if (snapshot.hasError) return errorAlertDialog(context);
                return ProductsGrid(_showOnlyFavorites);
            }
          },
        ));
  }
}
