import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _userList = [];
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkAdminStatus();
  }

  void _checkAdminStatus() {
    // Check if the logged-in user is admin
    setState(() {
      _isAdmin = true; // Replace with actual admin check logic
    });
  }

  void _loadUserData() async {
    final List<Map<String, dynamic>> result = await _dbHelper.getAllUsers();
    setState(() {
      _userList = result;
    });
  }

  void _editUser(int index) async {
    String newUsername = '';
    String newPassword = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'New Username'),
                onChanged: (value) {
                  newUsername = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'New Password'),
                onChanged: (value) {
                  newPassword = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (newUsername.isNotEmpty && newPassword.isNotEmpty) {
                  String currentUsername = _userList[index]['username'];
                  await _dbHelper.updateUser(
                      currentUsername, newUsername, newPassword);
                  _loadUserData();
                }
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(int id) async {
    await _dbHelper.deleteUser(id);
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Management')),
      body: ListView.builder(
        itemCount: _userList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_userList[index]['username']),
            subtitle: Text('Password: ${_userList[index]['password']}'),
            trailing: _isAdmin
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editUser(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteUser(_userList[index]['id']),
                      ),
                    ],
                  )
                : null,
          );
        },
      ),
    );
  }
}
