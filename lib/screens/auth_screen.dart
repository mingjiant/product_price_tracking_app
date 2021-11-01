import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/auth_card.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    bool isLogin,
    BuildContext context,
  ) async {
    AuthResult authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        // For user login
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // For user sign up
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'email': email,
        });
      }
    } on PlatformException catch (error) {
      var message = 'An error occurred, please check your credentials!';

      if (error.message != null) {
        message = error.message;
      }

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFADEBFF),
                  Color(0xFF3B59D3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        top: -20,
                        left: -180,
                        child: Image.asset('assets/images/6.png'),
                      ),
                      Positioned(
                        top: 10,
                        left: -20,
                        child: Image.asset('assets/images/1.png'),
                      ),
                      Positioned(
                        top: -10,
                        left: -50,
                        child: Image.asset('assets/images/1.png'),
                      ),
                      Positioned(
                        top: -10,
                        right: -20,
                        child: Image.asset('assets/images/5.png'),
                      ),
                      Positioned(
                        bottom: -60,
                        right: 120,
                        child: Image.asset('assets/images/2.png'),
                      ),
                      Positioned(
                        bottom: -60,
                        right: 30,
                        child: Image.asset('assets/images/2.png'),
                      ),
                      Positioned(
                        bottom: -60,
                        left: 150,
                        child: Image.asset('assets/images/3.png'),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 30.0),
                            child: Image.asset('assets/images/logo_white.png'),
                          ),
                        ),
                        Flexible(
                          flex: deviceSize.width > 600 ? 2 : 1,
                          child: AuthCard(
                            _submitAuthForm,
                            _isLoading,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
