import 'package:flutter/material.dart';

class AdsBanner extends StatelessWidget {
  final String image;

  AdsBanner(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            fit: BoxFit.fill,
          )
        ],
      ),
    );
  }
}
