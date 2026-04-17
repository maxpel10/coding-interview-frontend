import 'package:exchange_calculator/features/exchange_calculator/models/currency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_state.freezed.dart';

@freezed
abstract class ExchangeState with _$ExchangeState {
  const factory ExchangeState({
    Currency? fromCurrency,
    Currency? toCurrency,
    @Default(0) num amount,
    @Default(0) num rate,
    @Default(0) num result,
    @Default(false) bool isRateLoading,
    String? rateError,
  }) = _ExchangeState;
}
