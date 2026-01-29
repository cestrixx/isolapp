import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isolapp/pages/item_form_page.dart';
import 'package:isolapp/services/budget_service.dart';
import 'package:isolapp/services/json_service.dart';

class BudgetDetailPage extends ConsumerWidget {
  const BudgetDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(selectedBudgetService);

    if (budget == null) {
      return const Scaffold(
        body: Center(child: Text('Erro ao carregar orçamento.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Tecnit - Orçamento', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Exportar JSON',
            onPressed: () async {
              try {
                await JsonService().exportBudget(budget);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Arquivo JSON gerado com sucesso!'),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Erro ao exportar: $e')));
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(budget.worksite, style: const TextStyle(fontSize: 18)),
                Text('${budget.city} - ${DateFormat('d MMM y').format(budget.date)}',),
              ],
            ),
          ),
          Divider(height: 16,),
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
                        subtitle: Text(
                          'Setor: ${item.sector} | Revestimento: ${item.coating}',
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ItemFormPage(budget: budget, item: item),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemFormPage(budget: budget),
            ),
          );
        },
        child: const Icon(Icons.add),
      )
    );
  }
}
