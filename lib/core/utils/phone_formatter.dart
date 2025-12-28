import 'package:flutter/services.dart';

class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 11) {
      return oldValue;
    }

    final newText = StringBuffer();
    for (int i = 0; i < newValue.text.length; i++) {
      if (i == 3 || i == 7) {
        newText.write(' ');
      }
      newText.write(newValue.text[i]);
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
