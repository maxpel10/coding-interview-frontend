import 'package:exchange_calculator/bootstrap.dart';
import 'package:exchange_calculator/features/exchange_calculator/ui/exchange_page.dart';
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

class ExchangeCalculatorApp extends ConsumerWidget {
  const ExchangeCalculatorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(appBootstrapProvider);

    return MaterialApp(
      title: 'Exchange calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: bootstrap.when(
        data: (_) => const ExchangePage(),
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stackTrace) => Scaffold(
          body: Center(
            child: Text('$error'),
          ),
        ),
      ),
    );
  }
}
