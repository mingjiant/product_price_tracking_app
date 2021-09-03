import 'package:flutter/material.dart';

class FavouriteItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product-detail');
      },
      child: Container(
        height: 160,
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                Container(
                  width: 150,
                  height: 100,
                  child: Image.asset('./assets/images/100plus.jpg'),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 185,
                        child: Text(
                          'Product title',
                          maxLines: 2,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: 180,
                        child: Text(
                          'Lowest price: RM 1.11',
                          maxLines: 2,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: 185,
                        child: Text(
                          'Retailer: Jaya Grocer Subang Jaya',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
