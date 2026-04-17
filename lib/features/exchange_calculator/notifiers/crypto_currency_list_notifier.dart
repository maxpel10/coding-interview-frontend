import 'package:exchange_calculator/features/exchange_calculator/models/currency_list_notifier_state.dart';
import 'package:exchange_calculator/features/exchange_calculator/repositories/currency_list_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cryptoCurrencyListNotifier =
    NotifierProvider<CryptoCurrencyListNotifier, CurrencyListNotifierState>(
  CryptoCurrencyListNotifier.new,
);

class CryptoCurrencyListNotifier extends Notifier<CurrencyListNotifierState> {
  @override
  CurrencyListNotifierState build() => const CurrencyListNotifierState();

  Future<void> getCurrencies() async {
    final result =
        await ref.read(currencyListRepositoryProvider).getCryptoCurrencies();
    state = result.fold(
      (failure) => CurrencyListNotifierState(
        currencies: state.currencies,
        loadError: failure.message,
      ),
      (list) => CurrencyListNotifierState(currencies: list, loadError: null),
    );
  }
}
