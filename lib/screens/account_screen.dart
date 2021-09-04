import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatelessWidget {
  static const routeName = '/account';

  Future signOut() async {
    try {
      return await FirebaseAuth.instance.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 4;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Account'),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1,
          ),
        ),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              height: 100,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    // backgroundColor: Colors.white,
                    child: Icon(
                      Icons.account_circle_outlined,
                      size: 60,
                    ),
                  ),
                  Container(
                    width: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Username',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              thickness: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.category,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'Manage product',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                Navigator.pushNamed(context, '/manage-product');
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              thickness: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              thickness: 1,
            ),
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
              Icons.account_circle_outlined,
            ),
            label: 'Account',
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
              Navigator.pushNamed(context, '/edit-product');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/favourite');
              break;
            case 4:
              break;
          }
        },
      ),
    );
  }
}
