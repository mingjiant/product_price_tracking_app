import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

class ProductListingScreen extends StatefulWidget {
  static const routeName = '/product-listing';

  @override
  _ProductListingScreenState createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Product Listing Screen'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: ProductsGrid(),
        ),
      ),
    );
  }
}
