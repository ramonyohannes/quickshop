import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickCart'),
        actions: [buildPopupMenuButton()],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
