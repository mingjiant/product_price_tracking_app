import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../widgets/ads_banner.dart';
import '../widgets/products_grid.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('EasyTrack'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.qr_code_scanner_rounded),
            onPressed: () {},
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
                      CategoryIcon(Icon(Icons.category_rounded), null, 'All'),
                      CategoryIcon(Icon(Icons.fastfood), null, 'Food'),
                      CategoryIcon(Icon(Icons.icecream), null, 'Ice cream'),
                      CategoryIcon(Icon(Icons.ac_unit), null, 'Frozen'),
                      CategoryIcon(Icon(Icons.local_drink), null, 'Beverages'),
                      CategoryIcon(Icon(Icons.healing), null, 'Health'),
                      CategoryIcon(
                          Icon(Icons.handyman_outlined), null, 'Household'),
                      CategoryIcon(Icon(Icons.pets), null, 'Pets'),
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: ProductsGrid(),
            ),
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
              Icons.account_circle_outlined,
            ),
            label: 'Account',
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
              Navigator.pushNamed(context, '/edit-product');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/favourite');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/account');
              break;
          }
        },
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final icon;
  final onPress;
  final String categoryName;

  CategoryIcon(this.icon, this.onPress, this.categoryName);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: icon,
            onPressed: () {},
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
