import 'package:flutter/material.dart';

import '../retailer_list.dart';

class RetailerDialog extends StatefulWidget {
  RetailerDialog(this.submitFn);

  final void Function(String retailer, double price) submitFn;

  @override
  _RetailerDialogState createState() => _RetailerDialogState();
}

class _RetailerDialogState extends State<RetailerDialog> {
  GlobalKey<FormState> _formKey;
  var _selectedRetailer;
  TextEditingController _priceController;
  var _retailers = List<DropdownMenuItem>();

  @override
  void initState() {
    _priceController = TextEditingController();
    _formKey = GlobalKey<FormState>();
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
            value: retailer.name,
          ),
        );
      });
    });
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    widget.submitFn(
      _selectedRetailer,
      double.parse(_priceController.text),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: contextBox(context),
    );
  }

  contextBox(context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 10.0,
                  ),
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Add Retailer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 10.0,
                  ),
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
                  margin: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 10.0,
                  ),
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
                      isExpanded: true,
                      value: _selectedRetailer,
                      items: _retailers,
                      hint: Text('Select a retailer'),
                      onChanged: (value) {
                        setState(() {
                          _selectedRetailer = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        errorMaxLines: 1,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a retailer';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 10.0,
                  ),
                  child: Text(
                    'Product price',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 10.0,
                  ),
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
                      controller: _priceController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter a price (RM)',
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        errorMaxLines: 1,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) _submit();
                        },
                        child: Text('Confirm'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
