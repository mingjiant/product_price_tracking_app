import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/product_item.dart';

class ProductListingScreen extends StatefulWidget {
  // static const routeName = '/product-listing';
  final String category;
  ProductListingScreen({Key key, @required this.category}) : super(key: key);

  @override
  _ProductListingScreenState createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  List _products = [];
  Future selectedProducts;

  _getProducts() async {
    var _collectionReference = await Firestore.instance
        .collection('products')
        .where('category', isEqualTo: widget.category)
        .getDocuments();

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
        title: Text(widget.category),
      ),
      body: _products.length == 0
          ? Container(
              child: Center(
                child: Text('No products'),
              ),
            )
          : FutureBuilder(
              future: _getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none &&
                    snapshot.hasData == null) {
                  return Center(
                    child: Text('Connection error'),
                  );
                }
                return Container(
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 1.55 / 2,
                    ),
                    itemCount: _products.length,
                    itemBuilder: (ctx, index) {
                      return ProductItem(
                        _products[index].data['name'],
                        _products[index].data['imageUrl'],
                        _products[index].data,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
