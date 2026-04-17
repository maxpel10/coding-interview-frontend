import 'package:either_dart/either.dart';
import 'package:exchange_calculator/core/assets/assets.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/currency.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/currency_id.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currencyListRepositoryProvider = Provider<CurrencyListRepository>((ref) {
  return LocalCurrencyListRepository();
});

class CurrencyListFailure {
  const CurrencyListFailure(this.message);

  final String message;
}

abstract class CurrencyListRepository {
  Future<Either<CurrencyListFailure, List<Currency>>> getFiatCurrencies();
  Future<Either<CurrencyListFailure, List<Currency>>> getCryptoCurrencies();
}

class LocalCurrencyListRepository implements CurrencyListRepository {
  @override
  Future<Either<CurrencyListFailure, List<Currency>>> getFiatCurrencies() async {
    return const Right([
      Currency(
        id: CurrencyId.ves,
        displayValue: 'VES',
        symbol: 'Bs',
        name: 'Bolívares',
        assetPath: Assets.ves,
      ),
      Currency(
        id: CurrencyId.cop,
        displayValue: 'COP',
        symbol: 'COL\$',
        name: 'Pesos Colombianos',
        assetPath: Assets.cop,
      ),
      Currency(
        id: CurrencyId.pen,
        displayValue: 'PEN',
        symbol: 'S/',
        name: 'Soles Peruanos',
        assetPath: Assets.pen,
      ),
      Currency(
        id: CurrencyId.brl,
        displayValue: 'BRL',
        symbol: 'R\$',
        name: 'Real Brasileño',
        assetPath: Assets.brl,
      )
    ]);
  }

  @override
  Future<Either<CurrencyListFailure, List<Currency>>> getCryptoCurrencies() async {
    return const Right([
      Currency(
        id: CurrencyId.usdt,
        symbol: 'USDT',
        name: 'Tether',
        displayValue: 'USDT',
        assetPath: Assets.usdt,
      ),
    ]);
  }
}
