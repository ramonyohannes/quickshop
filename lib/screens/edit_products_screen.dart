import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcart_app/providers/products.dart';

import '../providers/product.dart';

class EditProducts extends StatefulWidget {
  const EditProducts({super.key});
  static const routeName = '/edit-products';

  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  final _formKey = GlobalKey<FormState>();
  final _imageTextController = TextEditingController();

  final _titleFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _discriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  var editedProduct = Product(
    productId: "",
    productTitle: "",
    productDiscription: "",
    productPrice: 0,
    productImageUrl: "",
  );

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _imageTextController.dispose();
    _priceFocusNode.dispose();
    _discriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() {
    _formKey.currentState!.save();
    Provider.of<Products>(context, listen: false).addProduct(editedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Products"),
        actions: [
          IconButton(
            onPressed: () => _submitForm(),
            icon: Icon(
              Icons.save,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Title"),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: _titleFocusNode,
                onSaved: (newValue) {
                  setState(() {
                    editedProduct = Product(
                      productId: editedProduct.productId,
                      productTitle: newValue.toString(),
                      productDiscription: editedProduct.productDiscription,
                      productPrice: editedProduct.productPrice,
                      productImageUrl: editedProduct.productImageUrl,
                    );
                  });
                },
                onFieldSubmitted: (value) {
                  _titleFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                onSaved: (newValue) {
                  editedProduct = Product(
                    productId: editedProduct.productId,
                    productTitle: editedProduct.productTitle,
                    productDiscription: editedProduct.productDiscription,
                    productPrice: double.parse(newValue.toString()),
                    productImageUrl: editedProduct.productImageUrl,
                  );
                },
                onFieldSubmitted: (value) {
                  _priceFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_discriptionFocusNode);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
                focusNode: _discriptionFocusNode,
                maxLines: 3,
                onSaved: (newValue) {
                  editedProduct = Product(
                    productId: editedProduct.productId,
                    productTitle: editedProduct.productTitle,
                    productDiscription: newValue.toString(),
                    productPrice: editedProduct.productPrice,
                    productImageUrl: editedProduct.productImageUrl,
                  );
                },
                onFieldSubmitted: (value) {
                  _discriptionFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    // child: _imageTextController.text.isEmpty
                    //     ? const Text(
                    //         "ImageUrl",
                    //         textAlign: TextAlign.center,
                    //       )
                    //     : FittedBox(
                    //         child: Image.network(
                    //           _imageTextController.value.toString(),
                    //           fit: BoxFit.cover,
                    //         ),
                    //       ),
                    child: const Text(
                      "ImageUrl",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: "ImageUrl"),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: _imageTextController,
                      focusNode: _imageUrlFocusNode,
                      onSaved: (newValue) {
                        editedProduct = Product(
                          productId: editedProduct.productId,
                          productTitle: editedProduct.productTitle,
                          productDiscription: editedProduct.productDiscription,
                          productPrice: editedProduct.productPrice,
                          productImageUrl: newValue.toString(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
