import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProducts extends StatefulWidget {
  const EditProducts({super.key});
  static const routeName = '/edit-products';

  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  bool _isInit = true;

  final _formKey = GlobalKey<FormState>();

  final _imageTextController = TextEditingController();

  final _titleFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _discriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_handleImageUrlFocusChange);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      if (productId != null && productId.isNotEmpty) {
        final product = Provider.of<Products>(context, listen: false)
            .findProductById(productId);
        editedProduct = Product(
          productId: product.productId,
          productTitle: product.productTitle,
          productDiscription: product.productDiscription,
          productPrice: product.productPrice,
          productImageUrl: product.productImageUrl,
        );
        _imageTextController.text = editedProduct.productImageUrl;
      }
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  void _handleImageUrlFocusChange() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageTextController.text.isEmpty ||
          (!_imageTextController.text.startsWith('http') &&
              !_imageTextController.text.startsWith('https')) ||
          (!_imageTextController.text.endsWith('.png') &&
              !_imageTextController.text.endsWith('.jpg') &&
              !_imageTextController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  var editedProduct = Product(
    productId: "",
    productTitle: "",
    productDiscription: "",
    productPrice: 0.0,
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
    final isValid = _formKey.currentState!.validate();
    _formKey.currentState!.save();
    if (isValid) {
      if (editedProduct.productId.isNotEmpty) {
        Provider.of<Products>(context, listen: false)
            .updateProduct(editedProduct.productId, editedProduct);
        Navigator.of(context).pop();
      } else {
        Provider.of<Products>(context, listen: false).addProduct(editedProduct);
        Navigator.of(context).pop();
      }
    }
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
                initialValue: editedProduct.productTitle,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: _titleFocusNode,
                validator: (value) {
                  if (value == null || value.toString().isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
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
                initialValue: editedProduct.productPrice.toString(),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                validator: (value) {
                  if (value == null || value.toString().isEmpty) {
                    return 'Please enter a price';
                  }
                  try {
                    double price = double.parse(value.toString());
                    if (price <= 0) {
                      return 'Price must be greater than zero';
                    }
                  } catch (e) {
                    return 'Invalid price format';
                  }
                  return null;
                },
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
                initialValue: editedProduct.productDiscription,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
                focusNode: _discriptionFocusNode,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.toString().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
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
                    child: _imageTextController.text.isEmpty
                        ? const Text(
                            "ImageUrl",
                            textAlign: TextAlign.center,
                          )
                        : FittedBox(
                            child: Image.network(
                              _imageTextController.text.toString(),
                              fit: BoxFit.cover,
                            ),
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
                      validator: (value) {
                        if (value == null || value.toString().isEmpty) {
                          return 'Please enter an image URL';
                        }
                        if (!(value.toString().endsWith('.png') ||
                            value.toString().endsWith('.jpg'))) {
                          return 'Invalid image format. Supported formats are PNG and JPG';
                        }
                        return null;
                      },
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
