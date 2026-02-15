import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isolapp/pages/item_form_page.dart';
import 'package:isolapp/services/budget_service.dart';
import 'package:isolapp/services/json_service.dart';

@Preview(
  name: 'BudgetDetailPage',
)

Widget preview() {
  return ProviderScope(
    child: const MaterialApp(
      home: BudgetDetailPage(),
    ),
  );
}

class BudgetDetailPage extends ConsumerWidget {
  const BudgetDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(selectedBudgetService);

    if (budget == null) {
      return const Scaffold(body: Center(child: Text('Erro ao carregar orçamento.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const _AppBarTitle(),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Exportar JSON',
            onPressed: () => _exportJson(context, budget),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(budget: budget),
          const Divider(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Itens', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: budget.items.isEmpty
                ? const Center(child: Text('Nenhum item adicionado.'))
                : ListView.builder(
                    itemCount: budget.items.length,
                    itemBuilder: (context, index) {
                      final item = budget.items[index];
                      return ListTile(
                        leading: CircleAvatar(child: Text('${item.index}')),
                        title: Text(item.description),
                        subtitle: Text('Setor: ${item.sector} | Revestimento: ${item.coating}'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ItemFormPage(budget: budget, item: item)));
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ItemFormPage(budget: budget)));
        },
        child: const Icon(Icons.add),
      )
    );
  }

  Future<void> _exportJson(BuildContext context, dynamic budget) async {
    try {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        final outputFile = await FilePicker.platform.saveFile(
          type: FileType.custom,
          allowedExtensions: ['json'],
          fileName: 'budget_${budget.id}.json',
        );

        if (outputFile != null) {
          final jsonString = jsonEncode(budget.toJson());
          final file = File(outputFile);
          await file.writeAsString(jsonString);
          if (context.mounted) {
            _showSnackBar(context, 'Arquivo JSON gerado com sucesso!');
          }
        }
      } else {
        await JsonService().exportBudget(budget);
        if (context.mounted) {
          _showSnackBar(context, 'Arquivo JSON gerado com sucesso!');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'Erro ao exportar: $e');
      }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: ImageIcon(
            AssetImage('assets/logo_tecnit_service.png'),
            size: 32,
            semanticLabel: 'Logo Tecnit Service',
          ),
        ),
        Text('Orçamento', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.budget});

  final dynamic budget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(budget.worksite, style: const TextStyle(fontSize: 18)),
          Text('${budget.city} - ${DateFormat('d MMM y').format(budget.date)}'),
        ],
      ),
    );
  }
}