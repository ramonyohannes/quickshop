import 'package:flutter/material.dart';

import '../screens/products_detail_screen.dart';

class ProductsItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const ProductsItem({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  void selectProduct(BuildContext context) {
    Navigator.of(context).pushNamed(
      ProductDetailScreen.routeName,
      arguments: id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          footer: GridTileBar(
            title: Text(title),
            backgroundColor: Colors.black87,
            leading: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
            ),
          ),
          child: InkWell(
            onTap: () => selectProduct(context),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
