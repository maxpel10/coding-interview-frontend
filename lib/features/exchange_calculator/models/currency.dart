import 'package:exchange_calculator/features/exchange_calculator/models/currency_id.dart';

class Currency {
  const Currency({
    required this.id,
    required this.symbol,
    required this.name,
    required this.displayValue,
    required this.assetPath,
  });

  final CurrencyId id;
  final String symbol;
  final String name;
  final String displayValue;
  final String assetPath;

  String get sheetSubtitle => '$name ($symbol)';
}
