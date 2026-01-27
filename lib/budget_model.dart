
class BudgetModel {
  final String id;
  final DateTime date;
  final String worksite;
  final String city;

  BudgetModel({
    required this.id,
    DateTime? date,
    required this.worksite,
    required this.city,
  }) : date = date ?? DateTime.now();

  BudgetModel copyWith({
    String? id,
    DateTime? date,
    String? worksite,
    String? city,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      date: date ?? this.date,
      worksite: worksite ?? this.worksite,
      city: city ?? this.city,
    );
  }
}