import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
  bool _isDataFetched = false;
  late Future<void> _fetchDataFuture = Future.value();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataFetched) {
      // Trigger the fetching of data only once
      _fetchDataFuture = Provider.of<Products>(context, listen: false)
          .fetchandResetUserProducts();
      _isDataFetched = true;
    }
  }

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

  Widget shimmerGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (ctx, i) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 6,
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GridTile(
              footer: Container(
                color: Colors.grey,
                height: 15.0,
              ),
              child: Container(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
      itemCount: 6,
      padding: const EdgeInsets.all(5.0),
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
          future: _fetchDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // return const Center(child: CircularProgressIndicator());
              return shimmerGrid();
            } else if (snapshot.hasError) {
              return errorAlertDialog(context);
            } else {
              return ProductsGrid(_showOnlyFavorites);
            }
          },
        ));
  }
}
