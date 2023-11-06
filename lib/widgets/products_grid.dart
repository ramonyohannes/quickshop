import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/products.dart';

import './products_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool isFavorite;
  const ProductsGrid(this.isFavorite, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loadedProducts = isFavorite
        ? Provider.of<Products>(context).favoriteProducts
        : Provider.of<Products>(context).productItems;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: loadedProducts.length,
      itemBuilder: (BuildContext context, int index) {
        return ChangeNotifierProvider.value(
          value: loadedProducts[index],
          child: const ProductsItem(),
        );
      },
    );
  }
}
