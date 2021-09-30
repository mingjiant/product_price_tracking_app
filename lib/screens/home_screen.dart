import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../screens/product_listing_screen.dart';
import '../screens/product_detail_screen.dart';
import '../widgets/ads_banner.dart';
// import '../widgets/product_item.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _selectedIndex = 0;
  List _products;

  List cardList = [
    AdsBanner('./assets/images/banner1.jpg'),
    AdsBanner('./assets/images/banner2.jpeg'),
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  Future<String> _barcodeScanner() async {
    String barcode;
    try {
      barcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcode);
    } on PlatformException {
      barcode = 'Failed to get platform version';
    }
    return barcode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('EasyTrack'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
          IconButton(
            icon: Icon(Icons.qr_code_scanner_rounded),
            onPressed: () {
              _barcodeScanner().then(
                (value) async {
                  var _collectionReference = await Firestore.instance
                      .collection('products')
                      .where('barcode', isEqualTo: value)
                      .getDocuments();

                  if (this.mounted) {
                    setState(() {
                      _products = _collectionReference.documents;
                    });
                  }

                  if (value == '-1') {
                    return null;
                  } else if (_products.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(prodData: _products[0].data),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          clipBehavior: Clip.antiAlias,
                          title: Text(
                            'Product not found!',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: Text('The product has not been added.'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/add-product');
                              },
                              child: Text(
                                'Add Product',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Dismiss',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        // child: Expanded(
        child: Column(
          children: [
            CarouselSlider(
              items: cardList.map((card) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.width,
                      // child: InkWell(
                      //   child: card,
                      //   onTap: () => launch('https://shopee.com.my'),
                      // ),
                      child: Card(
                        color: Colors.white,
                        child: card,
                      ),
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                  height: 150,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 500),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: map(cardList, (index, url) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                      color: _currentIndex == index
                          ? Theme.of(context).primaryColor
                          : Colors.white),
                );
              }),
            ),
            Container(
              width: 350,
              height: 190,
              margin: const EdgeInsets.only(top: 5.0, bottom: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    spreadRadius: 2,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GridView.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: 5,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      CategoryIcon(Icon(Icons.fastfood), 'Snacks'),
                      CategoryIcon(Icon(Icons.icecream), 'Ice cream'),
                      CategoryIcon(Icon(Icons.breakfast_dining), 'Bakery'),
                      CategoryIcon(Icon(Icons.ac_unit), 'Frozen'),
                      CategoryIcon(Icon(Icons.local_drink), 'Beverages'),
                      CategoryIcon(Icon(Icons.healing), 'Health'),
                      CategoryIcon(Icon(Icons.handyman_outlined), 'Household'),
                      CategoryIcon(Icon(Icons.pets), 'Pets'),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 20),
              child: Text(
                'Featured products',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 5),
            //   child: GridView.builder(
            //       shrinkWrap: true,
            //       physics: NeverScrollableScrollPhysics(),
            //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 2,
            //         crossAxisSpacing: 5,
            //         mainAxisSpacing: 5,
            //         childAspectRatio: 1.5 / 2,
            //       ),
            //       itemCount: 6,
            //       itemBuilder: (ctx, index) {
            //         return ProductItem(name, image);
            //       }),
            // ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white30,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.category,
            ),
            label: 'Products',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
            ),
            label: 'Add',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            label: 'Favourites',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: 'Settings',
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/product-category');
              break;
            case 2:
              Navigator.pushNamed(context, '/add-product');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/favourite');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final icon;
  final String categoryName;

  CategoryIcon(this.icon, this.categoryName);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: icon,
            onPressed: () {
              print(categoryName);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListingScreen(
                    category: categoryName,
                  ),
                ),
              );
            },
          ),
          Text(
            categoryName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          )
        ],
      ),
    );
  }
}
