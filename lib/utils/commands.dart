
class Command {
  static final commands = [
    sector,
    description,
    coating,
    pressure,
    degreesCelsius,
    diameter,
    perimeter,
    insulating,
    linearMeter,
    squareMeter,
    multiplierFactor,
  ];

  static const 
  sector = 'setor', 
  description = 'descrição', 
  coating = 'revestimento',
  pressure = 'pressão',
  degreesCelsius = 'temperatura',
  diameter = 'diâmetro',
  perimeter = 'perímetro',
  insulating = 'isolante',
  linearMeter = 'metro linear',
  squareMeter = 'metro quadrado',
  multiplierFactor = 'fator multiplicador';
}

class Utils {
  static String _executeCommand({required String text, required String command}) {
    final commandIndex = text.indexOf(command);
    final finalIndex = commandIndex + command.length;

    if (commandIndex == -1) {
      return '';
    } else {
      if (finalIndex >= text.length) {
        return '';
      }
      return text.substring(finalIndex).trim();
    }
  }

  static void scanVoicedText(String voicedText, void Function(String command, String value) onResult) {
    final text = voicedText.toLowerCase();
    if (text.contains(Command.sector)) {
      final result = _executeCommand(text: text, command: Command.sector);
      onResult(Command.sector, result);
    } else if (text.contains(Command.description)) {
      final result = _executeCommand(text: text, command: Command.description);
      onResult(Command.description, result);
    } else if (text.contains(Command.coating)) {
      final result = _executeCommand(text: text, command: Command.coating);
      onResult(Command.coating, result);
    } else if (text.contains(Command.insulating)) {
      final result = _executeCommand(text: text, command: Command.insulating);
      onResult(Command.insulating, result);
    } else if (text.contains(Command.pressure)) {
      final result = _executeCommand(text: text, command: Command.pressure);
      onResult(Command.pressure, result);
    } else if (text.contains(Command.degreesCelsius)) {
      final result = _executeCommand(text: text, command: Command.degreesCelsius);
      onResult(Command.degreesCelsius, result);
    } else if (text.contains(Command.diameter)) {
      final result = _executeCommand(text: text, command: Command.diameter);
      onResult(Command.diameter, result);
    } else if (text.contains(Command.perimeter)) {
      final result = _executeCommand(text: text, command: Command.perimeter);
      onResult(Command.perimeter, result);
    } else if (text.contains(Command.linearMeter)) {
      final result = _executeCommand(text: text, command: Command.linearMeter);
      onResult(Command.linearMeter, result);
    } else if (text.contains(Command.squareMeter)) {
      final result = _executeCommand(text: text, command: Command.squareMeter);
      onResult(Command.squareMeter, result);
    } else if (text.contains(Command.multiplierFactor)) {
      final result = _executeCommand(text: text, command: Command.multiplierFactor);
      onResult(Command.multiplierFactor, result);
    }
  }
}
