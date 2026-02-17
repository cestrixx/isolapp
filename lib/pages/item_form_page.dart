
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isolapp/components/decimal_text_input_formatter.dart';
import 'package:isolapp/components/integer_text_input_formatter.dart';
import 'package:isolapp/models/budget_model.dart';
import 'package:isolapp/models/item_model.dart';
import 'package:isolapp/models/part_model.dart';
import 'package:isolapp/pages/part_form_page.dart';
import 'package:isolapp/services/budget_service.dart';
import 'package:isolapp/utils/commands.dart';
import 'package:isolapp/utils/speech.dart';
import 'package:uuid/uuid.dart';

@Preview(
  name: 'Item Form',
)

Widget preview() {
  final budget = BudgetModel(
    id: const Uuid().v4(),
    date: DateTime.now(),
    worksite: 'Orçamento Exemplo',
    city: 'Matão',
    items: [],
  );

  return ProviderScope(
    child: MaterialApp(
      home: ItemFormPage(budget: budget),
    ),
  );
}

class ItemFormPage extends ConsumerStatefulWidget {
  final BudgetModel budget;
  final ItemModel? item;

  const ItemFormPage({super.key, required this.budget, this.item});

  @override
  ConsumerState<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends ConsumerState<ItemFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _sectorController;
  late TextEditingController _descriptionController;
  late TextEditingController _coatingController;
  late TextEditingController _insulatingController;
  late TextEditingController _pressureController;
  late TextEditingController _celsiusDegreeController;
  late TextEditingController _diameterController;
  late TextEditingController _perimeterController;
  late TextEditingController _linearMeterController;
  late TextEditingController _squareMeterController;
  late TextEditingController _multiplierFactorController;
  late List<PartModel> _parts;
  bool _isSaving = false;
  String textSample = 'Click button to start recording';
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    _sectorController = TextEditingController(text: widget.item?.sector ?? '');
    _descriptionController = TextEditingController(text: widget.item?.description ?? '');
    _coatingController = TextEditingController(text: widget.item?.coating ?? '');
    _pressureController = TextEditingController(text: widget.item?.pressure.toString() ?? '0.0');
    _celsiusDegreeController = TextEditingController(text: widget.item?.degreesCelsius.toString() ?? '0.0');
    _diameterController = TextEditingController(text: widget.item?.diameter.toString() ?? '0.0');
    _perimeterController = TextEditingController(text: widget.item?.perimeter.toString() ?? '0.0');
    _insulatingController = TextEditingController(text: widget.item?.insulating ?? '');
    _linearMeterController = TextEditingController(text: widget.item?.linearMeter.toString() ?? '0.0');
    _squareMeterController = TextEditingController(text: widget.item?.squareMeter.toString() ?? '0.0');
    _multiplierFactorController = TextEditingController(text: widget.item?.multiplierFactor.toString() ?? '1');
    _parts = widget.item?.parts != null ? List.from(widget.item!.parts) : [];
  }

  @override
  void dispose() {
    _sectorController.dispose();
    _descriptionController.dispose();
    _coatingController.dispose();
    _insulatingController.dispose();
    _pressureController.dispose();
    _celsiusDegreeController.dispose();
    _diameterController.dispose();
    _perimeterController.dispose();
    _linearMeterController.dispose();
    _squareMeterController.dispose();
    _multiplierFactorController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      try {
        final newItem = ItemModel(
          id: widget.item?.id ?? const Uuid().v4(),
          budgetId: widget.budget.id,
          index: widget.item?.index ?? widget.budget.items.length + 1,
          sector: _sectorController.text,
          description: _descriptionController.text,
          coating: _coatingController.text,
          pressure: _pressureController.text.isNotEmpty ? double.parse(_pressureController.text) : 0.0,
          degreesCelsius: _celsiusDegreeController.text.isNotEmpty ? double.parse(_celsiusDegreeController.text) : 0.0,
          diameter: _diameterController.text.isNotEmpty ? double.parse(_diameterController.text) : 0.0,
          perimeter: _perimeterController.text.isNotEmpty ? double.parse(_perimeterController.text) : 0.0,
          insulating: _insulatingController.text,
          linearMeter: _linearMeterController.text.isNotEmpty ? double.parse(_linearMeterController.text) : 0.0,
          squareMeter: _squareMeterController.text.isNotEmpty ? double.parse(_squareMeterController.text) : 0.0,
          multiplierFactor: _multiplierFactorController.text.isNotEmpty ? int.parse(_multiplierFactorController.text) : 1,
          parts: _parts,
        );

        List<ItemModel> updatedItems = List.from(widget.budget.items);
        if (widget.item != null) {
          final index = updatedItems.indexWhere((i) => i.id == widget.item!.id);
          updatedItems[index] = newItem;
        } else {
          updatedItems.add(newItem);
        }

        final updatedBudget = widget.budget.copyWith(items: updatedItems);
        await ref.read(budgetsService.notifier).updateBudget(updatedBudget);
        ref.read(selectedBudgetService.notifier).state = updatedBudget;
        
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar item: $e'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSaving = false);
        }
      }
    }
  }

  Future<void> _deletePart(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja realmente excluir esta peça?'),
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
      setState(() => _parts.removeAt(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ImageIcon(AssetImage('assets/logo_tecnit_service.png'), size: 32),
            ),
            const Text('Item', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: _isSaving 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveItem,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _sectorController,
              decoration: const InputDecoration(labelText: 'Setor', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 2,
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _coatingController,
              decoration: const InputDecoration(labelText: 'Revestimento', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _pressureController,
                    decoration: InputDecoration(labelText: 'Pressão', border: OutlineInputBorder()),
                    inputFormatters: [DecimalTextInputFormatter()],
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _celsiusDegreeController,
                    decoration: InputDecoration(labelText: 'Temperatura (°C)', border: OutlineInputBorder()),
                    inputFormatters: [DecimalTextInputFormatter()],
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _diameterController,
                    decoration: InputDecoration(labelText: 'Diâmetro (Ø)', border: OutlineInputBorder()),
                    inputFormatters: [DecimalTextInputFormatter()],
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _perimeterController,
                    decoration: InputDecoration(labelText: 'Perímetro', border: OutlineInputBorder()),
                    inputFormatters: [DecimalTextInputFormatter()],
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _insulatingController,
              decoration: const InputDecoration(labelText: 'Isolante', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _linearMeterController,
                    decoration: InputDecoration(labelText: 'Metro Linear', border: OutlineInputBorder()),
                    inputFormatters: [DecimalTextInputFormatter()],
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _squareMeterController,
                    decoration: InputDecoration(labelText: 'Metro Quadrado', border: OutlineInputBorder()),
                    inputFormatters: [DecimalTextInputFormatter()],
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _multiplierFactorController,
              decoration: const InputDecoration(labelText: 'Fator Multiplicador (X)', border: OutlineInputBorder()),
              inputFormatters: [IntegerTextInputFormatter()],
              keyboardType: TextInputType.number,
            ),
            const Divider(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Peças / Partes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push<PartModel>(context, MaterialPageRoute(builder: (context) => const PartFormPage()));
                    if (result != null) {
                      setState(() => _parts.add(result));
                    }
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _parts.isEmpty
                ? const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('Nenhuma peça adicionada.')))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _parts.length,
                    itemBuilder: (context, index) {
                      final part = _parts[index];
                      return Card(child: _buildPartTile(part, index));
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: AvatarGlow(
        animate: isListening,
        glowColor: Colors.teal,
        child: FloatingActionButton(
          onPressed: toggleRecording,
          child: Icon(isListening ? Icons.circle : Icons.mic, size: 35),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _updatePart(PartModel part, int index) async {
    final result = await Navigator.push<PartModel>(context, MaterialPageRoute(builder: (context) => PartFormPage(part: part)));
    if (result != null) {
      setState(() {
        _parts[index] = result;
      });
    }
  }

  ListTile _buildPartTile(PartModel part, int index) {
    switch (part.type) {
      case PartType.tee:
      case PartType.conical:
        return ListTile(
          title: Text('Tipo: ${partTypeToString(part.type).toUpperCase()}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quantidade: ${part.amount}',),
              Text('Fator Multiplicador: ${part.multiplierFactor.toString()}',),
            ],
          ),
          onTap: () => _updatePart(part, index),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deletePart(index),
          ),
        );
      case PartType.bend:
      case PartType.benddegree45:
        return ListTile(
          title: Text('Tipo: ${partTypeToString(part.type).toUpperCase()}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quantidade: ${part.amount}',),
              Text('Fator Multiplicador: ${part.multiplierFactor.toString()}',),
              Text('${variableTypeToString(VariableType.extrados)}: ${part.variables[VariableType.extrados].toString()}'),
            ],
          ),
          onTap: () => _updatePart(part, index),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deletePart(index),
          ),
        );
      case PartType.flange:
      case PartType.cap:
      case PartType.cover:
      case PartType.reducingcoupling:
        return ListTile(
          title: Text('Tipo: ${partTypeToString(part.type).toUpperCase()}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quantidade: ${part.amount}',),
              Text('Fator Multiplicador: ${part.multiplierFactor.toString()}',),
              Text('${variableTypeToString(VariableType.majordiameter)}: ${part.variables[VariableType.majordiameter].toString()}'),
              Text('${variableTypeToString(VariableType.minordiameter)}: ${part.variables[VariableType.minordiameter].toString()}'),
            ],
          ),
          onTap: () => _updatePart(part, index),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deletePart(index),
          ),
        );
      case PartType.dishedhead:
        return ListTile(
          title: Text('Tipo: ${partTypeToString(part.type).toUpperCase()}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quantidade: ${part.amount}',),
              Text('Fator Multiplicador: ${part.multiplierFactor.toString()}',),
              Text('${variableTypeToString(VariableType.weldbead)}: ${part.variables[VariableType.weldbead].toString()}'),
            ],
          ),
          onTap: () => _updatePart(part, index),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deletePart(index),
          ),
        );
      case PartType.valvebox:
      case PartType.insulationfinish:
      case PartType.angleiron:
      case PartType.pipeshoe:
        return ListTile(
          title: Text('Tipo: ${partTypeToString(part.type).toUpperCase()}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quantidade: ${part.amount}',),
              Text('Fator Multiplicador: ${part.multiplierFactor.toString()}',),
              Text('${variableTypeToString(VariableType.width)}: ${part.variables[VariableType.width].toString()}'),
              Text('${variableTypeToString(VariableType.height)}: ${part.variables[VariableType.height].toString()}'),
            ],
          ),
          onTap: () => _updatePart(part, index),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deletePart(index),
          ),
        );
      case PartType.squaretoround:
        return ListTile(
          title: Text('Tipo: ${partTypeToString(part.type).toUpperCase()}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quantidade: ${part.amount}',),
              Text('Fator Multiplicador: ${part.multiplierFactor.toString()}',),
              Text('${variableTypeToString(VariableType.minorperimeter)}: ${part.variables[VariableType.minorperimeter].toString()}'),
              Text('${variableTypeToString(VariableType.majorperimeter)}: ${part.variables[VariableType.majorperimeter].toString()}'),
              Text('${variableTypeToString(VariableType.length)}: ${part.variables[VariableType.length].toString()}'),
            ],
          ),
          onTap: () => _updatePart(part, index),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deletePart(index),
          ),
        );
      default:
        return ListTile();
    }
  }


  Future toggleRecording() => Speech.toggleRecording(
  onResult: (String text) => setState(() { 
    textSample = text;
  }),
  onListening: (bool isListening) {
    setState(() {
      this.isListening = isListening;
    });
    if (!isListening) {
      Future.delayed(const Duration(milliseconds: 1000), () { 
        Utils.scanVoicedText(textSample, (String command, String value) {
          // ignore: avoid_print
          print('Command: $command, Value: $value'); 
          if (command == Command.sector) {
            setState(() {
              _sectorController.text = value;
            });
          } else if (command == Command.description) {
            setState(() {
              _descriptionController.text = value;
            });
          } else if (command == Command.coating) {
            setState(() {
              _coatingController.text = value;
            });
          } else if (command == Command.insulating) {
            setState(() {
              _insulatingController.text = value;
            });
          } else if (command == Command.pressure) {
            setState(() {
              _pressureController.text = double.tryParse(value)?.toString() ?? '0.0';
            });
          } else if (command == Command.degreesCelsius) {
            setState(() {
              _celsiusDegreeController.text = double.tryParse(value)?.toString() ?? '0.0';
            });
          } else if (command == Command.diameter) {
            setState(() {
              _diameterController.text = double.tryParse(value)?.toString() ?? '0.0';
            });
          } else if (command == Command.perimeter) {
            setState(() {
              _perimeterController.text = double.tryParse(value)?.toString() ?? '0.0';
            });
          } else if (command == Command.linearMeter) {
            setState(() {
              _linearMeterController.text = double.tryParse(value)?.toString() ?? '0.0';
            });
          } else if (command == Command.squareMeter) {
            setState(() {
              _squareMeterController.text = double.tryParse(value)?.toString() ?? '0.0';
            });
          } else if (command == Command.multiplierFactor) {
            setState(() {
              _multiplierFactorController.text = int.tryParse(value)?.toString() ?? '1';
            });
          }
        });
      });
    }
  });
}
