import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class IncomeRecordScreen extends StatefulWidget {
  @override
  _IncomeRecordScreenState createState() => _IncomeRecordScreenState();
}

class _IncomeRecordScreenState extends State<IncomeRecordScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _incomeRecords;

  @override
  void initState() {
    super.initState();
    _fetchIncomeRecords();
  }

  void _fetchIncomeRecords() {
    setState(() {
      _incomeRecords = _dbHelper.getIncomes();
    });
  }

  void _showRecordDetails(BuildContext context, Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Income Details'),
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
    await _dbHelper.deleteIncome(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Income record deleted')),
    );
    _fetchIncomeRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Income Records')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _incomeRecords,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No income records found.'));
          } else {
            final incomes = snapshot.data!;
            return ListView.builder(
              itemCount: incomes.length,
              itemBuilder: (context, index) {
                final income = incomes[index];
                return GestureDetector(
                  onTap: () => _showRecordDetails(context, income),
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
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
                                'Description: ${income['description']}',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                'Amount: ₱${income['amount']}',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                'Date: ${income['date']}',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                'Category: ${income['category']}',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteRecord(context, income['id']),
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
