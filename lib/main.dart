import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './helpers/material_color_generator.dart';

import './screens/home_screen.dart';
import './screens/product_category_screen.dart';
import './screens/product_listing_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/favourite_screen.dart';
import './screens/account_screen.dart';
import './screens/manage_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Future<void> initializeDefault() async {
  //   FirebaseApp app = await Firebase.initializeApp();
  //   assert(app != null);
  //   print('Initialized default app $app');
  // }

  @override
  Widget build(BuildContext context) {
    return
        // FutureBuilder(
        //   future: initializeDefault(),
        //   builder: (context, appSnapshot) {
        //     return
        MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EasyTrack',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(Palette.primary),
        shadowColor: generateMaterialColor(Palette.shadow),
        errorColor: Colors.red,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }
            if (userSnapshot.hasData) {
              return HomeScreen();
            }
            return AuthScreen();
          }),
      routes: {
        HomeScreen.routeName: (ctx) => HomeScreen(),
        ProductCategoryScreen.routeName: (ctx) => ProductCategoryScreen(),
        ProductListingScreen.routeName: (ctx) => ProductListingScreen(),
        ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        EditProductScreen.routeName: (ctx) => EditProductScreen(),
        FavouriteScreen.routeName: (ctx) => FavouriteScreen(),
        AccountScreen.routeName: (ctx) => AccountScreen(),
        ManageProductScreen.routeName: (ctx) => ManageProductScreen(),
        AuthScreen.routeName: (ctx) => AuthScreen(),
      },
    );
  }
}

class Palette {
  static const Color primary = Color(0xFF3B59D3);
  static const Color shadow = Color(0xFFE2E2E2);
}
