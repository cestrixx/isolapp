import 'package:flutter/material.dart';

class BudgetFormPage extends StatelessWidget {
  const BudgetFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Obra'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}
