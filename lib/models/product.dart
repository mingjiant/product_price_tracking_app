import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  // final double price;
  final String category;
  final String barcode;
  final String image;
  final Map<String, double> retailPrice;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.name,
    // @required this.price,
    @required this.category,
    @required this.barcode,
    @required this.image,
    @required this.retailPrice,
    this.isFavourite = false,
  });
}
