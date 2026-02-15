
import 'package:flutter/services.dart';

class IntegerTextInputFormatter extends FilteringTextInputFormatter {
  IntegerTextInputFormatter({int defaultValue = 0})
      : super.allow(RegExp(r'[0-9]'), replacementString: defaultValue.toString());
}