import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  var _isLoading = false;

  _getProducts() async {
    try {
      _isLoading = true;
      var _collectionReference = await Firestore.instance
          .collection('products')
          .where('category', isEqualTo: widget.category)
          .getDocuments();

      if (this.mounted) {
        setState(() {
          _products = _collectionReference.documents;
        });
      }
      _isLoading = false;

      return _collectionReference.documents;
    } catch (error) {
      print(error);
      _isLoading = false;
    }
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
      body: _isLoading
          ? Center(
              child: SpinKitThreeBounce(
                color: Theme.of(context).primaryColor,
                size: 30.0,
              ),
            )
          : _products.length == 0
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
                    return Container(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 1.40 / 2,
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
