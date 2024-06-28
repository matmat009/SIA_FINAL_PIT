import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/income_screen.dart';
import 'screens/expense_screen.dart';
import 'screens/user_management_screen.dart';
import 'screens/account_screen.dart';
import 'screens/income_record_screen.dart'; // Import the IncomeRecordScreen
import 'screens/expense_record_screen.dart'; // Import the ExpenseRecordScreen

void main() {
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/income': (context) => IncomeScreen(),
        '/expense': (context) => ExpenseScreen(),
        '/user_management': (context) => UserManagementScreen(),
        '/account': (context) => AccountScreen(),
        '/income_records': (context) => IncomeRecordScreen(),
        '/expense_records': (context) => ExpenseRecordScreen(),
      },
    );
  }
}
