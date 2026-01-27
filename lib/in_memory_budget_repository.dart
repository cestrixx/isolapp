
import 'package:isolapp/budget_model.dart';
import 'package:isolapp/budget_repository.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class InMemoryBudgetRepository implements BudgetRepository {
  final Map<String, BudgetModel> _parts = {};

  @override
  Future<BudgetModel> create({DateTime? date, required String city, required String worksite}) async {
    // Adiciona a peça ao mapa, usando seu ID como chave.
    // Se uma peça com o mesmo ID já existir, ela será substituída.
    final id = uuid.v1();
    _parts[id] = BudgetModel(id: id, worksite: worksite, city: city, date: date);
    return _parts[id]!;
  }

  @override
  Future<BudgetModel?> findById(String id) async {
    // Retorna a peça associada ao ID, ou null se não for encontrada.
    return _parts[id];
  }

  @override
  Future<List<BudgetModel>> findAll() async {
    // Retorna uma lista de todas as peças armazenadas.
    return _parts.values.toList();
  }

  @override
  Future<BudgetModel?> update(String id, {DateTime? date, String? worksite, String? city}) async {
    if (_parts.containsKey(id)) {
      // Cria uma nova instância da peça com os dados atualizados,
      // garantindo que o ID original seja mantido.
      final BudgetModel partToStore = _parts[id]!.copyWith(date: date, worksite: worksite, city: city);
      _parts[id] = partToStore;
      return partToStore;
    }
    return null; // Peça não encontrada para atualização.
  }

  @override
  Future<bool> delete(String id) async {
    // Tenta remover a peça pelo ID e retorna true se foi removida.
    return _parts.remove(id) != null;
  }
}