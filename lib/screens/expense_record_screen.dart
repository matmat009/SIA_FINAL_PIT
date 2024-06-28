import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class ExpenseRecordScreen extends StatefulWidget {
  @override
  _ExpenseRecordScreenState createState() => _ExpenseRecordScreenState();
}

class _ExpenseRecordScreenState extends State<ExpenseRecordScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _expenseRecords;

  @override
  void initState() {
    super.initState();
    _fetchExpenseRecords();
  }

  void _fetchExpenseRecords() {
    setState(() {
      _expenseRecords = _dbHelper.getExpenses();
    });
  }

  void _showRecordDetails(BuildContext context, Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Expense Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Amount: ₱${record['amount']}'),
              Text('Description: ${record['description']}'),
              Text('Date: ${record['date']}'),
              Text('Category: ${record['category']}'),
              Text('Notes: ${record['notes']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _deleteRecord(BuildContext context, int id) async {
    await _dbHelper.deleteExpense(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Expense record deleted')),
    );
    _fetchExpenseRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expense Records')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _expenseRecords,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No expense records found.'));
          } else {
            final expenses = snapshot.data!;
            return ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return GestureDetector(
                  onTap: () => _showRecordDetails(context, expense),
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description: ${expense['description']}',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                'Amount: ₱${expense['amount']}',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                'Date: ${expense['date']}',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                'Category: ${expense['category']}',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteRecord(context, expense['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
