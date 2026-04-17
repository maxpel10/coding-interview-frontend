import 'package:exchange_calculator/features/exchange_calculator/models/currency.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/currency_id.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/exchange_state.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/exchange_type.dart';
import 'package:exchange_calculator/features/exchange_calculator/notifiers/crypto_currency_list_notifier.dart';
import 'package:exchange_calculator/features/exchange_calculator/notifiers/fiat_currency_list_notifier.dart';
import 'package:exchange_calculator/features/exchange_calculator/repositories/exchange_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exchangeNotifier = NotifierProvider<ExchangeNotifier, ExchangeState>(
  ExchangeNotifier.new,
);

class ExchangeNotifier extends Notifier<ExchangeState> {


  @override
  ExchangeState build() {
    final from = ref.read(cryptoCurrencyListNotifier).currencies.first;
    final to = ref.read(fiatCurrencyListNotifier).currencies.first;
    return ExchangeState(fromCurrency: from, toCurrency: to);
  }

  void setFrom(Currency currency) {
    state = state.copyWith(fromCurrency: currency);
    calculate();
  }

  void setTo(Currency currency) {
    state = state.copyWith(toCurrency: currency);
    calculate();
  }

  void setAmount(num amount) {
    state = state.copyWith(amount: amount);
    calculate();
  }

  Future<void> calculate() async {
    final s = state;
    final from = s.fromCurrency;
    final to = s.toCurrency;

    if (from == null || to == null) {
      state = s.copyWith(
        rate: 0,
        result: 0,
        isRateLoading: false,
        rateError: null,
      );
      return;
    }

    final fromCrypto = from.id.isCrypto;
    final toCrypto = to.id.isCrypto;
    if (fromCrypto == toCrypto) {
      state = s.copyWith(
        rate: 0,
        result: 0,
        isRateLoading: false,
        rateError: null,
      );
      return;
    }

    if (s.amount <= 0) {
      state = s.copyWith(
        rate: 0,
        result: 0,
        isRateLoading: false,
        rateError: null,
      );
      return;
    }

    final ExchangeType type;
    final CurrencyId cryptoCurrencyId;
    final CurrencyId fiatCurrencyId;

    if (fromCrypto && !toCrypto) {
      type = ExchangeType.cryptoToFiat;
      cryptoCurrencyId = from.id;
      fiatCurrencyId = to.id;
    } else {
      type = ExchangeType.fiatToCrypto;
      cryptoCurrencyId = to.id;
      fiatCurrencyId = from.id;
    }

    final queryAmount = s.amount;

    state = s.copyWith(isRateLoading: true, rateError: null);

    final exchangeResult = await ref
        .read(exchangeRepositoryProvider)
        .getExchangeData(
          type: type,
          cryptoCurrencyId: cryptoCurrencyId,
          fiatCurrencyId: fiatCurrencyId,
          amount: queryAmount,
          amountCurrencyId: from.id,
        );



    exchangeResult.fold(
      (err) {
        if (state.amount <= 0) {
          state = state.copyWith(
            rate: 0,
            result: 0,
            isRateLoading: false,
            rateError: null,
          );
          return;
        }
        state = state.copyWith(
          rate: 0,
          result: 0,
          isRateLoading: false,
          rateError: err.message,
        );
      },
      (data) {
        if (state.amount <= 0) {
          state = state.copyWith(
            rate: 0,
            result: 0,
            isRateLoading: false,
            rateError: null,
          );
          return;
        }
        final rate = data.exchangeRate;
        final amount = state.amount;
        final from = state.fromCurrency!;
        final to = state.toCurrency!;
        final cryptoToFiat = from.id.isCrypto && !to.id.isCrypto;
        final num computed;
        if (rate == 0) {
          computed = 0;
        } else if (cryptoToFiat) {
          computed = amount * rate;
        } else {
          computed = amount / rate;
        }
        state = state.copyWith(
          rate: rate,
          result: computed,
          isRateLoading: false,
          rateError: null,
        );
      },
    );
  }

  void swapCurrencies() {
    final from = state.fromCurrency;
    final to = state.toCurrency;
    if (from == null || to == null) return;
    state = state.copyWith(fromCurrency: to, toCurrency: from);
    calculate();
  }
}
