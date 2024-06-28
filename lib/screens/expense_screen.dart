import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'package:intl/intl.dart';

class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  String _selectedCategory = 'Food';
  final List<String> _categories = [
    'Food',
    'Transport',
    'Apparel',
    'Education',
    'Health',
    'Others'
  ];

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  void _addExpense() async {
    if (_formKey.currentState!.validate()) {
      double amount = double.parse(_amountController.text);
      String description = _descriptionController.text;
      String date = _dateController.text;
      String category = _selectedCategory;
      String notes = _notesController.text;
      await _dbHelper.addExpense(amount, description, date, category, notes);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Expense')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Category'),
              DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addExpense,
                child: Text('Add Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
