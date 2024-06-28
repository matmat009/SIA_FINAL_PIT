import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'expense_tracker.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT)',
    );
    await db.execute(
      'CREATE TABLE incomes(id INTEGER PRIMARY KEY AUTOINCREMENT, amount REAL, description TEXT, date TEXT, category TEXT, notes TEXT)',
    );
    await db.execute(
      'CREATE TABLE expenses(id INTEGER PRIMARY KEY AUTOINCREMENT, amount REAL, description TEXT, date TEXT, category TEXT, notes TEXT)',
    );

    // Insert default admin user
    await db.insert('users', {'username': 'admin', 'password': 'admin123'});
  }

  Future<int> registerUser(String username, String password) async {
    final db = await database;
    return await db
        .insert('users', {'username': username, 'password': password});
  }

  Future<Map<String, dynamic>?> loginUser(
      String username, String password) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<int> addIncome(double amount, String description, String date,
      String category, String notes) async {
    final db = await database;
    return await db.insert('incomes', {
      'amount': amount,
      'description': description,
      'date': date,
      'category': category,
      'notes': notes
    });
  }

  Future<int> addExpense(double amount, String description, String date,
      String category, String notes) async {
    final db = await database;
    return await db.insert('expenses', {
      'amount': amount,
      'description': description,
      'date': date,
      'category': category,
      'notes': notes
    });
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<int> updateUser(
      String? currentUsername, String newUsername, String newPassword) async {
    final db = await database;
    return await db.update(
      'users',
      {'username': newUsername, 'password': newPassword},
      where: 'username = ?',
      whereArgs: [currentUsername],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getIncomes() async {
    final db = await database;
    return await db.query('incomes', orderBy: 'date DESC');
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    final db = await database;
    return await db.query('expenses', orderBy: 'date DESC');
  }

  Future<int> deleteIncome(int id) async {
    final db = await database;
    return await db.delete(
      'incomes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateIncome(int id, double amount, String description,
      String date, String category, String notes) async {
    final db = await database;
    return await db.update(
      'incomes',
      {
        'amount': amount,
        'description': description,
        'date': date,
        'category': category,
        'notes': notes
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateExpense(int id, double amount, String description,
      String date, String category, String notes) async {
    final db = await database;
    return await db.update(
      'expenses',
      {
        'amount': amount,
        'description': description,
        'date': date,
        'category': category,
        'notes': notes
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> getIncomeById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'incomes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) return results.first;
    return null;
  }

  Future<Map<String, dynamic>?> getExpenseById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) return results.first;
    return null;
  }
}
