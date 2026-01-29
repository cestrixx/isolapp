import 'package:hive_flutter/hive_flutter.dart';

part 'part_model.g.dart';

@HiveType(typeId: 0)
enum VariableType {
  @HiveField(0) none,
  @HiveField(1) pressure,
  @HiveField(2) degreescelsius,
  @HiveField(3) diameter,
  @HiveField(4) perimeter,
  @HiveField(5) insulating,
  @HiveField(6) linearmeter,
  @HiveField(7) squaremeter,
  @HiveField(8) side,
  @HiveField(9) width,
  @HiveField(10) height,
  @HiveField(11) majordiameter,
  @HiveField(12) minordiameter,
  @HiveField(13) length,
  @HiveField(14) weldbead,
  @HiveField(15) extrados,
  @HiveField(16) amount,
}

String variableTypeToString(VariableType variable) {
  switch (variable) {
    case VariableType.none:
      return 'Nenhum';
    case VariableType.pressure:
      return 'Pressão';
    case VariableType.degreescelsius:
      return 'Graus Celsius';
    case VariableType.diameter:
      return 'Diâmetro';
    case VariableType.perimeter:
      return 'Perímetro';
    case VariableType.insulating:
      return 'Isolante';
    case VariableType.linearmeter:
      return 'Metro linear';
    case VariableType.squaremeter:
      return 'Metro quadrado';
    case VariableType.side:
      return 'Lado';
    case VariableType.width:
      return 'Largura';
    case VariableType.height:
      return 'Altura';
    case VariableType.majordiameter:
      return 'Diâmetro maior';
    case VariableType.minordiameter:
      return 'Diâmetro menor';
    case VariableType.length:
      return 'Comprimento';
    case VariableType.weldbead:
      return 'Cordão';
    case VariableType.extrados:
      return 'Costado';
    case VariableType.amount:
      return 'Quantidade';
  }
}

VariableType stringToVariableType(String str) {
  for (var variable in VariableType.values) {
    if (variableTypeToString(variable) == str) {
      return variable;
    }
  }
  return VariableType.none;
}

@HiveType(typeId: 1)
enum PartType {
  @HiveField(0) none,
  @HiveField(1) bend,
  @HiveField(2) tee,
  @HiveField(3) benddegree45,
  @HiveField(4) conical,
  @HiveField(5) flange,
  @HiveField(6) cap,
  @HiveField(7) cover,
  @HiveField(8) dishedhead,
  @HiveField(9) reducingcoupling,
  @HiveField(10) valvebox,
  @HiveField(11) insulationfinish,
  @HiveField(12) angleiron,
  @HiveField(13) pipeshoe
}

String partTypeToString(PartType type) {
  switch (type) {
    case PartType.none:
      return 'Nenhum';
    case PartType.bend:
      return 'Curva';
    case PartType.tee:
      return 'Boca T';
    case PartType.benddegree45:
      return 'Curva 45°';
    case PartType.conical:
      return 'Cônico';
    case PartType.flange:
      return 'Flange';
    case PartType.cap:
      return 'Tampa';
    case PartType.cover:
      return 'Capa';
    case PartType.dishedhead:
      return 'Cabeça abalada';
    case PartType.reducingcoupling:
      return 'Luva de redução';
    case PartType.valvebox:
      return 'Caixa de válvula';
    case PartType.insulationfinish:
      return 'Acabamento de isolamento';
    case PartType.angleiron:
      return 'Cantoneira';
    case PartType.pipeshoe:
      return 'Sapata de tubo';
  }
}

PartType stringToPartType(String str) {
  for (var type in PartType.values) {
    if (partTypeToString(type) == str) {
      return type;
    }
  }
  return PartType.none;
}


@HiveType(typeId: 4)
class PartModel extends HiveObject {
  @HiveField(0)
  final PartType type;
  @HiveField(1)
  final int amount;
  @HiveField(2)
  final Map<VariableType, dynamic> variables;

  PartModel({
    this.type = PartType.none,
    this.amount = 1,
    Map<VariableType, dynamic>? variables,
  }) : this.variables = variables ?? {};

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'amount': amount,
        'variables': variables.map((key, value) => MapEntry(key.name, value)),
      };

  factory PartModel.fromJson(Map<String, dynamic> json) {
    final vars = (json['variables'] as Map).map(
      (key, value) => MapEntry(
        VariableType.values.firstWhere((e) => e.name == key),
        value,
      ),
    );
    return PartModel(
      type: PartType.values.firstWhere((e) => e.name == json['type']),
      amount: json['amount'],
      variables: Map<VariableType, dynamic>.from(vars),
    );
  }
}
