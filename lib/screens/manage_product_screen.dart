import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widgets/manage_product_item.dart';

class ManageProductScreen extends StatefulWidget {
  static const routeName = '/manage-product';

  @override
  _ManageProductScreenState createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  List _products = [];
  Future selectedProducts;

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
  void dispose() {
    _products = [];
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    selectedProducts = _getProducts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Manage product'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: _products.length == 0
            ? Container(
                child: Center(
                  child: Text('No products'),
                ),
              )
            : FutureBuilder(
                future: _getProducts(),
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
                  return ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (ctx, index) {
                      return ManageProductItem(
                        _products[index].data['imageUrl'],
                        _products[index].data['name'],
                        _products[index].data,
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
