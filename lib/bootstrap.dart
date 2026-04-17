import 'package:exchange_calculator/features/exchange_calculator/notifiers/crypto_currency_list_notifier.dart';
import 'package:exchange_calculator/features/exchange_calculator/notifiers/fiat_currency_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> initializeAppState(Ref ref) async {
  await Future.wait([
    ref.read(fiatCurrencyListNotifier.notifier).getCurrencies(),
    ref.read(cryptoCurrencyListNotifier.notifier).getCurrencies(),
  ]);
}

final appBootstrapProvider = FutureProvider<void>((ref) async {
  await initializeAppState(ref);
});
