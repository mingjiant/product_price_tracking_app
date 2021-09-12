import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widgets/retailer_dialog.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';
  final prodData;
  ProductDetailScreen({Key key, @required this.prodData}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List _retailPrice = [];
  Future selectedPrice;

  _getRetailPrice() async {
    var _collectionReference = await Firestore.instance
        .collection('products')
        .document(widget.prodData['productID'])
        .collection('retailPrice')
        .getDocuments();

    if (this.mounted) {
      setState(() {
        _retailPrice = _collectionReference.documents;
      });
    }
    return _collectionReference.documents;
  }

  @override
  void dispose() {
    _retailPrice = [];
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    selectedPrice = _getRetailPrice();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    const String image = './assets/images/100plus.jpg';

    // final retailerList = [
    //   RetailerCard(image, 'Tesco', 1.33),
    //   RetailerCard(image, 'Jaya Grocer', 1.35),
    //   RetailerCard(image, 'Giant', 1.34),
    //   RetailerCard(image, 'Village Grocer', 1.40),
    // ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.prodData['name']),
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
              child: Container(
                child: Image.network(
                  widget.prodData['imageUrl'],
                  fit: BoxFit.contain,
                ),
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
                      widget.prodData['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RetailerDialog();
                        },
                      );
                    },
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
            FutureBuilder(
              future: _getRetailPrice(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none &&
                    snapshot.hasData == null) {
                  return Center(
                    child: SpinKitThreeBounce(
                      color: Colors.blue,
                      size: 30.0,
                    ),
                  );
                }
                return Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _retailPrice.length,
                    itemBuilder: (ctx, index) {
                      return RetailerCard(
                        image,
                        _retailPrice[index].data['retailer'],
                        _retailPrice[index].data['price'],
                      );
                    },
                  ),
                );
              },
            ),
            // for (var item in retailerList)
            //   Column(
            //     children: [
            //       item,
            //     ],
            //   ),
            Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return RetailerDialog();
                    },
                  );
                },
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
  final String price;

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
                'RM ' + price,
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
