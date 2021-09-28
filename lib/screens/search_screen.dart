import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:product_price_tracking_app/screens/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final globalKey = new GlobalKey<ScaffoldState>();
  TextEditingController _searchController;
  List _products = [];
  List _searchResult = [];

  _getProducts() async {
    var _collectionReference =
        await Firestore.instance.collection('products').getDocuments();

    if (this.mounted) {
      setState(() {
        _products = _collectionReference.documents;
      });
    }
    return _collectionReference.documents;
  }

  void searchProduct(String searchKey) {
    _searchResult.clear();
    for (int i = 0; i < _products.length; i++) {
      String prodData = _products[i].data['name'];
      if (prodData.toLowerCase().contains(searchKey.toLowerCase())) {
        _searchResult.add(_products[i]);
      }
    }
    setState(() {
      if (searchKey.isEmpty) {
        _searchResult.clear();
      }
    });
  }

  @override
  void initState() {
    _searchController = TextEditingController();
    _getProducts();
    super.initState();
  }

  @override
  void dispose() {
    _products = [];
    _searchResult = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 250,
            height: 200,
            child: TextField(
              autofocus: true,
              controller: _searchController,
              maxLines: 1,
              autocorrect: false,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'What are you searching for?',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                ),
              ),
              onChanged: searchProduct,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchResult.clear();
              });
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body:
          // _searchResult.isEmpty
          //     ? FutureBuilder(
          //         future: _getProducts(),
          //         builder: (context, snapshot) {
          //           if (snapshot.connectionState == ConnectionState.none &&
          //               snapshot.connectionState == ConnectionState.waiting &&
          //               snapshot.hasData == null) {
          //             return Center(
          //               child: SpinKitThreeBounce(
          //                 color: Theme.of(context).primaryColor,
          //                 size: 30.0,
          //               ),
          //             );
          //           }
          //           return Container(
          //             child: ListView.builder(
          //               shrinkWrap: true,
          //               itemCount: _products.length,
          //               itemBuilder: (BuildContext context, index) {
          //                 return ListTile(
          //                   title: Text(_products[index].data['name']),
          //                 );
          //               },
          //             ),
          //           );
          //         },
          //       )
          // :
          ListView.builder(
        itemCount: _searchResult.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_searchResult[index].data['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailScreen(prodData: _searchResult[index].data),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
