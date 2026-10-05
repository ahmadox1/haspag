import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'calculator.dart';
import 'l10n/app_localizations.dart';

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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
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
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(strings.title), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _calculator.operation ?? strings.result,
                            style: TextStyle(color: colors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 16),
                          Semantics(
                            liveRegion: true,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                _calculator.hasError
                                    ? strings.calculationError
                                    : _calculator.display,
                                key: const ValueKey('display'),
                                textDirection: _calculator.hasError
                                    ? Directionality.of(context)
                                    : TextDirection.ltr,
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w500,
                                  color: _calculator.hasError
                                      ? colors.error
                                      : colors.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Column(
                        children: _rows.map((row) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: row.map((key) {
                              final isOperator = ['÷', '×', '−', '+'].contains(key);
                              final selected = _calculator.operation == key;
                              final label = switch (key) {
                                'C' => strings.clear,
                                '⌫' => strings.backspace,
                                '±' => strings.toggleSign,
                                _ => key,
                              };
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Semantics(
                                    label: label,
                                    excludeSemantics: true,
                                    button: true,
                                    child: FilledButton(
                                      key: ValueKey('key_$key'),
                                      onPressed: () => _press(key),
                                      style: FilledButton.styleFrom(
                                        minimumSize: const Size(0, 64),
                                        padding: EdgeInsets.zero,
                                        backgroundColor: key == '=' || selected
                                            ? colors.primary
                                            : isOperator
                                                ? colors.secondaryContainer
                                                : colors.surfaceContainerHighest,
                                        foregroundColor: key == '=' || selected
                                            ? colors.onPrimary
                                            : isOperator
                                                ? colors.onSecondaryContainer
                                                : colors.onSurface,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                        textStyle: const TextStyle(fontSize: 26),
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
