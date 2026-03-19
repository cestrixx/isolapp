import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isolapp/models/budget_model.dart';
import 'package:isolapp/pages/budget_detail_page.dart';
import 'package:isolapp/services/budget_service.dart';
import 'package:isolapp/services/json_service.dart';
import 'package:uuid/uuid.dart';


enum Menu { theme, import }

@Preview(
  name: 'BudgetPage'
)

Widget preview() {
  return ProviderScope(
    child: MaterialApp(
      home: BudgetPage(),
    ),
  );
}

class BudgetPage extends ConsumerWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetsService);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ImageIcon(AssetImage('assets/logo_tecnit_service.png'), size: 32),
            ),
            const Text('Orçamentos', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          PopupMenuButton<Menu>(
            onSelected: (Menu item) {
              switch (item) {
                case Menu.import:
                  _importBudget(context, ref);
                  break;
                case Menu.theme:
                  _toggleTheme(context);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
              PopupMenuItem<Menu>(
                value: Menu.import,
                child: const ListTile(
                  leading: Icon(Icons.file_upload, color: Colors.blue),
                  title: Text('Importar Orçamento'),
                ),
              ),
              PopupMenuItem<Menu>(
                value: Menu.theme,
                child: const ListTile(
                  leading: Icon(Icons.published_with_changes, color: Colors.orange),
                  title: Text('Trocar tema'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: budgets.isEmpty
          ? const Center(child: Text('Nenhum orçamento cadastrado.'))
          : Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ListView.builder(
                itemCount: budgets.length,
                itemBuilder: (context, index) {
                  final budget = budgets[index];
                  return ListTile(
                    title: Text(budget.worksite, style: const TextStyle(fontSize: 18)),
                    subtitle: Text('${budget.city} - ${DateFormat('d MMM y').format(budget.date)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async{
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirmar exclusão'),
                            content: const Text('Deseja realmente excluir o Orçamento?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Excluir', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          ref.read(budgetsService.notifier).deleteBudget(budgets[index].id);
                        }
                      },
                    ),
                    onTap: () {
                      ref.read(selectedBudgetService.notifier).state = budget;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BudgetDetailPage()));
                    },
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateBudgetDialog(context, ref),
        //onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const SpeechPage())); },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _toggleTheme(BuildContext context) {
    if (AdaptiveTheme.of(context).mode.isLight) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setLight();
    }
  }

  Future<void> _importBudget(BuildContext context, WidgetRef ref) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);

      if (result != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final importedBudget = JsonService().importFromJson(jsonString);

        await ref.read(budgetsService.notifier).addBudget(importedBudget);

        if (context.mounted) {
          _showSnackBar(context, 'Orçamento importado com sucesso!', isError: false);
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'Erro ao importar: $e', isError: true);
      }
    }
  }

  void _showCreateBudgetDialog(BuildContext context, WidgetRef ref) {
    final worksiteController = TextEditingController();
    final cityController = TextEditingController();
    // final speech = ref.watch(speechProvider);
    // final notifier = ref.read(speechProvider.notifier);
    // String textSample = 'Click button to start recording';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo Orçamento'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: worksiteController,
                decoration: const InputDecoration(labelText: 'Obra', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'Cidade', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          Column(
            children: [
              // ElevatedButton(
              //   onPressed: () {
              //     if (speech.isListening) {
              //       notifier.stopListening();
              //     } else {
              //       if (!speech.isInitialized) {
              //         notifier.initialize();
              //       }
              //       if (speech.isListening) {
              //         notifier.stopListening();
              //       } else {
              //         notifier.startListening(
              //           localeId: 'pt_BR',
              //           onListeningResult: (recognizedText, confidence) {
              //             textSample = recognizedText;
              //             Utils.scanVoicedText(textSample, (
              //               String command,
              //               String value,
              //             ) {
              //               if (!speech.isListening && value.isNotEmpty) {
              //                 // ignore: avoid_print
              //                 print('Command: $command, Value: $value');
              //                 if (command == Command.worksite) {
              //                   worksiteController.text = value;
              //                 } else if (command == Command.city) {
              //                   cityController.text = value;
              //                 }
              //               }
              //             });
              //           },
              //         );
              //       }
              //     }
              //   },
              //   child: Icon(
              //     speech.isListening ? Icons.circle : Icons.mic,
              //     size: 35,
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (worksiteController.text.isEmpty ||
                          cityController.text.isEmpty) {
                        _showSnackBar(
                          context,
                          'Preencha todos os campos',
                          isError: true,
                        );
                        return;
                      }
                      final budget = BudgetModel(
                        id: const Uuid().v4(),
                        date: DateTime.now(),
                        worksite: worksiteController.text,
                        city: cityController.text,
                      );

                      ref.read(budgetsService.notifier)
                         .addBudget(budget);
                      
                      worksiteController.dispose();
                      cityController.dispose();
                      
                      Navigator.pop(context);
                      ref.read(selectedBudgetService.notifier).state = budget;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BudgetDetailPage()));
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: isError ? Colors.red : Colors.green),
    );
  }
}
