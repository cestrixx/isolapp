import 'package:hive_flutter/hive_flutter.dart';
import 'package:isolapp/models/part_model.dart';

part 'item_model.g.dart';

@HiveType(typeId: 3)
class ItemModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String budgetId;
  @HiveField(2)
  final int index;
  @HiveField(3)
  final String sector;
  @HiveField(4)
  final String description;
  @HiveField(5)
  final String coating;
  @HiveField(6)
  double pressure;
  @HiveField(7)
  double degreesCelsius;
  @HiveField(8)
  double diameter;
  @HiveField(9)
  double perimeter;
  @HiveField(10)
  String insulating;
  @HiveField(11)
  double linearMeter;
  @HiveField(12)
  double squareMeter;
  @HiveField(13)
  int multiplierFactor;
  @HiveField(14)
  final List<PartModel> parts;

  ItemModel({
    required this.id,
    required this.budgetId,
    required this.index,
    required this.sector,
    required this.description,
    required this.coating,
    this.pressure = 0.0,
    this.degreesCelsius = 0.0,
    this.diameter = 0.0,
    this.perimeter = 0.0,
    this.insulating = '',
    this.linearMeter = 0.0,
    this.squareMeter = 0.0,
    this.multiplierFactor = 1,
    List<PartModel>? parts,
  }) : parts = parts ?? [] {
    assert(pressure >= 0, 'Pressão não pode ser negativa');
    assert(diameter >= 0, 'Diâmetro não pode ser negativo');
    assert(multiplierFactor > 0, 'Fator multiplicador deve ser maior que 0');
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'budgetId': budgetId,
        'index': index,
        'sector': sector,
        'description': description,
        'coating': coating,
        'pressure': pressure,
        'degreesCelsius': degreesCelsius,
        'diameter': diameter,
        'perimeter': perimeter,
        'insulating': insulating,
        'linearMeter': linearMeter,
        'squareMeter': squareMeter,
        'multiplierFactor': multiplierFactor,
        'parts': parts.map((e) => e.toJson()).toList(),
      };

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    try {
      return ItemModel(
        id: json['id'],
        budgetId: json['budgetId'],
        index: json['index'],
        sector: json['sector'],
        description: json['description'],
        coating: json['coating'],
        pressure: (json['pressure'] as num).toDouble(),
        degreesCelsius: (json['degreesCelsius'] as num).toDouble(),
        diameter: (json['diameter'] as num).toDouble(),
        perimeter: (json['perimeter'] as num).toDouble(),
        insulating: json['insulating'],
        linearMeter: (json['linearMeter'] as num).toDouble(),
        squareMeter: (json['squareMeter'] as num).toDouble(),
        multiplierFactor: (json['multiplierFactor'] as num).toInt(),
        parts: (json['parts'] as List).map((e) => PartModel.fromJson(e)).toList(),
      );
    } catch (e) {
      throw FormatException('Erro ao desserializar ItemModel: $e');
    }
  }

  ItemModel copyWith({
    String? id,
    String? budgetId,
    int? index,
    String? sector,
    String? description,
    String? coating,
    double? pressure,
    double? degreesCelsius,
    double? diameter,
    double? perimeter,
    String? insulating,
    double? linearMeter,
    double? squareMeter,
    int? multiplierFactor,
    List<PartModel>? parts,
  }) {
    return ItemModel(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      index: index ?? this.index,
      sector: sector ?? this.sector,
      description: description ?? this.description,
      coating: coating ?? this.coating,
      pressure: pressure ?? this.pressure,
      degreesCelsius: degreesCelsius ?? this.degreesCelsius,
      diameter: diameter ?? this.diameter,
      perimeter: perimeter ?? this.perimeter,
      insulating: insulating ?? this.insulating,
      linearMeter: linearMeter ?? this.linearMeter,
      squareMeter: squareMeter ?? this.squareMeter,
      multiplierFactor: multiplierFactor ?? this.multiplierFactor,
      parts: parts ?? List.from(this.parts),
    );
  }
}