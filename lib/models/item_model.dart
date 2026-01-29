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
  double celsiusDegree;
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
  final List<PartModel> parts;

  ItemModel({
    required this.id,
    required this.budgetId,
    required this.index,
    required this.sector,
    required this.description,
    required this.coating,
    this.pressure = 0.0,
    this.celsiusDegree = 0.0,
    this.diameter = 0.0,
    this.perimeter = 0.0,
    this.insulating = '',
    this.linearMeter = 0.0,
    this.squareMeter = 0.0,
    List<PartModel>? parts,
  }) : this.parts = parts ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'budgetId': budgetId,
        'index': index,
        'sector': sector,
        'description': description,
        'coating': coating,
        'pressure': pressure,
        'celsiusDegree': celsiusDegree,
        'diameter': diameter,
        'perimeter': perimeter,
        'insulating': insulating,
        'linearMeter': linearMeter,
        'squareMeter': squareMeter,
        'parts': parts.map((e) => e.toJson()).toList(),
      };

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        id: json['id'],
        budgetId: json['budgetId'],
        index: json['index'],
        sector: json['sector'],
        description: json['description'],
        coating: json['coating'],
        pressure: (json['pressure'] as num).toDouble(),
        celsiusDegree: (json['celsiusDegree'] as num).toDouble(),
        diameter: (json['diameter'] as num).toDouble(),
        perimeter: (json['perimeter'] as num).toDouble(),
        insulating: json['insulating'],
        linearMeter: (json['linearMeter'] as num).toDouble(),
        squareMeter: (json['squareMeter'] as num).toDouble(),
        parts: (json['parts'] as List).map((e) => PartModel.fromJson(e)).toList(),
      );
}