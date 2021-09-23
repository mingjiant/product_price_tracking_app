import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

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
  bool isLoading = false;
  var _selectedValue;
  var _categories = List<DropdownMenuItem>();
  var _selectedRetailer;
  var _retailers = List<DropdownMenuItem>();
  TextEditingController _nameController;
  TextEditingController _barcodeController;
  TextEditingController _priceController;
  File _productImageFile;
  String _scanBarcode = '';
  List _products = [];

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
    super.dispose();
  }

  void _loadCategories() async {
    var categories = PRODUCT_CATEGORIES;
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

  void _loadRetailers() async {
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
        isLoading = true;
      });

      var docRef =
          Firestore.instance.collection('products').document().documentID;
      final imgRef = FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child(docRef + '/' + DateTime.now().toIso8601String() + '.jpg');

      await imgRef.putFile(_productImageFile).onComplete;

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

      await Firestore.instance.collection('products').document(docRef).setData({
        'productID': docRef,
        'name': _nameController.text.trim(),
        'barcode': _barcodeController.text.trim(),
        'category': _selectedValue,
        'imageUrl': imageUrl,
      }).then((value) {
        var docId = Firestore.instance
            .collection('products')
            .document(docRef)
            .collection('retailPrice')
            .document()
            .documentID;

        Firestore.instance
            .collection('products')
            .document(docRef)
            .collection('retailPrice')
            .document(docId)
            .setData({
          'id': docId,
          'retailer': _selectedRetailer,
          'price': double.parse(_priceController.text),
        });
      });
    } catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
    }
  }

  _getProducts() async {
    var _collectionReference =
        await Firestore.instance.collection('products').getDocuments();

    if (this.mounted) {
      setState(() {
        _products = _collectionReference.documents;
      });
    }
    return _collectionReference.documents;
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
                //   else {
                //     for (int i = 0; i < _products.length; i++) {
                //       String barcode = _products[i].data['barcode'];
                //       if (_barcodeController.text == barcode) {
                //         showDialog(
                //           context: context,
                //           builder: (BuildContext context) {
                //             return AlertDialog(
                //               clipBehavior: Clip.antiAlias,
                //               title: Text(
                //                   'The barcode has been recorded! Please check the barcode again!'),
                //               shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(20)),
                //               actions: [
                //                 TextButton(
                //                     onPressed: () {
                //                       Navigator.pop(context);
                //                     },
                //                     child: Text('Dismiss'))
                //               ],
                //             );
                //           },
                //         );
                //       }
                //     }
                //   }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                    border: Border.all(color: Theme.of(context).primaryColor),
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
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Theme.of(context).primaryColor),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: _barcodeController,
                            decoration: InputDecoration(
                              hintText: 'Enter or scan product barcode',
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
                              }
                              return null;
                            },
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
                                    TextEditingController(text: _scanBarcode);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
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
                    border: Border.all(color: Theme.of(context).primaryColor),
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
                    border: Border.all(color: Theme.of(context).primaryColor),
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
                    border: Border.all(color: Theme.of(context).primaryColor),
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
