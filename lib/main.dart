import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'calculator.dart';
import 'l10n/app_localizations.dart';
import 'suitcase_shell.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => AppLocalizations.of(context)!.title,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD95298)),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFD95298),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const Home(),
      );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _calculator = Calculator();
  static const _rows = [
    ['C', '⌫', '%', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '−'],
    ['1', '2', '3', '+'],
    ['±', '0', '.', '='],
  ];

  void _press(String key) {
    setState(() {
      switch (key) {
        case 'C':
          _calculator.clear();
        case '⌫':
          _calculator.backspace();
        case '%':
          _calculator.percent();
        case '±':
          _calculator.toggleSign();
        case '=':
          _calculator.equals();
        case '+':
        case '−':
        case '×':
        case '÷':
          _calculator.chooseOperation(key);
        default:
          _calculator.input(key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark ? const Color(0xFF231D2A) : const Color(0xFFFFEFF7),
      appBar: AppBar(
        title: Text(strings.title, style: const TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
              child: SuitcaseShell(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4FA),
                        border: Border.all(color: suitcaseInk, width: 2),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [BoxShadow(color: Color(0x33792A55), offset: Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _calculator.operation ?? strings.result,
                            style: const TextStyle(color: Color(0xFF81536D)),
                          ),
                          const SizedBox(height: 6),
                          Semantics(
                            liveRegion: true,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                _calculator.hasError ? strings.calculationError : _calculator.display,
                                key: const ValueKey('display'),
                                textDirection: _calculator.hasError ? Directionality.of(context) : TextDirection.ltr,
                                style: TextStyle(
                                  fontSize: 44,
                                  fontWeight: FontWeight.w600,
                                  color: _calculator.hasError ? const Color(0xFFB42337) : suitcaseInk,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Column(
                        children: _rows.map((row) => Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: Row(
                            children: row.map((key) {
                              final isOperator = ['÷', '×', '−', '+'].contains(key);
                              final selected = _calculator.operation == key;
                              final accent = key == '=' || selected;
                              final label = switch (key) {
                                'C' => strings.clear,
                                '⌫' => strings.backspace,
                                '±' => strings.toggleSign,
                                _ => key,
                              };
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 3),
                                  child: Semantics(
                                    label: label,
                                    excludeSemantics: true,
                                    button: true,
                                    selected: selected,
                                    onTap: () => _press(key),
                                    child: FilledButton(
                                      key: ValueKey('key_$key'),
                                      onPressed: () => _press(key),
                                      style: FilledButton.styleFrom(
                                        minimumSize: const Size(0, 56),
                                        padding: EdgeInsets.zero,
                                        elevation: 3,
                                        shadowColor: const Color(0xFF792A55),
                                        backgroundColor: accent
                                            ? suitcaseInk
                                            : isOperator
                                                ? const Color(0xFFB6E8FA)
                                                : const Color(0xFFFFE4F2),
                                        foregroundColor: accent ? Colors.white : suitcaseInk,
                                        side: BorderSide(color: suitcaseInk.withAlpha(80)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
                                        textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                                      ),
                                      child: Text(key),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        )).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
