
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isolapp/budget_model.dart';
import 'package:isolapp/budget_repository.dart';

class IsolHomePage extends StatelessWidget {
  const IsolHomePage({super.key, required this.repository});
  final BudgetRepository repository;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Obras'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder(
        future: repository.findAll(),
        builder: (context, budgets) {
          if (budgets.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (budgets.hasError) {
            return Text('Error: ${budgets.error}');
          }
          if (budgets.data == null) {
            return Text('Nenhuma Obra!');
          }
          final budgetsData = budgets.data as List;
          return ListView.builder(
            itemCount: budgetsData.length,
            itemBuilder: (context, index) {
              final budget = budgetsData[index] as BudgetModel;
              return ListTile(
                title: Text(budget.worksite),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(budget.city),
                    Text(DateFormat('d MMM y').format(budget.date)),
                  ]
                ),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}