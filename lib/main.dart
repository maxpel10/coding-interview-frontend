import 'package:exchange_calculator/features/ui/exchange_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: ExchangeCalculatorApp(),
    ),
  );
}

class ExchangeCalculatorApp extends StatelessWidget {
  const ExchangeCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exchange calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: ExchangePage(),
    );
  }
}
