import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    const String image = './assets/images/100plus.jpg';

    final retailerList = [
      RetailerCard(image, 'Tesco', 1.33),
      RetailerCard(image, 'Jaya Grocer', 1.35),
      RetailerCard(image, 'Giant', 1.34),
      RetailerCard(image, 'Village Grocer', 1.40),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Product Detail Screen'),
        actions: [
          IconButton(icon: Icon(Icons.favorite_outline), onPressed: () {})
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 20.0,
              ),
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    spreadRadius: 2,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Image.asset(
                './assets/images/100plus.jpg',
                fit: BoxFit.contain,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 250,
                    child: Text(
                      '100 plus 325 ml',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Update',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.grey.shade300,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Expanded(
            //   child: Container(
            //     child: ListView.builder(
            //         itemCount: retailerList.length,
            //         itemBuilder: (context, index) {
            //           return retailerList[index];
            //         }),
            //   ),
            // ),

            for (var item in retailerList)
              Column(
                children: [
                  item,
                ],
              ),
            Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Add retailer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RetailerCard extends StatelessWidget {
  final String image;
  final String retailer;
  final double price;

  RetailerCard(this.image, this.retailer, this.price);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1),
      ),
      shadowColor: Colors.grey.shade500,
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      // child: Expanded(
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 70,
              width: 100,
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              width: 100,
              child: Text(
                retailer,
                textAlign: TextAlign.start,
                maxLines: 2,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Text(
                'RM ' + price.toStringAsFixed(2),
                maxLines: 2,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
