import 'package:hive/hive.dart';
import 'package:isolapp/models/item_model.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 2)
class BudgetModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final String worksite;
  @HiveField(3)
  final String city;
  @HiveField(4)
  final List<ItemModel> items;

  BudgetModel({
    required this.id,
    required this.date,
    required this.worksite,
    required this.city,
    List<ItemModel>? items,
  }) : this.items = items ?? [];

  BudgetModel copyWith({
    String? id,
    DateTime? date,
    String? worksite,
    String? city,
    List<ItemModel>? items,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      date: date ?? this.date,
      worksite: worksite ?? this.worksite,
      city: city ?? this.city,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'worksite': worksite,
        'city': city,
        'items': items.map((e) => e.toJson()).toList(),
      };

  factory BudgetModel.fromJson(Map<String, dynamic> json) => BudgetModel(
        id: json['id'],
        date: DateTime.parse(json['date']),
        worksite: json['worksite'],
        city: json['city'],
        items: (json['items'] as List).map((e) => ItemModel.fromJson(e)).toList(),
      );
}