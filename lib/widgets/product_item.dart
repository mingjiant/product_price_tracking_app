import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String name = '100 plus 325 ml';
  final String image = 'assets/images/100plus.jpg';
  final double price = 1.33;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/product-detail');
        },
        child: Container(
          margin: const EdgeInsets.all(15),
          height: 230.0,
          width: 150.0,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                spreadRadius: 2,
                blurRadius: 2,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Theme.of(context).primaryColor),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                height: 130.0,
                width: 130.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(image),
                    )),
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                thickness: 1,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'RM ' + (price).toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
