import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../global_state.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newUsernameController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _updateAccount() async {
    if (_formKey.currentState!.validate()) {
      String currentPassword = _currentPasswordController.text;
      if (currentPassword == GlobalState.currentPassword) {
        String newUsername = _newUsernameController.text;
        String newPassword = _newPasswordController.text;
        await _dbHelper.updateUser(
            GlobalState.currentUsername, newUsername, newPassword);
        GlobalState.currentUsername = newUsername;
        GlobalState.currentPassword = newPassword;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account updated successfully.')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Current password is incorrect.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Settings')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _currentPasswordController,
                decoration: InputDecoration(labelText: 'Current Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter current password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _newUsernameController,
                decoration: InputDecoration(labelText: 'New Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateAccount,
                child: Text('Update Account'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
