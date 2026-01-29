import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:isolapp/models/budget_model.dart';
import 'package:isolapp/repository/budget_repository.dart';

class BudgetService extends StateNotifier<List<BudgetModel>> {
  final BudgetRepository _repository;

  BudgetService(this._repository) : super([]) {
    _loadBudgets();
  }

  Future<void> _loadBudgets() async {
    await _repository.init();
    state = _repository.getAllBudgets();
  }

  Future<void> addBudget(BudgetModel budget) async {
    await _repository.saveBudget(budget);
    state = [...state, budget];
  }

  Future<void> updateBudget(BudgetModel budget) async {
    await _repository.saveBudget(budget);
    state = [
      for (final b in state)
        if (b.id == budget.id) budget else b
    ];
  }

  Future<void> deleteBudget(String id) async {
    await _repository.deleteBudget(id);
    state = state.where((b) => b.id != id).toList();
  }
}

final budgetRepositoryService = Provider((ref) => BudgetRepository());

final budgetsService = StateNotifierProvider<BudgetService, List<BudgetModel>>((ref) {
  final repository = ref.watch(budgetRepositoryService);
  return BudgetService(repository);
});

// Provider para o orçamento selecionado (detalhes)
final selectedBudgetService = StateProvider<BudgetModel?>((ref) => null);
