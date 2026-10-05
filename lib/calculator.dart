/// A simple, immediate-execution calculator (operations run left to right).
class Calculator {
  String display = '0';
  String? operation;
  double? _left;
  bool _startNew = true;
  bool hasError = false;

  void clear() {
    display = '0';
    operation = null;
    _left = null;
    _startNew = true;
    hasError = false;
  }

  void input(String key) {
    if (hasError) clear();
    if (_startNew) {
      display = key == '.' ? '0.' : key;
      _startNew = false;
      return;
    }
    if (key == '.') {
      if (!display.contains('.')) display += '.';
    } else if (display == '0') {
      display = key;
    } else if (display.replaceAll(RegExp(r'[^0-9]'), '').length < 15) {
      display += key;
    }
  }

  void backspace() {
    if (hasError) {
      clear();
      return;
    }
    if (_startNew) return;
    display = display.length > 1 ? display.substring(0, display.length - 1) : '0';
    if (display == '-') display = '0';
  }

  void toggleSign() {
    if (hasError || double.parse(display) == 0) return;
    display = display.startsWith('-') ? display.substring(1) : '-$display';
  }

  void percent() {
    if (hasError) return;
    _setResult(double.parse(display) / 100);
  }

  void chooseOperation(String value) {
    if (hasError) return;
    if (operation != null && !_startNew) equals();
    if (hasError) return;
    _left = double.parse(display);
    operation = value;
    _startNew = true;
  }

  void equals() {
    if (hasError || operation == null || _left == null || _startNew) return;
    final right = double.parse(display);
    final result = switch (operation) {
      '+' => _left! + right,
      '−' => _left! - right,
      '×' => _left! * right,
      '÷' => right == 0 ? double.nan : _left! / right,
      _ => right,
    };
    _setResult(result);
    operation = null;
    _left = null;
    _startNew = true;
  }

  void _setResult(double value) {
    if (!value.isFinite) {
      clear();
      hasError = true;
      return;
    }
    // Trim floating-point noise and unnecessary trailing decimal zeroes.
    display = double.parse(value.toStringAsPrecision(12)).toString();
    if (display.endsWith('.0')) {
      display = display.substring(0, display.length - 2);
    }
    if (display == '-0') display = '0';
  }
}
