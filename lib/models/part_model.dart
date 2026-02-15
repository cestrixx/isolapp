import 'package:hive_flutter/hive_flutter.dart';

part 'part_model.g.dart';

@HiveType(typeId: 0)
enum VariableType {
  @HiveField(0) none,
  @HiveField(1) pressure,
  @HiveField(2) degreescelsius,
  @HiveField(3) diameter,
  @HiveField(4) perimeter,
  @HiveField(5) minorperimeter,
  @HiveField(6) majorperimeter,
  @HiveField(7) insulating,
  @HiveField(8) linearmeter,
  @HiveField(9) squaremeter,
  @HiveField(10) side,
  @HiveField(11) width,
  @HiveField(12) height,
  @HiveField(13) majordiameter,
  @HiveField(14) minordiameter,
  @HiveField(15) length,
  @HiveField(16) weldbead,
  @HiveField(17) extrados,
  @HiveField(18) amount,
  @HiveField(19) multiplierFactor,
  @HiveField(20) sector,
  @HiveField(21) description,
  @HiveField(22) coating,
  @HiveField(23) parts,
}

String variableTypeToString(VariableType variable) {
  switch (variable) {
    case VariableType.none:
      return 'Nenhum';
    case VariableType.sector:
      return 'Setor';
    case VariableType.description:
      return 'Descrição';
    case VariableType.pressure:
      return 'Pressão';
    case VariableType.degreescelsius:
      return 'Graus Celsius';
    case VariableType.diameter:
      return 'Diâmetro';
    case VariableType.perimeter:
      return 'Perímetro';
    case VariableType.minorperimeter:
      return 'Perímetro menor';
    case VariableType.majorperimeter:
      return 'Perímetro maior';
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
    case VariableType.multiplierFactor:
      return 'Fator Multiplicador';
    case VariableType.coating:
      return 'Revestimento';
    case VariableType.parts:
      return 'Partes';
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
  @HiveField(13) pipeshoe,
  @HiveField(14) backstay,
  @HiveField(15) asianconicalheat,
  @HiveField(16) squaretoround,
}

String partTypeToString(PartType type) {
  switch (type) {
    case PartType.none:
      return 'Nenhum';
    case PartType.bend:
      return 'Curva Raio Longo';
    case PartType.tee:
      return 'Boca T';
    case PartType.benddegree45:
      return 'Curva 45°';
    case PartType.conical:
      return 'Cone';
    case PartType.flange:
      return 'Caixa de Flange';
    case PartType.cap:
      return 'Tampa';
    case PartType.cover:
      return 'Capa';
    case PartType.dishedhead:
      return 'Cabeça Abalada';
    case PartType.reducingcoupling:
      return 'Redução';
    case PartType.valvebox:
      return 'Caixa de Válvula';
    case PartType.insulationfinish:
      return 'Acabamento de Isolamento';
    case PartType.angleiron:
      return 'Cantoneira';
    case PartType.pipeshoe:
      return 'Sapata';
    case PartType.backstay:
      return 'Backstay(Ressalto no Corpo)';
    case PartType.asianconicalheat:
      return 'Chapeu Chines';
    case PartType.squaretoround:
      return 'Quadrado para Redondo';
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
  final int multiplierFactor;
  @HiveField(3)
  final Map<VariableType, dynamic> variables;

  PartModel({
    this.type = PartType.none,
    this.amount = 1,
    this.multiplierFactor = 1,
    Map<VariableType, dynamic>? variables,
  }) : assert(amount > 0, 'Amount must be positive'),
       assert(multiplierFactor > 0, 'Multiplier factor must be positive'),
       variables = variables ?? {};

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'amount': amount,
        'multiplierFactor': multiplierFactor,
        'variables': variables.map((key, value) => MapEntry(key.name, value)),
      };

  factory PartModel.fromJson(Map<String, dynamic> json) {
    try {
      final vars = (json['variables'] as Map? ?? {}).map(
        (key, value) => MapEntry(
          VariableType.values.firstWhere((e) => e.name == key, orElse: () => VariableType.none),
          value,
        ),
      );
      return PartModel(
        type: PartType.values.firstWhere((e) => e.name == json['type'], orElse: () => PartType.none),
        amount: json['amount'] ?? 1,
        multiplierFactor: json['multiplierFactor'] ?? 1,
        variables: Map<VariableType, dynamic>.from(vars),
      );
    } catch (e) {
      throw FormatException('Invalid PartModel JSON: $e');
    }
  }

  PartModel copyWith({
    PartType? type,
    int? amount,
    int? multiplierFactor,
    Map<VariableType, dynamic>? variables,
  }) {
    return PartModel(
      type: type ?? this.type,
      amount: amount ?? this.amount,
      multiplierFactor: multiplierFactor ?? this.multiplierFactor,
      variables: variables ?? Map.from(this.variables),
    );
  }
}
