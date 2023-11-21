import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../screens/edit_products_screen.dart';

class UserProductsItem extends StatelessWidget {
  final String productId;
  final String productTitle;
  final String productImageUrl;
  final Function reloadPage;

  const UserProductsItem({
    super.key,
    required this.productId,
    required this.productTitle,
    required this.productImageUrl,
    required this.reloadPage,
  });

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    var scaffold = ScaffoldMessenger.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(productImageUrl),
      ),
      title: Text(productTitle),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    EditProducts.routeName,
                    arguments: {
                      'productId': productId,
                      'reloadPage': reloadPage,
                    },
                  );
                },
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                )),
            DeleteProduct(
              productData: productData,
              productId: productId,
              reloadPage: reloadPage,
              scaffold: scaffold,
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteProduct extends StatefulWidget {
  DeleteProduct({
    super.key,
    required this.productData,
    required this.productId,
    required this.reloadPage,
    required this.scaffold,
  });

  final Products productData;
  final String productId;
  final Function reloadPage;
  final ScaffoldMessengerState scaffold;
  bool isLoading = false;

  @override
  State<DeleteProduct> createState() => _DeleteProductState();
}

class _DeleteProductState extends State<DeleteProduct> {
  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? const CircularProgressIndicator()
        : IconButton(
            onPressed: () async {
              try {
                setState(() {
                  widget.isLoading = true;
                });
                await widget.productData.deleteProduct(widget.productId);
                setState(() {
                  widget.isLoading = false;
                });
                widget.scaffold.showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text(
                      "Deleted Successfully!",
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
                widget.reloadPage();
              } catch (error) {
                widget.scaffold.showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text(
                      "Deleting Failed!",
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
            ),
          );
  }
}
