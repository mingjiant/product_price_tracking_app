import 'package:flutter/material.dart';

import './models/category.dart';

const PRODUCT_CATEGORIES = const [
  Category(id: 'c1', title: 'Food'),
  Category(id: 'c2', title: 'Beverage'),
  Category(id: 'c3', title: 'Ice cream'),
  Category(id: 'c4', title: 'Frozen'),
  Category(id: 'c5', title: 'Household'),
  Category(id: 'c6', title: 'Health'),
  Category(id: 'c7', title: 'Pets'),
];

final List CATEGORIES_ICON = [
  Icon(Icons.fastfood),
  Icon(Icons.local_drink),
  Icon(Icons.icecream),
  Icon(Icons.ac_unit),
  Icon(Icons.handyman_outlined),
  Icon(Icons.healing),
  Icon(Icons.pets),
];
