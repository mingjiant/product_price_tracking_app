import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductImagePicker extends StatefulWidget {
  @override
  _ProductImagePickerState createState() => _ProductImagePickerState();
}

class _ProductImagePickerState extends State<ProductImagePicker> {
  File _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      Navigator.of(context).pop();
      _pickedImage = pickedImageFile;
    });
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      Navigator.of(context).pop();
      _pickedImage = pickedImageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AlertDialog uploadImage = AlertDialog(
          title: Text('Upload an image'),
          actions: [
            TextButton(
              onPressed: _pickImage,
              child: Text('Take Photo'),
            ),
            TextButton(
              onPressed: _pickImageGallery,
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
                fit: BoxFit.cover,
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
            : Icon(
                Icons.photo_camera,
                color: Colors.white,
                size: 45,
              ),
      ),
    );
  }
}
