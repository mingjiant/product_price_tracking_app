import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/product_image_picker.dart';
import '../widgets/retailer_dialog.dart';
import '../category_list.dart';

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
  List<String> selectedCategories = [];
  TextEditingController _nameController;
  TextEditingController _barcodeController;
  var _retailPrice = [];

  @override
  void initState() {
    _nameController = TextEditingController();
    _barcodeController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
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

  void _addProduct() {
    FocusScope.of(context).unfocus();
    var docRef =
        Firestore.instance.collection('products').document().documentID;
    Firestore.instance.collection('products').document(docRef).setData({
      'name': _nameController.text.trim(),
      'barcode': _barcodeController.text.trim(),
      'category': _selectedValue,
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
              _addProduct();
              _retailPrice.clear();
              Navigator.pop(context);
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
                ProductImagePicker(),
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
                      ),
                      keyboardType: TextInputType.name,
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
                            ),
                            keyboardType: TextInputType.name,
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
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      // for (int i = 0; i < _retailPrice.length; i++)
                      // Firestore.instance
                      //     .collection('products')
                      //     .document(docRef)
                      //     .collection('retailPrice')
                      //     .document()
                      //     .setData({
                      //   'retailer': _retailPrice[i][0],
                      //   'price': _retailPrice[i][1],
                      // });
                      _retailPrice.length >= 1
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(_retailPrice[0].toString()),
                              ],
                            )
                          : Container(
                              child: Text(
                                'No retail price yet! Click "Add retailer" to add product pricing',
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return RetailerDialog();
                      },
                    ).then((value) {
                      _retailPrice.add(value);
                      print(_retailPrice);
                    });
                  },
                  child: Text(
                    'Add retailer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
