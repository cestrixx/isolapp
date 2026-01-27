
import 'package:isolapp/budget_model.dart';

abstract class BudgetRepository {
  /// Cria uma nova peça no repositório.
  /// Retorna a peça criada, que pode ter um ID gerado pelo repositório.
  Future<BudgetModel> create({DateTime? date, required String worksite, required String city});

  /// Encontra uma peça pelo seu ID único.
  /// Retorna a peça se encontrada, ou `null` caso contrário.
  Future<BudgetModel?> findById(String id);

  /// Retorna uma lista de todas as peças no repositório.
  Future<List<BudgetModel>> findAll();

  /// Atualiza uma peça existente no repositório.
  /// `id` é o ID da peça a ser atualizada.
  /// `updatedPart` contém os novos dados da peça. O ID da `updatedPart` é ignorado
  /// em favor do `id` fornecido como parâmetro.
  /// Retorna a peça atualizada se encontrada e atualizada, ou `null` se a peça com o ID não existir.
  Future<BudgetModel?> update(String id, {DateTime? date, String? worksite, String? city});

  /// Deleta uma peça do repositório pelo seu ID.
  /// Retorna `true` se a peça foi deletada com sucesso, `false` caso contrário.
  Future<bool> delete(String id);
}