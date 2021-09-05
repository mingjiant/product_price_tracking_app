import 'package:flutter/material.dart';
import '../widgets/product_image_picker.dart';
import '../category_list.dart';
import '../retailer_list.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool checkboxValue = false;
  var _selectedValue;
  var _categories = List<DropdownMenuItem>();
  List<String> selectedCategories = [];

  static List<RetailerCard> retailerCards = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    var categories = PRODUCT_CATEGORIES;
    categories.forEach((category) {
      setState(() {
        _categories.add(
          DropdownMenuItem(
            child: Text(category.title),
            value: category.title,
          ),
        );
      });
    });
  }

  void _addRetailer() {
    setState(() {
      return retailerCards.add(RetailerCard());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
            retailerCards = [];
          },
        ),
        centerTitle: true,
        title: Text('Edit Product Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Form(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Product image',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                ProductImagePicker(),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Product name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter product name',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Product barcode',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
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
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 285,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Enter or scan product barcode',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.name,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.qr_code_scanner,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Product category',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: DropdownButtonFormField(
                      value: _selectedValue,
                      items: _categories,
                      hint: Text('Select a category'),
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                RetailerCard(),
                // Container(
                //   height: 200,
                //   child: ListView.builder(
                //     physics: NeverScrollableScrollPhysics(),
                //     itemCount: retailerCards.length,
                //     itemBuilder: (_, index) => retailerCards[index],
                //   ),
                // ),
                Column(
                  children: [
                    for (var _ in retailerCards) RetailerCard(),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    _addRetailer();
                  },
                  child: Text(
                    'Add retailer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RetailerCard extends StatefulWidget {
  @override
  _RetailerCardState createState() => _RetailerCardState();
}

class _RetailerCardState extends State<RetailerCard> {
  var _selectedValue;
  // ignore: deprecated_member_use
  var _retailers = List<DropdownMenuItem>();

  @override
  void initState() {
    super.initState();
    _loadRetailers();
  }

  void _loadRetailers() async {
    var retailers = retailerList;
    retailers.forEach((retailer) {
      setState(() {
        _retailers.add(
          DropdownMenuItem(
            child: Text(retailer.name),
            value: retailer.id,
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Retailer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: DropdownButtonFormField(
                value: _selectedValue,
                items: _retailers,
                hint: Text('Select a retailer'),
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value;
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Product price',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter a price (RM)',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
