import 'package:daily_expense_tracker/pages/add_expense_page.dart';
import 'package:daily_expense_tracker/pages/analytics_page.dart';
import 'package:daily_expense_tracker/pages/category_page.dart';
import 'package:daily_expense_tracker/pages/home_page.dart';
import 'package:daily_expense_tracker/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (ctx) => AppProvider(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName : (context) => const HomePage(),
        AddExpensePage.routeName : (context) => const AddExpensePage(),
        CategoryPage.routeName : (context) => const CategoryPage(),
        AnalyticsPage.routeName : (context) => const AnalyticsPage(),
      },
    );
  }
}

