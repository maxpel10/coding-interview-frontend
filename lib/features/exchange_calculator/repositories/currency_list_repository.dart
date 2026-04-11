import 'package:exchange_calculator/core/assets/assets.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/currency.dart';

abstract class CurrencyListRepository {
  Future<List<Currency>> getFiatCurrencies();
  Future<List<Currency>> getCryptoCurrencies();
}

class LocalCurrencyListRepository implements CurrencyListRepository {
  @override
  Future<List<Currency>> getFiatCurrencies() async {
    return const [
      Currency(
        id: 'VES',
        symbol: 'Bs',
        name: 'Bolívares',
        assetPath: Assets.ves,
      ),
      Currency(
        id: 'PEN',
        symbol: 'S/',
        name: 'Soles Peruanos',
        assetPath: Assets.pen,
      ),
      Currency(
        id: 'BRL',
        symbol: 'R\$',
        name: 'Real Brasileño',
        assetPath: Assets.brl,
      ),
      Currency(
        id: 'COP',
        symbol: 'COL\$',
        name: 'Pesos Colombianos',
        assetPath: Assets.cop,
      ),
    ];
  }

  @override
  Future<List<Currency>> getCryptoCurrencies() async {
    return [
      Currency(
        id: 'USDT',
        symbol: 'USDT',
        name: 'Tether',
        assetPath: Assets.usdt,
      ),
    ];
  }
}
