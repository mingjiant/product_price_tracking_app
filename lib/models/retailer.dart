import 'package:flutter/material.dart';

class Retailer {
  final String id;
  final String name;
  final String imageUrl;

  Retailer({
    @required this.id,
    @required this.name,
    this.imageUrl,
  });
}
