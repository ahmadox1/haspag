import 'package:flutter_test/flutter_test.dart';
import 'package:haspag/calculator.dart';

void main() {
  test('basic arithmetic', () {
    for (final entry in {'+': '10', '−': '6', '×': '16', '÷': '4'}.entries) {
      final calculator = Calculator();
      calculator.input('8');
      calculator.chooseOperation(entry.key);
      calculator.input('2');
      calculator.equals();
      expect(calculator.display, entry.value);
    }
  });

  test('decimals, deletion, sign and percentage', () {
    final calculator = Calculator();
    calculator.input('.');
    calculator.input('5');
    calculator.input('.');
    expect(calculator.display, '0.5');
    calculator.backspace();
    calculator.input('2');
    calculator.toggleSign();
    calculator.percent();
    expect(calculator.display, '-0.002');
    calculator.clear();
    expect(calculator.display, '0');
  });

  test('chained operations execute left to right', () {
    final calculator = Calculator();
    calculator.input('2');
    calculator.chooseOperation('+');
    calculator.input('3');
    calculator.chooseOperation('×');
    calculator.input('4');
    calculator.equals();
    expect(calculator.display, '20');
    calculator.input('7');
    expect(calculator.display, '7');
  });

  test('division by zero recovers on new input', () {
    final calculator = Calculator();
    calculator.input('9');
    calculator.chooseOperation('÷');
    calculator.input('0');
    calculator.equals();
    expect(calculator.hasError, isTrue);
    calculator.input('3');
    expect(calculator.hasError, isFalse);
    expect(calculator.display, '3');
  });
}
