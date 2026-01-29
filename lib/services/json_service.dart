
import 'dart:convert';
import 'dart:io';
import 'package:isolapp/models/budget_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class JsonService {
  Future<void> exportBudget(BudgetModel budget) async {
    try {
      final jsonString = jsonEncode(budget.toJson());
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/budget_${budget.id}.json');
      
      await file.writeAsString(jsonString);

      final result = await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Exportando Orçamento: ${budget.worksite}',
      );
      if (result.status != ShareResultStatus.success) {
          throw Exception('Erro ao exportar orçamento: ${result.toString()}');
      }
    } catch (e) {
      throw Exception('Erro ao exportar orçamento: $e');
    }
  }

  BudgetModel importFromJson(String jsonString) {
    try {
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      return BudgetModel.fromJson(jsonData);
    } catch (e) {
      throw Exception('Formato JSON inválido: $e');
    }
  }
}
