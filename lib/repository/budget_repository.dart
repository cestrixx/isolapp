import 'package:hive_flutter/hive_flutter.dart';
import 'package:isolapp/models/budget_model.dart';

class BudgetRepository {
  static const String boxName = 'budgets2';

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<BudgetModel>(boxName);
    }
  }

  Box<BudgetModel> get _box => Hive.box<BudgetModel>(boxName);

  List<BudgetModel> getAllBudgets() {
    return _box.values.toList();
  }

  Future<void> saveBudget(BudgetModel budget) async {
    await _box.put(budget.id, budget);
  }

  Future<void> deleteBudget(String id) async {
    await _box.delete(id);
  }

  BudgetModel? getBudgetById(String id) {
    return _box.get(id);
  }
}
