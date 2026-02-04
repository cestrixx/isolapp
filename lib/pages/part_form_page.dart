import 'package:flutter/material.dart';
import 'package:isolapp/models/part_model.dart';

class PartFormPage extends StatefulWidget {
  final PartModel? part;
 
  const PartFormPage({super.key, this.part});

  @override
  State<PartFormPage> createState() => _PartFormPageState();
}

class _PartFormPageState extends State<PartFormPage> {
  late PartType _selectedType;
  late int _amount;
  final Map<VariableType, dynamic> _variables = {};

  void _save() {
    if (_selectedType == PartType.none) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione um tipo de peça')));
      return;
    }

    final newPart = PartModel(
      type: _selectedType,
      amount: _amount,
      variables: _variables,
    );
    
    Navigator.pop(context, newPart);
  }

  void _changePartType(PartType type) {
    _variables.clear();
    switch (type) {
      case PartType.none: break;
      case PartType.bend: 
        _variables[VariableType.extrados] = 0.0;
        break;
      case PartType.tee: break;
      case PartType.benddegree45:
        _variables[VariableType.extrados] = 0.0;
        break;
      case PartType.conical: break;
      case PartType.flange:
        _variables[VariableType.majordiameter] = 0.0;
        _variables[VariableType.minordiameter] = 0.0;
        break;
      case PartType.cap:
        _variables[VariableType.majordiameter] = 0.0;
        _variables[VariableType.minordiameter] = 0.0;
        break;
      case PartType.cover:
        _variables[VariableType.majordiameter] = 0.0;
        _variables[VariableType.minordiameter] = 0.0;
        break;
      case PartType.dishedhead:
        _variables[VariableType.weldbead] = 0.0;
        break;
      case PartType.reducingcoupling:
        _variables[VariableType.majordiameter] = 0.0;
        _variables[VariableType.minordiameter] = 0.0;
        break;
      case PartType.valvebox:
        _variables[VariableType.width] = 0.0;
        _variables[VariableType.height] = 0.0;
        break;
      case PartType.insulationfinish:
        _variables[VariableType.width] = 0.0;
        _variables[VariableType.height] = 0.0;
        break;
      case PartType.angleiron:
        _variables[VariableType.width] = 0.0;
        _variables[VariableType.height] = 0.0;
        break;
      case PartType.pipeshoe:
        _variables[VariableType.width] = 0.0;
        _variables[VariableType.height] = 0.0;
        break;
      case PartType.backstay:
        _variables[VariableType.height] = 0.0;
        _variables[VariableType.length] = 0.0;
        break;
      case PartType.asianconicalheat:
        _variables[VariableType.weldbead] = 0.0;
        _variables[VariableType.diameter] = 0.0;
        break;
      case PartType.squaretoround:
        _variables[VariableType.majorperimeter] = 0.0;
        _variables[VariableType.minorperimeter] = 0.0;
        _variables[VariableType.length] = 0.0;
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedType = widget.part?.type ?? PartType.none;
    _amount = widget.part?.amount ?? 1;
    if (widget.part?.variables != null) {
      _variables.addAll(widget.part!.variables);
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
            const Text('Peça', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _save),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<PartType>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: 'Tipo de Peça', border: OutlineInputBorder()),
              items: PartType.values.map((type) {
                return DropdownMenuItem(value: type, child: Text(partTypeToString(type).toUpperCase()));
              }).toList(),
              onChanged: (v) {
                _changePartType(v!);
                setState(() => _selectedType = v);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _amount.toString(),
              decoration: const InputDecoration(labelText: 'Quantidade', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              onChanged: (v) => _amount = int.tryParse(v) ?? 1,
            ),
            const SizedBox(height: 16),
            switch (_selectedType) {
              PartType.none => Container(),
              PartType.bend => TextFormField(
                initialValue: _variables[VariableType.extrados].toString(),
                decoration: InputDecoration(labelText: variableTypeToString(VariableType.extrados), border: const OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onChanged: (v) => _variables[VariableType.extrados] = double.tryParse(v) ?? 0.0,
              ),
              PartType.tee => Container(),
              PartType.benddegree45 => TextFormField(
                initialValue: _variables[VariableType.extrados].toString(),
                decoration: InputDecoration(labelText: variableTypeToString(VariableType.extrados), border: const OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onChanged: (v) => _variables[VariableType.extrados] = double.tryParse(v) ?? 0.0,
              ),
              PartType.conical => Container(),
              PartType.flange => Column(
                children: [
                  TextFormField(
                    initialValue: _variables[VariableType.majordiameter].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.majordiameter), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.majordiameter] = double.tryParse(v) ?? 0.0,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _variables[VariableType.minordiameter].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.minordiameter), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.minordiameter] = double.tryParse(v) ?? 0.0,
                  ),
                ],
              ),
              PartType.cap => Column(
                children: [
                  TextFormField(
                    initialValue: _variables[VariableType.majordiameter].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.majordiameter), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.majordiameter] = double.tryParse(v) ?? 0.0,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _variables[VariableType.minordiameter].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.minordiameter), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.minordiameter] = double.tryParse(v) ?? 0.0,
                  ),
                ],
              ),
              PartType.cover => Column(
                children: [
                  TextFormField(
                    initialValue: _variables[VariableType.majordiameter].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.majordiameter), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.majordiameter] = double.tryParse(v) ?? 0.0,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _variables[VariableType.minordiameter].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.minordiameter), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.minordiameter] = double.tryParse(v) ?? 0.0,
                  ),
                ],
              ),
              PartType.dishedhead => TextFormField(
                initialValue: _variables[VariableType.weldbead].toString(),
                decoration: InputDecoration(labelText: variableTypeToString(VariableType.weldbead), border: const OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onChanged: (v) => _variables[VariableType.weldbead] = double.tryParse(v) ?? 0.0,
              ),
              PartType.reducingcoupling => Column(
                children: [
                  TextFormField(
                    initialValue: _variables[VariableType.majordiameter].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.majordiameter), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.majordiameter] = double.tryParse(v) ?? 0.0,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _variables[VariableType.minordiameter].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.minordiameter), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.minordiameter] = double.tryParse(v) ?? 0.0,
                  ),
                ],
              ),
              PartType.valvebox => Column(
                children: [
                  TextFormField(
                    initialValue: _variables[VariableType.width].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.width), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.width] = double.tryParse(v) ?? 0.0,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _variables[VariableType.height].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.height), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.height] = double.tryParse(v) ?? 0.0,
                  ),
                ],
              ),
              PartType.insulationfinish => Column(
                children: [
                  TextFormField(
                    initialValue: _variables[VariableType.width].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.width), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.width] = double.tryParse(v) ?? 0.0,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _variables[VariableType.height].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.height), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.height] = double.tryParse(v) ?? 0.0,
                  ),
                ],
              ),
              PartType.angleiron => Column(
                children: [
                  TextFormField(
                    initialValue: _variables[VariableType.width].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.width), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.width] = double.tryParse(v) ?? 0.0,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _variables[VariableType.height].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.height), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.height] = double.tryParse(v) ?? 0.0,
                  ),
                ],
              ),
              PartType.pipeshoe => Column(
                children: [
                  TextFormField(
                    initialValue: _variables[VariableType.width].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.width), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.width] = double.tryParse(v) ?? 0.0,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _variables[VariableType.height].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.height), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.height] = double.tryParse(v) ?? 0.0,
                  ),
                ],
              ),
              PartType.backstay => Column(
                children: [
                  TextFormField(
                    initialValue: _variables[VariableType.height].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.height), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.height] = double.tryParse(v) ?? 0.0,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _variables[VariableType.length].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.length), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.length] = double.tryParse(v) ?? 0.0,
                  ),
                ],
              ),
              PartType.asianconicalheat => Column(
                children: [
                  TextFormField(
                    initialValue: _variables[VariableType.weldbead].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.weldbead), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.weldbead] = double.tryParse(v) ?? 0.0,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _variables[VariableType.diameter].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.diameter), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.diameter] = double.tryParse(v) ?? 0.0,
                  ),
                ],
              ),
              PartType.squaretoround => Column(
                children: [
                  TextFormField(
                    initialValue: _variables[VariableType.minorperimeter].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.minorperimeter), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.minorperimeter] = double.tryParse(v) ?? 0.0,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _variables[VariableType.majorperimeter].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.majorperimeter), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.majorperimeter] = double.tryParse(v) ?? 0.0,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _variables[VariableType.length].toString(),
                    decoration: InputDecoration(labelText: variableTypeToString(VariableType.length), border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _variables[VariableType.length] = double.tryParse(v) ?? 0.0,
                  ),
                ],
              ),
            }
          ],
        ),
      ),
    );
  }
}