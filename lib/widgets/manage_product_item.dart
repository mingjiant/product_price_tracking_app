import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/edit_product_screen.dart';

class ManageProductItem extends StatelessWidget {
  final image;
  final String name;
  final prodData;

  ManageProductItem(this.image, this.name, this.prodData);

  // Delete the selected product from the database
  void _deleteProduct() async {
    await Firestore.instance
        .collection('products')
        .document(prodData['productID'])
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(image),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              // Edit product
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProductScreen(prodData: prodData),
                    ),
                  );
                },
                color: Theme.of(context).primaryColor,
              ),
              // Delete product
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          clipBehavior: Clip.antiAlias,
                          title: Text('Are you sure?'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteProduct();
                                Navigator.pop(context);
                              },
                              child: Text('Confirm'),
                            ),
                          ],
                        );
                      });
                },
                color: Theme.of(context).errorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
