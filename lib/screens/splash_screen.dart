import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  static const spinKit = SpinKitThreeBounce(
    color: Colors.blue,
    size: 30.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            spinKit,
            Text('Loading'),
          ],
        ),
      ),
    );
  }
}
