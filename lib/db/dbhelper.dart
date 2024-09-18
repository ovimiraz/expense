import 'package:daily_expense_tracker/models/category_model.dart';
import 'package:daily_expense_tracker/models/expense_model.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final String createTableCategory = '''create table $tblCategory(
    $tblCategoryColId integer primary key autoincrement,
    $tblCategoryColName text)''';

  final String createTableExpense = '''create table $tblExpense(
  $tblExpenseColId integer primary key,
  $tblExpenseColName text,
  $tblExpenseColCategory text,
  $tblExpenseColAmount integer,
  $tblExpenseColFormattedDate text,
  $tblExpenseColTimestamp integer,
  $tblExpenseColDay integer,
  $tblExpenseColMonth integer,
  $tblExpenseColYear integer)''';

  Future<Database> _open() async {
    final root = await getDatabasesPath();
    final dbPath = path.join(root, 'expense.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(createTableCategory);
        await db.execute(createTableExpense);
      },
    );
  }

  Future<int> insertCategory(CategoryModel model) async {
    final db = await _open();
    return db.insert(tblCategory, model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> insertExpense(ExpenseModel expense) async {
    final db = await _open();
    return db.insert(tblExpense, expense.toMap());
  }

  Future<int> updateExpense(ExpenseModel expense) async {
    final db = await _open();
    return db.update(tblExpense, expense.toMap(),
        where: '$tblExpenseColId = ?', whereArgs: [expense.id]);
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final db = await _open();
    final List<Map<String, dynamic>> mapList = await db.query(
      tblCategory,
      orderBy: tblCategoryColName,
    );
    return List.generate(
        mapList.length, (index) => CategoryModel.fromMap(mapList[index]));
  }

  Future<List<ExpenseModel>> getAllExpenses() async {
    final db = await _open();
    final List<Map<String, dynamic>> mapList =
        await db.query(tblExpense, orderBy: '$tblExpenseColTimestamp desc');
    print(mapList);
    return List.generate(
        mapList.length, (index) => ExpenseModel.fromMap(mapList[index]));
  }

  Future<List<ExpenseModel>> getAllExpensesByCategoryName(String name) async {
    final db = await _open();
    final List<Map<String, dynamic>> mapList = await db.query(tblExpense,
        where: '$tblExpenseColCategory = ?',
        whereArgs: [name],
        orderBy: '$tblExpenseColTimestamp desc');
    print(mapList);
    return List.generate(
        mapList.length, (index) => ExpenseModel.fromMap(mapList[index]));
  }

  Future<List<ExpenseModel>> getAllExpensesByDateTime(DateTime dt) async {
    final db = await _open();
    final List<Map<String, dynamic>> mapList = await db.query(
      tblExpense,
      where:
          '$tblExpenseColDay = ? and $tblExpenseColMonth = ? and $tblExpenseColYear = ?',
      whereArgs: [dt.day, dt.month, dt.year],
      orderBy: '$tblExpenseColTimestamp desc',
    );
    print(mapList);
    return List.generate(
        mapList.length, (index) => ExpenseModel.fromMap(mapList[index]));
  }

  Future<CategoryModel> getCategoryByName(String name) async {
    final db = await _open();
    final mapList = await db.query(tblCategory,
        where: '$tblCategoryColName = ?', whereArgs: [name]);
    print(mapList);
    return CategoryModel.fromMap(mapList.first);
  }

  Future<int> deleteExpenseById(int id) async {
    final db = await _open();
    return db
        .delete(tblExpense, where: '$tblExpenseColId = ?', whereArgs: [id]);
  }
}
