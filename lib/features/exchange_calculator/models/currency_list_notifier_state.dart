import 'package:exchange_calculator/features/exchange_calculator/models/currency.dart';

class CurrencyListNotifierState {
  const CurrencyListNotifierState({
    this.currencies = const [],
    this.loadError,
  });

  final List<Currency> currencies;
  final String? loadError;
}
