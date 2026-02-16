import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalTextInputFormatter({this.decimalRange = 2});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '');
    }
    
    double value = double.parse(digitsOnly) / (pow10(decimalRange));
    String newText = value.toStringAsFixed(decimalRange);//.replaceAll('.', ',');
    
    return TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: newText.length));
  }

  double pow10(int n) => List.filled(n, 0).fold(1.0, (p, _) => p * 10);
}