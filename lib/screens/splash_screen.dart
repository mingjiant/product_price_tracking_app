import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  static const spinKit = SpinKitThreeBounce(
    color: Colors.indigo,
    size: 30.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Stack(
            children: [
              Positioned(
                top: -20,
                right: 100,
                child: Image.asset('assets/images/6.png'),
              ),
              Positioned(
                top: -100,
                right: 50,
                child: Image.asset('assets/images/6.png'),
              ),
              Positioned(
                top: 10,
                right: -20,
                child: Image.asset('assets/images/5.png'),
              ),
              Positioned(
                top: -50,
                right: -50,
                child: Image.asset('assets/images/5.png'),
              ),
              Positioned(
                bottom: -70,
                right: 140,
                child: Image.asset('assets/images/3.png'),
              ),
              Positioned(
                bottom: -100,
                left: 100,
                child: Image.asset('assets/images/6.png'),
              ),
              Positioned(
                bottom: -10,
                left: 150,
                child: Image.asset('assets/images/6.png'),
              ),
              Positioned(
                bottom: -60,
                right: 120,
                child: Image.asset('assets/images/4.png'),
              ),
            ],
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_blue.png',
                  height: 40,
                ),
                SizedBox(
                  height: 30,
                ),
                spinKit,
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Loading...',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
