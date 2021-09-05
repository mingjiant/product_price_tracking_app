import 'dart:io';

import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final String barcode;
  final File image;
  final Map<String, double> retailPrice;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.name,
    @required this.category,
    @required this.barcode,
    @required this.image,
    @required this.retailPrice,
    this.isFavourite = false,
  });
}
