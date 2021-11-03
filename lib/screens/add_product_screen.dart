import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widgets/product_image_picker.dart';
import '../category_list.dart';
import '../retailer_list.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = '/add-product';

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  GlobalKey<FormState> _formKey;
  bool checkboxValue = false;
  var _selectedValue;
  var _categories = List<DropdownMenuItem>();
  var _selectedRetailer;
  var _retailers = List<DropdownMenuItem>();
  TextEditingController _nameController;
  TextEditingController _barcodeController;
  TextEditingController _priceController;
  final _barcodeFocusNode = FocusNode();
  File _productImageFile;
  String _scanBarcode = '';
  List _products = [];
  var _isLoading = false;

  @override
  void initState() {
    _nameController = TextEditingController();
    _barcodeController = TextEditingController();
    _priceController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    super.initState();
    _loadCategories();
    _loadRetailers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _priceController.dispose();
    _barcodeFocusNode.dispose();
    super.dispose();
  }

  void _loadCategories() {
    var categories = ProductCategories;
    categories.forEach((category) {
      setState(() {
        _categories.add(
          DropdownMenuItem(
            child: Text(category.title),
            value: category.title,
          ),
        );
      });
    });
  }

  void _loadRetailers() {
    var retailers = retailerList;
    retailers.forEach((retailer) {
      setState(() {
        _retailers.add(
          DropdownMenuItem(
            child: Text(retailer.name),
            value: retailer.name,
          ),
        );
      });
    });
  }

  void _pickedImage(File image) {
    _productImageFile = image;
  }

  Future<void> _barcodeScanner() async {
    String barcode;
    try {
      barcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcode);
    } on PlatformException {
      barcode = 'Failed to get platform version';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcode;
    });
  }

  void _addProduct() async {
    FocusScope.of(context).unfocus();
    try {
      setState(() {
        _isLoading = true;
      });

      // Get the document ID
      var docRef =
          Firestore.instance.collection('products').document().documentID;

      // Store the product image in Firebase Storage
      final imgRef = FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child(docRef + '/' + DateTime.now().toIso8601String() + '.jpg');

      await imgRef.putFile(_productImageFile).onComplete;

      // Get the imageURL for the image uploaded
      final imageUrl = await imgRef.getDownloadURL();

      // List retailerPriceList = [];
      // retailerPriceList.add({
      //   'retailer': _selectedRetailer,
      //   'price': _priceController.text.trim(),
      // });

      // await Firestore.instance.collection('products').document(docRef).setData({
      //   'name': _nameController.text.trim(),
      //   'barcode': _barcodeController.text.trim(),
      //   'category': _selectedValue,
      //   'imageUrl': imageUrl,
      //   'retailPrices': FieldValue.arrayUnion(retailerPriceList),
      // });

      // Query for adding product to Cloud Firestore
      await Firestore.instance.collection('products').document(docRef).setData({
        'productID': docRef,
        'name': _nameController.text.trim(),
        'barcode': _barcodeController.text.trim(),
        'category': _selectedValue,
        'imageUrl': imageUrl,
      }).then((value) {
        // Get the ID for the sub-collection document
        var docId = Firestore.instance
            .collection('products')
            .document(docRef)
            .collection('retailPrice')
            .document()
            .documentID;

        // Storing retailer and price information in sub-collection
        Firestore.instance
            .collection('products')
            .document(docRef)
            .collection('retailPrice')
            .document(docId)
            .setData({
          'id': docId,
          'retailer': _selectedRetailer,
          'price': double.parse(_priceController.text),
          'lastUpdate': DateTime.now(),
        });
      });
    } on PlatformException catch (error) {
      var message = 'An error occurred, failed to add product';

      if (error.message != null) {
        message = error.message;
      }

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Retrieve products for barcode checking
  _getProducts() async {
    try {
      var _collectionReference =
          await Firestore.instance.collection('products').getDocuments();

      if (this.mounted) {
        setState(() {
          _products = _collectionReference.documents;
        });
      }
      return _collectionReference.documents;
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text('Add Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState.validate() &&
                  _productImageFile != null) {
                _addProduct();
                Navigator.pop(context);
              } else {
                if (_productImageFile == null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        clipBehavior: Clip.antiAlias,
                        title: Text('Please upload an image!'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Dismiss'))
                        ],
                      );
                    },
                  );
                }
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: SpinKitThreeBounce(
                color: Theme.of(context).primaryColor,
                size: 30.0,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Product image',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ProductImagePicker(_pickedImage),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Product name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor,
                              spreadRadius: 2,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'Enter product name',
                              border: InputBorder.none,
                              errorStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              errorMaxLines: 1,
                            ),
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a product name';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_barcodeFocusNode);
                            },
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Product barcode',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      FutureBuilder(
                        future: _getProducts(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.none &&
                              snapshot.connectionState ==
                                  ConnectionState.waiting &&
                              snapshot.hasData == null) {
                            return Center(
                              child: SpinKitThreeBounce(
                                color: Theme.of(context).primaryColor,
                                size: 30.0,
                              ),
                            );
                          }
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 250,
                                    child: TextFormField(
                                      controller: _barcodeController,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Enter or scan product barcode',
                                        border: InputBorder.none,
                                        errorStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        errorMaxLines: 1,
                                      ),
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a barcode';
                                        } else {
                                          for (int i = 0;
                                              i < _products.length;
                                              i++) {
                                            String barcode =
                                                _products[i].data['barcode'];
                                            if (value.contains(barcode)) {
                                              return 'Barcode has been recorded!';
                                            }
                                          }
                                        }
                                        return null;
                                      },
                                      focusNode: _barcodeFocusNode,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.qr_code_scanner,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    onPressed: () {
                                      _barcodeScanner().then(
                                        (value) {
                                          _barcodeController =
                                              TextEditingController(
                                                  text: _scanBarcode);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Product category',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor,
                              spreadRadius: 2,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            value: _selectedValue,
                            items: _categories,
                            hint: Text('Select a category'),
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              errorStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              errorMaxLines: 1,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Retailer',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor,
                              spreadRadius: 2,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            value: _selectedRetailer,
                            items: _retailers,
                            hint: Text('Select a retailer'),
                            onChanged: (value) {
                              setState(() {
                                _selectedRetailer = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              errorStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              errorMaxLines: 1,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a retailer';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Product price',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor,
                              spreadRadius: 2,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: TextFormField(
                            controller: _priceController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter a price (RM)',
                              errorStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              errorMaxLines: 1,
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter price';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
