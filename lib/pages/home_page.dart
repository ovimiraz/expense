import 'package:daily_expense_tracker/customwidgets/main_drawer.dart';
import 'package:daily_expense_tracker/pages/add_expense_page.dart';
import 'package:daily_expense_tracker/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../providers/app_provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CategoryModel? categoryModel;
  DateTime? selectedDate;
  @override
  void didChangeDependencies() {
    Provider.of<AppProvider>(context, listen: false).getAllExpenses();
    Provider.of<AppProvider>(context, listen: false).getAllCategories();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: _showDatePickerDialog,
            icon: const Icon(Icons.calendar_month),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AddExpensePage.routeName),
        child: const Icon(Icons.add),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<AppProvider>(
                  builder: (context, provider, child) =>
                      DropdownButtonFormField<CategoryModel>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder()
                        ),
                        value: categoryModel,
                        hint: const Text('Select Category'),
                        isExpanded: true,
                        items: provider.categoryList
                            .map(
                              (e) => DropdownMenuItem<CategoryModel>(
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            categoryModel = value;
                          });
                          if(categoryModel!.name == 'All') {
                            provider.getAllExpenses();
                          } else {
                            provider.getAllExpensesByCategoryName(categoryModel!.name);
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      )),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: provider.expenseList.length,
                itemBuilder: (context, index) {
                  final expense = provider.expenseList[index];
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: const EdgeInsets.only(right: 20,),
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.delete, color: Colors.white, size: 30,),
                    ),
                    confirmDismiss: (direction) {
                      return showDialog(context: context, builder: (context) => AlertDialog(
                        title: const Text('Delete Expense'),
                        content: Text('Are you sure to delete item ${expense.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text('NO'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text('YES'),
                          ),
                        ],
                      ));
                    },
                    onDismissed: (direction) async {
                      final deletedId = await provider.deleteExpense(expense.id!);
                      showMsg(context, 'Deleted');
                    },
                    child: ListTile(
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AddExpensePage.routeName, arguments: expense);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      title: Text(expense.name),
                      subtitle: Text(expense.formattedDate),
                      trailing: Text('BDT${expense.amount}', style: const TextStyle(fontSize: 20),),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePickerDialog() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
      Provider.of<AppProvider>(context, listen: false)
      .getAllExpensesByDateTime(selectedDate!);
    }
  }
}
