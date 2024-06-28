import 'package:flutter/material.dart';
import '../global_state.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            title: Text('Income'),
            onTap: () {
              Navigator.pushNamed(context, '/income');
            },
          ),
          ListTile(
            title: Text('Expense'),
            onTap: () {
              Navigator.pushNamed(context, '/expense');
            },
          ),
          ListTile(
            title: Text('User logs'),
            onTap: () {
              if (GlobalState.currentUsername == 'admin' &&
                  GlobalState.currentPassword == 'admin123') {
                Navigator.pushNamed(context, '/user_management');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Access denied. Admin only.')),
                );
              }
            },
          ),
          ListTile(
            title: Text('Account'),
            onTap: () {
              Navigator.pushNamed(context, '/account');
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
