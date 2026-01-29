import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isolapp/models/budget_model.dart';
import 'package:isolapp/pages/budget_detail_page.dart';
import 'package:isolapp/services/budget_service.dart';
import 'package:isolapp/services/json_service.dart';
import 'package:uuid/uuid.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetsService);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tecnit - Orçamentos', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          Switch(
            value: AdaptiveTheme.of(context).mode.isDark,
            onChanged: (value) {
              if (value) {
                AdaptiveTheme.of(context).setDark();
              } else {
                AdaptiveTheme.of(context).setLight();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.file_upload),
            tooltip: 'Importar JSON',
            onPressed: () => _importBudget(context, ref),
          ),
        ],
      ),
      body: budgets.isEmpty
          ? const Center(child: Text('Nenhum orçamento cadastrado.'))
          : ListView.builder(
              itemCount: budgets.length,
              itemBuilder: (context, index) {
                final budget = budgets[index];
                return ListTile(
                  title: Text(budget.worksite),
                  subtitle: Text('${budget.city} - ${DateFormat('d MMM y').format(budget.date)}',),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => ref
                        .read(budgetsService.notifier)
                        .deleteBudget(budget.id),
                  ),
                  onTap: () {
                    ref.read(selectedBudgetService.notifier).state = budget;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) { return BudgetDetailPage(); },
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBudgetDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _importBudget(BuildContext context, WidgetRef ref) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final importedBudget = JsonService().importFromJson(jsonString);
       
        await ref.read(budgetsService.notifier).addBudget(importedBudget);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Orçamento importado com sucesso!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao importar: $e')),
      );
    }
  } 

  void _showAddBudgetDialog(BuildContext context, WidgetRef ref) {
    final worksiteController = TextEditingController();
    final cityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo Orçamento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: worksiteController, decoration: const InputDecoration(labelText: 'Obra', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: cityController, decoration: const InputDecoration(labelText: 'Cidade', border: OutlineInputBorder())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final newBudget = BudgetModel(
                id: const Uuid().v4(),
                date: DateTime.now(),
                worksite: worksiteController.text,
                city: cityController.text,
              );
              ref.read(budgetsService.notifier).addBudget(newBudget);
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
