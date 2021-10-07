import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widgets/favourite_item.dart';

class FavouriteScreen extends StatefulWidget {
  static const routeName = '/favourite';
  FavouriteScreen({Key key}) : super(key: key);

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List _userFavourites = [];
  List _products = [];
  var _isLoading = false;

  _getUserFavourites() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    try {
      var _querySnapshot =
          await Firestore.instance.collection('users').document(user.uid).get();

      if (_querySnapshot.exists &&
          _querySnapshot.data.containsKey('favourites') &&
          _querySnapshot.data['favorites'] is List) {
        return List<String>.from(_querySnapshot.data['favorites']);
      }
      return [];
    } catch (e) {
      print(e);
    }
  }

  _getProducts() async {
    setState(() {
      _isLoading = true;
    });

    var _collectionReference =
        await Firestore.instance.collection('products').getDocuments();

    if (this.mounted) {
      setState(() {
        _products = _collectionReference.documents;
      });
    }

    setState(() {
      _isLoading = false;
    });

    return _collectionReference.documents;
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 3;
    var favourites = _getUserFavourites();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Favourites'),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Favourite products',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            _products.isEmpty
                ? SizedBox()
                : Expanded(
                    child: FutureBuilder(
                      future: _getProducts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none &&
                            snapshot.connectionState ==
                                ConnectionState.waiting &&
                            snapshot.hasData == null) {
                          return Center(
                            child: SpinKitThreeBounce(
                              color: Theme.of(context).primaryColor,
                              size: 30.0,
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: _products.length,
                          itemBuilder: (ctx, index) {
                            return FavouriteItem(
                                _products[index].data['name'],
                                _products[index].data['imageUrl'],
                                _products[index].data);
                          },
                        );
                      },
                    ),
                  )
          ],
        ),
      ),
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
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/product-category');
              break;
            case 2:
              Navigator.pushNamed(context, '/add-product');
              break;
            case 3:
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
