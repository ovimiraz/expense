import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

class AnalyticsPage extends StatefulWidget {
  static const String routeName = '/analytics';
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void didChangeDependencies() {
    Provider.of<AppProvider>(context, listen: false).getAllExpenses();
    Provider.of<AppProvider>(context, listen: false).getAllCategories();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) => ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: provider.categoryList.length,
          itemBuilder: (context, index) {
            final category = provider.categoryList[index];
            return ListTile(
              title: Text(category.name),
              subtitle: LinearPercentIndicator(
                lineHeight: 20.0,
                percent: provider.getExpensePercentageByCategory(category.name) / 100,
                backgroundColor: Colors.grey,
                progressColor: Colors.amber,
                center: Text('${provider.getExpensePercentageByCategory(category.name).toStringAsFixed(0)}%'),
                barRadius: const Radius.circular(8.0),
              ),
            );
          },
        ),
      ),
    );
  }
}
