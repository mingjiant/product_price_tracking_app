import 'package:flutter/material.dart';

import '../screens/product_detail_screen.dart';

class FavouriteItem extends StatelessWidget {
  final String name;
  final image;
  final prodData;

  FavouriteItem(this.name, this.image, this.prodData);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              prodData: prodData,
            ),
          ),
        );
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 3.0,
                  ),
                  width: 120,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: FadeInImage(
                    image: Image.network(image).image,
                    placeholder: NetworkImage(
                        'https://via.placeholder.com/110x150?text=Loading+image'),
                  ),
                ),
                Container(
                  width: 190,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 185,
                        child: Text(
                          name,
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
                        width: 170,
                        child: Text(
                          'Retailer: Jaya Grocer',
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
