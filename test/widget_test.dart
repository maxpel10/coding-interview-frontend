import 'package:either_dart/either.dart';
import 'package:exchange_calculator/core/theme/theme.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/currency.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/currency_id.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/currency_list_notifier_state.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/exchange_data.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/exchange_type.dart';
import 'package:exchange_calculator/features/exchange_calculator/notifiers/crypto_currency_list_notifier.dart';
import 'package:exchange_calculator/features/exchange_calculator/notifiers/fiat_currency_list_notifier.dart';
import 'package:exchange_calculator/features/exchange_calculator/repositories/exchange_repository.dart';
import 'package:exchange_calculator/features/exchange_calculator/ui/exchange_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Exchange page shows currency labels and primary action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fiatCurrencyListNotifier.overrideWith(_TestFiatCurrencyList.new),
          cryptoCurrencyListNotifier.overrideWith(_TestCryptoCurrencyList.new),
          exchangeRepositoryProvider.overrideWithValue(_FakeExchangeRepository()),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const ExchangePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('TENGO'), findsOneWidget);
    expect(find.text('QUIERO'), findsOneWidget);
    expect(find.text('Cambiar'), findsOneWidget);
  });
}

const _testFiat = Currency(
  id: CurrencyId.ves,
  symbol: 'Bs',
  name: 'Bolívar',
  displayValue: 'VES',
  assetPath: 'assets/fiat_currencies/VES.png',
);

const _testCrypto = Currency(
  id: CurrencyId.usdt,
  symbol: 'USDT',
  name: 'Tether',
  displayValue: 'USDT',
  assetPath: 'assets/cripto_currencies/TATUM-TRON-USDT.png',
);

class _TestFiatCurrencyList extends FiatCurrencyListNotifier {
  @override
  CurrencyListNotifierState build() =>
      const CurrencyListNotifierState(currencies: [_testFiat]);
}

class _TestCryptoCurrencyList extends CryptoCurrencyListNotifier {
  @override
  CurrencyListNotifierState build() =>
      const CurrencyListNotifierState(currencies: [_testCrypto]);
}

class _FakeExchangeRepository implements ExchangeRepository {
  @override
  Future<Either<ExchangeRepositoryException, ExchangeData>> getExchangeData({
    required ExchangeType type,
    required CurrencyId cryptoCurrencyId,
    required CurrencyId fiatCurrencyId,
    required num amount,
    required CurrencyId amountCurrencyId,
  }) async {
    return Right(const ExchangeData(exchangeRate: 36.5));
  }
}
