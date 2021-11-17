import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class ProductImagePicker extends StatefulWidget {
  ProductImagePicker(this.imagePicker);

  final void Function(File pickedImage) imagePicker;

  @override
  _ProductImagePickerState createState() => _ProductImagePickerState();
}

class _ProductImagePickerState extends State<ProductImagePicker> {
  File _pickedImage;
  var _isLoading = false;

  // Take image using camera
  void _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedImage =
          await picker.getImage(source: ImageSource.camera, imageQuality: 50);
      final pickedImageFile = File(pickedImage.path);
      setState(() {
        _pickedImage = pickedImageFile;
      });
      widget.imagePicker(pickedImageFile);
    } catch (e) {
      print(e);
    }
  }

  // Upload image from gallery
  void _pickImageGallery() async {
    try {
      final picker = ImagePicker();
      final pickedImage =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
      final pickedImageFile = File(pickedImage.path);
      setState(() {
        _pickedImage = pickedImageFile;
      });
      widget.imagePicker(pickedImageFile);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: SpinKitThreeBounce(
              color: Theme.of(context).primaryColor,
              size: 30.0,
            ),
          )
        : GestureDetector(
            onTap: () {
              AlertDialog uploadImage = AlertDialog(
                title: Text('Upload an image'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                actions: [
                  TextButton(
                    onPressed: () {
                      _pickImage();
                      Navigator.of(context).pop();
                    },
                    child: Text('Take Photo'),
                  ),
                  TextButton(
                    onPressed: () {
                      _pickImageGallery();
                      Navigator.of(context).pop();
                    },
                    child: Text('Choose from gallery'),
                  ),
                ],
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return uploadImage;
                },
              );
            },
            child: Container(
              width: 350,
              height: 190,
              margin: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.rectangle,
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    spreadRadius: 2,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: _pickedImage != null
                  ? Image(
                      image: FileImage(
                        _pickedImage,
                      ),
                      fit: BoxFit.contain,
                      frameBuilder: (
                        BuildContext context,
                        Widget child,
                        int frame,
                        bool wasSynchronouslyLoaded,
                      ) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 5),
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                          child: child,
                        );
                      },
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_camera,
                          color: Colors.white,
                          size: 45,
                        ),
                        Text(
                          'Add product image',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
            ),
          );
  }
}
