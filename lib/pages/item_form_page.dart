
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isolapp/models/budget_model.dart';
import 'package:isolapp/models/item_model.dart';
import 'package:isolapp/models/part_model.dart';
import 'package:isolapp/pages/part_form_page.dart';
import 'package:isolapp/services/budget_service.dart';
import 'package:uuid/uuid.dart';

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
  late double _pressure;
  late double _celsiusDegree;
  late double _diameter;
  late double _perimeter;
  late double _linearMeter;
  late double _squareMeter;
  late int _multiplierFactor;
  late List<PartModel> _parts;

  @override
  void initState() {
    super.initState();
    _sectorController = TextEditingController(text: widget.item?.sector ?? '');
    _descriptionController = TextEditingController(text: widget.item?.description ?? '');
    _coatingController = TextEditingController(text: widget.item?.coating ?? '');
    _pressure = widget.item?.pressure ?? 0.0;
    _celsiusDegree = widget.item?.degreesCelsius ?? 0.0;
    _diameter = widget.item?.diameter ?? 0.0;
    _perimeter = widget.item?.perimeter ?? 0.0;
    _insulatingController = TextEditingController(text: widget.item?.insulating ?? '');
    _linearMeter = widget.item?.linearMeter ?? 0.0;
    _squareMeter = widget.item?.squareMeter ?? 0.0;
    _multiplierFactor = widget.item?.multiplierFactor ?? 1;
    _parts = widget.item?.parts != null ? List.from(widget.item!.parts) : [];
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final newItem = ItemModel(
        id: widget.item?.id ?? const Uuid().v4(),
        budgetId: widget.budget.id,
        index: widget.item?.index ?? widget.budget.items.length + 1,
        sector: _sectorController.text,
        description: _descriptionController.text,
        coating: _coatingController.text,
        pressure: _pressure,
        degreesCelsius: _celsiusDegree,
        diameter: _diameter,
        perimeter: _perimeter,
        insulating: _insulatingController.text,
        linearMeter: _linearMeter,
        squareMeter: _squareMeter,
        multiplierFactor: _multiplierFactor,
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
      ref.read(budgetsService.notifier).updateBudget(updatedBudget);
      ref.read(selectedBudgetService.notifier).state = updatedBudget;
      
      Navigator.pop(context);
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
              child: ImageIcon(AssetImage('assets/icon/logo_tecnit_service.png'), size: 32,),
            ),
            const Text('Item', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          ],
        ),

        // title: Text('Tecnit - Item', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Image.asset('assets/icon/logo_tecnit_service.png'),
        // ),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveItem),
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
                    initialValue: _pressure.toString(),
                    decoration: const InputDecoration(labelText: 'Pressão', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _pressure = double.tryParse(v) ?? 0.0,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: _celsiusDegree.toString(),
                    decoration: const InputDecoration(labelText: 'Temperatura (°C)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _celsiusDegree = double.tryParse(v) ?? 0.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _diameter.toString(),
                    decoration: const InputDecoration(labelText: 'Diâmetro', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _diameter = double.tryParse(v) ?? 0.0,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: _perimeter.toString(),
                    decoration: const InputDecoration(labelText: 'Perímetro', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _perimeter = double.tryParse(v) ?? 0.0,
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
                    initialValue: _linearMeter.toString(),
                    decoration: const InputDecoration(labelText: 'Metro Linear', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _linearMeter = double.tryParse(v) ?? 0.0,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: _squareMeter.toString(),
                    decoration: const InputDecoration(labelText: 'Metro Quadrado', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _squareMeter = double.tryParse(v) ?? 0.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _multiplierFactor.toString(),
              decoration: const InputDecoration(labelText: 'Fator Multiplicador', border: OutlineInputBorder(),),
              keyboardType: TextInputType.number,
              onChanged: (v) => _multiplierFactor = int.tryParse(v) ?? 1,
            ),
            const Divider(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Peças / Partes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push<PartModel>(
                      context,
                      MaterialPageRoute(builder: (context) => const PartFormPage()),
                    );
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
                      return Card(
                        child: _buildPartTile(part, index)
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _updatePart(PartModel part, int index) async {
    final result = await Navigator.push<PartModel>(
      context,
      MaterialPageRoute(builder: (context) => PartFormPage(part: part,)),
    );
    
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
            onPressed: () => setState(() => _parts.removeAt(index)),
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
            onPressed: () => setState(() => _parts.removeAt(index)),
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
            onPressed: () => setState(() => _parts.removeAt(index)),
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
            onPressed: () => setState(() => _parts.removeAt(index)),
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
            onPressed: () => setState(() => _parts.removeAt(index)),
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
            onPressed: () => setState(() => _parts.removeAt(index)),
          ),
        );
      default:
        return ListTile();
    }
  }
}
