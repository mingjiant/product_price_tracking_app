import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

import '../category_list.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  final prodData;
  EditProductScreen({Key key, @required this.prodData}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  GlobalKey<FormState> _formKey;
  bool checkboxValue = false;
  var _selectedValue;
  var _categories = List<DropdownMenuItem>();
  TextEditingController _nameController;
  TextEditingController _barcodeController;
  File _productImageFile;
  List _retailPrice = [];
  Future selectedPrice;
  String _scanBarcode = '';

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.prodData['name']);
    _barcodeController =
        TextEditingController(text: widget.prodData['barcode']);
    _selectedValue = widget.prodData['category'];
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

  _getRetailPrice() async {
    var _collectionReference = await Firestore.instance
        .collection('products')
        .document(widget.prodData['productID'])
        .collection('retailPrice')
        .orderBy('price')
        .getDocuments();

    if (this.mounted) {
      setState(() {
        _retailPrice = _collectionReference.documents;
      });
    }
    return _collectionReference.documents;
  }

  void _editProduct() async {
    FocusScope.of(context).unfocus();
    var imageUrl;
    final imgRef = FirebaseStorage.instance.ref().child('product_images').child(
        widget.prodData['productID'] +
            '/' +
            DateTime.now().toIso8601String() +
            '.jpg');

    if (_productImageFile != null) {
      await imgRef.putFile(_productImageFile).onComplete;
      imageUrl = await imgRef.getDownloadURL();
    }

    try {
      await Firestore.instance
          .collection('products')
          .document(widget.prodData['productID'])
          .updateData(
        {
          'name': _nameController.text.trim(),
          'barcode': _barcodeController.text.trim(),
          'category': _selectedValue,
          'imageUrl':
              _productImageFile == null ? widget.prodData['imageUrl'] : imageUrl
        },
      );
    } catch (error) {
      print(error);
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.getImage(source: ImageSource.camera, imageQuality: 60);
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _productImageFile = pickedImageFile;
    });
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 60);
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _productImageFile = pickedImageFile;
    });
  }

  @override
  void didChangeDependencies() {
    selectedPrice = _getRetailPrice();
    super.didChangeDependencies();
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
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _editProduct();
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
                _productImageFile == null
                    ? Column(
                        children: [
                          Container(
                            width: 350,
                            height: 190,
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Image.network(
                              widget.prodData['imageUrl'],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  onPressed: _pickImage,
                                  child: Text('Take Photo'),
                                ),
                                TextButton(
                                  onPressed: _pickImageGallery,
                                  child: Text('Choose from gallery'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            width: 350,
                            height: 190,
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Image(
                              image: FileImage(_productImageFile),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  onPressed: _pickImage,
                                  child: Text('Take Photo'),
                                ),
                                TextButton(
                                  onPressed: _pickImageGallery,
                                  child: Text('Choose from gallery'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                          width: 250,
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
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Retail price',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                FutureBuilder(
                  future: _getRetailPrice(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none &&
                        snapshot.connectionState == ConnectionState.waiting &&
                        snapshot.hasData == null) {
                      return Center(
                        child: SpinKitThreeBounce(
                          color: Colors.blue,
                          size: 30.0,
                        ),
                      );
                    }
                    return Container(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _retailPrice.length,
                        itemBuilder: (ctx, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 150,
                                margin: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  _retailPrice[index].data['retailer'],
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                width: 100,
                                child: Text(
                                  'RM ' +
                                      _retailPrice[index]
                                          .data['price']
                                          .toStringAsFixed(2),
                                  maxLines: 1,
                                ),
                              ),
                              Container(
                                child: IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () async {
                                    await Firestore.instance
                                        .collection('products')
                                        .document(widget.prodData['productID'])
                                        .collection('retailPrice')
                                        .document(
                                            _retailPrice[index].data['id'])
                                        .delete();
                                  },
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
