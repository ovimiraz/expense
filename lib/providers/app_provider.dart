import 'package:daily_expense_tracker/db/dbhelper.dart';
import 'package:daily_expense_tracker/models/category_model.dart';
import 'package:daily_expense_tracker/models/expense_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AppProvider extends ChangeNotifier {
  List<CategoryModel> categoryList = [];
  List<ExpenseModel> expenseList = [];

  final db = DbHelper();

  num get totalExpenses {
    num total = 0;
    for(final exp in expenseList) {
      total += exp.amount;
    }
    return total;
  }



  Future<int> addCategory(String value) async {
    final category = CategoryModel(value);
    final id = await db.insertCategory(category);
    await getAllCategories();
    return id;
  }

  Future<int> addExpense(ExpenseModel expense) async {
    final id = await db.insertExpense(expense);
    await getAllExpenses();
    return id;
  }

  Future<void> getAllCategories() async {
    categoryList = await db.getAllCategories();
    print(categoryList);
    notifyListeners();
  }

  Future<void> getAllExpenses() async {
    expenseList = await db.getAllExpenses();
    notifyListeners();
  }

  Future<void> getAllExpensesByCategoryName(String name) async {
    expenseList = await db.getAllExpensesByCategoryName(name);
    notifyListeners();
  }

  Future<void> getAllExpensesByDateTime(DateTime dt) async {
    expenseList = await db.getAllExpensesByDateTime(dt);
    notifyListeners();
  }

  Future<CategoryModel> getCategoryByName(String name) async {
    return db.getCategoryByName(name);
  }

  Future<int> updateExpense(ExpenseModel expense) async{
    final id = await db.updateExpense(expense);
    await getAllExpenses();
    return id;
  }

  Future<int> deleteExpense(int id) async {
    final deletedRowId = await db.deleteExpenseById(id);
    await getAllExpenses();
    return deletedRowId;
  }

  num _getTotalExpenseByCategory(String categoryName) {
    num total = 0;
    final expList = expenseList.where((element) => element.categoryName == categoryName).toList();
    for(final exp in expList) {
      total += exp.amount;
    }
    return total;
  }

  double getExpensePercentageByCategory(String categoryName) {
    print(totalExpenses);
    final exp = _getTotalExpenseByCategory(categoryName);
    return 100 * exp / totalExpenses;
  }

}