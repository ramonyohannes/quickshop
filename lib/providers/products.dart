import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart';

import 'product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _productItems = [
    // Product(
    //   productId: 'p1',
    //   productTitle: 'Red Shirt',
    //   productDiscription: 'A red shirt - it is pretty red!',
    //   productPrice: 29.99,
    //   productImageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   productId: 'p2',
    //   productTitle: 'Trousers',
    //   productDiscription: 'A nice pair of trousers.',
    //   productPrice: 59.99,
    //   productImageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   productId: 'p3',
    //   productTitle: 'Yellow Scarf',
    //   productDiscription:
    //       'Warm and cozy - exactly what you need for the winter.',
    //   productPrice: 19.99,
    //   productImageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   productId: 'p4',
    //   productTitle: 'A Pan',
    //   productDiscription: 'Prepare any meal you want.',
    //   productPrice: 49.99,
    //   productImageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, List<Product> productItems)
      : _productItems = productItems;

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

  Future<void> fetchandResetUserProducts([bool filterByUser = false]) async {
    String filterLogic = filterByUser &&
            !_productItems.any((product) => product.creatorId == userId)
        ? 'filterBy="creatorId"&equalTo="$userId"'
        : 'orderBy="creatorId"&equalTo="$userId"';

    String filterString = filterByUser ? filterLogic : '';

    var url =
        "https://quickcart-8cf4a-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString";

    final response = await get(Uri.parse(url));

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    if (responseData.isEmpty) {
      return;
    }

    url =
        "https://quickcart-8cf4a-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken";
    final favoriteResponse = await get(Uri.parse(url));
    final favoriteData = jsonDecode(favoriteResponse.body);
    if (responseData.isEmpty) {
      return;
    }

    final List<Product> fetchedProducts = [];

    responseData.forEach((productId, productData) {
      final newProduct = Product(
        creatorId: productData['creatorId'],
        productId: productId,
        productTitle: productData['productTitle'],
        productDiscription: productData['productDiscription'],
        productPrice: productData['productPrice'],
        productImageUrl: productData['productImageUrl'],
        isProductFavorite:
            favoriteData == null ? false : favoriteData[productId] ?? false,
      );
      fetchedProducts.add(newProduct);
    });

    _productItems.clear();
    _productItems.addAll(fetchedProducts);
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final url =
        "https://quickcart-8cf4a-default-rtdb.firebaseio.com/products.json?auth=$authToken";
    try {
      final response = await post(Uri.parse(url),
          body: jsonEncode({
            "creatorId": userId,
            "productTitle": product.productTitle,
            "productDiscription": product.productDiscription,
            "productPrice": product.productPrice,
            "productImageUrl": product.productImageUrl,
          }));

      final newProduct = Product(
        creatorId: userId,
        productId: jsonDecode(response.body)['name'],
        productTitle: product.productTitle,
        productDiscription: product.productDiscription,
        productPrice: product.productPrice,
        productImageUrl: product.productImageUrl,
      );
      _productItems.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String productId, Product editedProduct) async {
    final url =
        "https://quickcart-8cf4a-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken";

    try {
      await patch(Uri.parse(url),
          body: jsonEncode({
            "productTitle": editedProduct.productTitle,
            "productDiscription": editedProduct.productDiscription,
            "productPrice": editedProduct.productPrice,
            "productImageUrl": editedProduct.productImageUrl,
          }));

      final productIndex =
          _productItems.indexWhere((element) => element.productId == productId);
      if (productIndex >= 0) {
        _productItems[productIndex] = editedProduct;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url =
        "https://quickcart-8cf4a-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken";

    try {
      final productIndex =
          productItems.indexWhere((element) => element.productId == productId);
      final product = productItems[productIndex];

      _productItems.removeWhere((element) => element.productId == productId);
      notifyListeners();

      final response = await delete(Uri.parse(url));
      if (response.statusCode >= 400) {
        _productItems.insert(productIndex, product);
        notifyListeners();
        throw HttpException("Could not delete product");
      }

      // Delete the product from user favorites
      final favoriteUrl =
          "https://quickcart-8cf4a-default-rtdb.firebaseio.com/userFavorites/$userId/$productId.json?auth=$authToken";
      final favoriteResponce = await delete(Uri.parse(favoriteUrl));

      if (favoriteResponce.statusCode >= 400) {
        _productItems.insert(productIndex, product);
        notifyListeners();
        throw HttpException("Could not delete product");
      }
    } catch (error) {
      rethrow;
    }
  }
}
