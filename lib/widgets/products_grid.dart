// import 'package:flutter/material.dart';

// import '../widgets/product_item.dart';

// class ProductsGrid extends StatelessWidget {
//   final String name;
//   final String image;
//   final double price;

//   ProductsGrid(this.name, this.image, this.price);

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 5,
//           mainAxisSpacing: 5,
//           childAspectRatio: 1.45 / 2,
//         ),
//         itemCount: 6,
//         itemBuilder: (ctx, index) {
//           return ProductItem(name, image);
//         });
//   }
// }
