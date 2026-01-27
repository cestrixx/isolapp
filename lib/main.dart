import 'package:flutter/material.dart';
import 'package:isolapp/in_memory_budget_repository.dart';
import 'package:isolapp/isol_home_page.dart';

void main() async {
  final repository = InMemoryBudgetRepository();
  repository.create(
    worksite: 'Heineken',
    city: 'Araraquara',
    date: DateTime(2026, 1, 13),
  );
  repository.create(
    worksite: 'Petrobras Boaventura',
    city: 'Rio de Janeiro',
    date: DateTime(2025, 12, 20),
  );
  repository.create(
    worksite: 'Petrobras Duque de Caxias',
    city: 'Rio de Janeiro',
    date: DateTime(2025, 9, 25),
  );
  repository.create(
    worksite: 'Petrobras Alberto Pasqualini',
    city: 'Rio de Janeiro',
    date: DateTime(2025, 7, 13),
  );
  repository.create(
    worksite: 'Petrobras Gabriel Passos',
    city: 'Rio de Janeiro',
    date: DateTime(2025, 2, 28),
  );
  runApp(const IsolApp());
}

class IsolApp extends StatelessWidget {
  const IsolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: IsolHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
