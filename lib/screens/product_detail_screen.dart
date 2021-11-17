import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../widgets/retailer_dialog.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';
  final prodData;
  ProductDetailScreen({Key key, @required this.prodData}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List _retailPrice = [];
  Future selectedPrice;
  var _isLoading = false;
  // var _isFavourite = false;

  // Retrieve all the product pricing from Firestore database
  _getRetailPrice() async {
    try {
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
    } catch (e) {
      print(e);
    }
  }

  // Add a new retailer price
  void _addRetailPrice(
    String retailer,
    double price,
  ) async {
    try {
      // Retrieving the document ID from sub-collection
      var docId = Firestore.instance
          .collection('products')
          .document(widget.prodData['productID'])
          .collection('retailPrice')
          .document()
          .documentID;

      // Add a new document inside the sub-collection
      await Firestore.instance
          .collection('products')
          .document(widget.prodData['productID'])
          .collection('retailPrice')
          .document(docId)
          .setData(
        {
          'id': docId,
          'retailer': retailer,
          'price': price,
          'lastUpdate': DateTime.now(),
        },
      );
    } catch (error) {
      print(error);
    }
  }

  @override
  void dispose() {
    _retailPrice = [];
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    selectedPrice = _getRetailPrice();
    super.didChangeDependencies();
  }

  // void _addUserFavourite(String productId) async {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   FirebaseUser user = await _auth.currentUser();
  //   try {
  //     await Firestore.instance
  //         .collection('users')
  //         .document(user.uid)
  //         .updateData({
  //       'favourites': FieldValue.arrayUnion([productId]),
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // void _removeUserFavourite(String productId) async {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   FirebaseUser user = await _auth.currentUser();
  //   try {
  //     await Firestore.instance
  //         .collection('users')
  //         .document(user.uid)
  //         .updateData({
  //       'favourites': FieldValue.arrayRemove([productId]),
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // _getUserFavourites() async {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   FirebaseUser user = await _auth.currentUser();
  //   try {
  //     var _snapshot =
  //         await Firestore.instance.collection('users').document(user.uid).get();
  //     return _snapshot;
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.prodData['name']),
        // actions: [
        //   if (_isFavourite == false)
        //     IconButton(
        //         icon: Icon(Icons.favorite_outline),
        //         onPressed: () {
        //           _addUserFavourite(widget.prodData['productID']);
        //           _isFavourite = true;
        //         })
        //   else if (_isFavourite == true)
        //     IconButton(
        //         icon: Icon(Icons.favorite),
        //         onPressed: () {
        //           _removeUserFavourite(widget.prodData['productID']);
        //           _isFavourite = false;
        //         })
        // ],
      ),
      body: _isLoading
          ? Center(
              child: SpinKitThreeBounce(
                color: Theme.of(context).primaryColor,
                size: 30.0,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20.0,
                    ),
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor,
                          spreadRadius: 2,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Container(
                      child: FadeInImage(
                        fit: BoxFit.contain,
                        image: NetworkImage(
                          widget.prodData['imageUrl'],
                        ),
                        placeholder: NetworkImage(
                            'https://via.placeholder.com/500?text=Loading+image'),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(
                      left: 20,
                      bottom: 5,
                    ),
                    child: Text(
                      widget.prodData['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
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
                            color: Theme.of(context).primaryColor,
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
                            return RetailerCard(
                              _retailPrice[index].data,
                              _retailPrice[index].data['retailer'],
                              _retailPrice[index].data['price'],
                              widget.prodData['productID'],
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return RetailerDialog(_addRetailPrice);
                          },
                        );
                        setState(() {
                          _isLoading = false;
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
                  ),
                ],
              ),
            ),
    );
  }
}

class RetailerCard extends StatelessWidget {
  final data;
  final String retailer;
  final double price;
  final String prodID;

  RetailerCard(this.data, this.retailer, this.price, this.prodID);

  @override
  Widget build(BuildContext context) {
    final time =
        DateFormat('dd MMMM yyyy hh:mm a').format(data['lastUpdate'].toDate());
    return Card(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1),
      ),
      shadowColor: Colors.grey.shade500,
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  child: Text(
                    retailer,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text(
                    'RM ' + price.toStringAsFixed(2),
                    maxLines: 2,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return UpdatePriceDialog(prodID, data['id']);
                      },
                    );
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.grey.shade300,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                'Updated on: ' + time,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdatePriceDialog extends StatefulWidget {
  final String prodID;
  final String id;

  UpdatePriceDialog(this.prodID, this.id);

  @override
  _UpdatePriceDialogState createState() => _UpdatePriceDialogState();
}

class _UpdatePriceDialogState extends State<UpdatePriceDialog> {
  GlobalKey<FormState> _formKey;
  TextEditingController _priceController;

  @override
  void initState() {
    _priceController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  // Update product pricing for a selected retailer
  void _submit(String prodID, String id, double price) async {
    FocusScope.of(context).unfocus();
    await Firestore.instance
        .collection('products')
        .document(prodID)
        .collection('retailPrice')
        .document(id)
        .updateData(
      {
        'price': price,
        'lastUpdate': DateTime.now(),
      },
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: contextBox(context),
    );
  }

  contextBox(context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 10.0,
                  ),
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Update price',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 10.0,
                  ),
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
                    horizontal: 10.0,
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
                Container(
                  margin: const EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState.validate())
                            _submit(
                              widget.prodID,
                              widget.id,
                              double.parse(_priceController.text),
                            );
                        },
                        child: Text('Confirm'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
