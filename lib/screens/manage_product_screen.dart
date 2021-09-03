import 'package:flutter/material.dart';

import '../widgets/manage_product_item.dart';

class ManageProductScreen extends StatelessWidget {
  static const routeName = '/manage-product';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Manage product'),
      ),
      body: ListView(children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Column(
            children: [
              ManageProductItem(),
              ManageProductItem(),
            ],
          ),
        ),
      ]),
    );
  }
}
