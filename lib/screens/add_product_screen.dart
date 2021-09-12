import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  List<String> selectedCategories = [];
  TextEditingController _nameController;
  TextEditingController _barcodeController;
  TextEditingController _priceController;
  var _retailPrice = [];
  File _productImageFile;

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

  // Widget _loadRetailerPrice() {
  //   return Column(
  //     children: [
  //       for (int i = 0; i < _retailPrice.length; i++)
  //         Container(
  //           margin: const EdgeInsets.symmetric(vertical: 5.0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Container(
  //                   width: 150,
  //                   margin: const EdgeInsets.only(right: 10.0),
  //                   child: Text(
  //                     _retailPrice[i][0],
  //                     maxLines: 1,
  //                   )),
  //               Container(
  //                 width: 100,
  //                 child: Text(
  //                   'RM ' + _retailPrice[i][1],
  //                   maxLines: 1,
  //                 ),
  //               ),
  //               Container(
  //                 child: IconButton(
  //                   icon: Icon(Icons.delete),
  //                   color: Colors.red,
  //                   onPressed: () {
  //                     _retailPrice.removeAt(i);
  //                     setState(() {});
  //                     print(_retailPrice);
  //                   },
  //                 ),
  //               )
  //             ],
  //           ),
  //         )
  //     ],
  //   );
  // }

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
          .child(docRef + '.jpg');

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
        Firestore.instance
            .collection('products')
            .document(docRef)
            .collection('retailPrice')
            .document()
            .setData({
          'retailer': _selectedRetailer,
          'price': _priceController.text.trim(),
        });
      });

      for (int i = 0; i < _retailPrice.length; i++)
        Firestore.instance
            .collection('products')
            .document(docRef)
            .collection('retailPrice')
            .document()
            .setData({
          'retailer': _retailPrice[i][0],
          'price': _retailPrice[i][1],
        });
    } catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
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
        title: Text('Add Product Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState.validate() && _productImageFile != null
                  // && _retailPrice.isNotEmpty
                  ) {
                _addProduct();
                // _retailPrice.clear();
                Navigator.pop(context);
              } else {
                if (_productImageFile == null)
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
                      children: [
                        SizedBox(
                          width: 285,
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
                          onPressed: () {},
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

                // _retailPrice.length >= 1
                //     ? _loadRetailerPrice()
                //     : Container(
                //         margin: const EdgeInsets.symmetric(vertical: 5.0),
                //         child: Text(
                //           'No retailer price yet! Click "Add retailer" to add retailer and product price.',
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //             fontSize: 14,
                //           ),
                //         ),
                //       ),
                // TextButton(
                //   onPressed: () {
                //     showDialog(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return RetailerDialog();
                //       },
                //     ).then((value) {
                //       if (value != null) {
                //         setState(() {});
                //         _retailPrice.add(value);
                //         print(value);
                //       }
                //     });
                //   },
                //   child: Text(
                //     'Add retailer',
                //     style: TextStyle(
                //       fontSize: 16,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
