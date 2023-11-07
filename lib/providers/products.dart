import 'package:flutter/material.dart';

import 'product.dart';

class Products with ChangeNotifier {
  final List<Product> _productItems = [
    Product(
      productId: 'p1',
      productTitle: 'Red Shirt',
      productDiscription: 'A red shirt - it is pretty red!',
      productPrice: 29.99,
      productImageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      productId: 'p2',
      productTitle: 'Trousers',
      productDiscription: 'A nice pair of trousers.',
      productPrice: 59.99,
      productImageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      productId: 'p3',
      productTitle: 'Yellow Scarf',
      productDiscription:
          'Warm and cozy - exactly what you need for the winter.',
      productPrice: 19.99,
      productImageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      productId: 'p4',
      productTitle: 'A Pan',
      productDiscription: 'Prepare any meal you want.',
      productPrice: 49.99,
      productImageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get productItems {
    return [..._productItems];
  }

  List<Product> get favoriteProducts {
    return _productItems
        .where((element) => element.getIsProductFavorite)
        .toList();
  }

  Product findProductById(String id) {
    return _productItems.firstWhere((element) => element.productId == id);
  }

  void addProduct(Product product) {
    final newProduct = Product(
      productId: DateTime.now().toString(),
      productTitle: product.productTitle,
      productDiscription: product.productDiscription,
      productPrice: product.productPrice,
      productImageUrl: product.productImageUrl,
    );
    _productItems.add(newProduct);
    notifyListeners();
  }
}
