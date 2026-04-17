import 'dart:io' show SocketException;

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/currency_id.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/exchange_data.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/exchange_type.dart';
import 'package:exchange_calculator/features/exchange_calculator/services/recommendations_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exchangeRepositoryProvider = Provider<ExchangeRepository>((ref) {
  return RemoteExchangeRepository(ref.read(recommendationsServiceProvider));
});

abstract class ExchangeRepository {
  Future<Either<ExchangeRepositoryException, ExchangeData>> getExchangeData({
    required ExchangeType type,
    required CurrencyId cryptoCurrencyId,
    required CurrencyId fiatCurrencyId,
    required num amount,
    required CurrencyId amountCurrencyId,
  });
}

class ExchangeRepositoryException implements Exception {
  const ExchangeRepositoryException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() =>
      cause != null ? 'ExchangeRepositoryException: $message ($cause)' : message;
}

class RemoteExchangeRepository implements ExchangeRepository {
  final RecommendationsService _recommendationsService;

  RemoteExchangeRepository(this._recommendationsService);

  @override
  Future<Either<ExchangeRepositoryException, ExchangeData>> getExchangeData({
    required ExchangeType type,
    required CurrencyId cryptoCurrencyId,
    required CurrencyId fiatCurrencyId,
    required num amount,
    required CurrencyId amountCurrencyId,
  }) async {
    try {
      final recommendations = await _recommendationsService.getRecommendations(
        type: type.value,
        cryptoCurrencyId: cryptoCurrencyId.value,
        fiatCurrencyId: fiatCurrencyId.value,
        amount: amount,
        amountCurrencyId: amountCurrencyId.value,
      );

      final rateString = recommendations.data.byPrice.fiatToCryptoExchangeRate;
      final num exchangeRate;
      try {
        exchangeRate = num.parse(rateString);
      } on FormatException catch (e) {
        return Left(
          ExchangeRepositoryException(
            'Invalid exchange rate in server response',
            e,
          ),
        );
      }

      return Right(ExchangeData(exchangeRate: exchangeRate));
    } on DioException catch (e) {
      return Left(ExchangeRepositoryException(_dioFailureMessage(e), e));
    } catch (e) {
      return Left(
        ExchangeRepositoryException(
          'Unexpected error while fetching exchange data',
          e,
        ),
      );
    }
  }
}

String? _messageFromResponse(Response<dynamic>? response) {
  final data = response?.data;
  if (data is Map) {
    final dynamic m = data['message'] ?? data['error'];
    if (m is String && m.isNotEmpty) return m;
  }
  return null;
}

String _dioFailureMessage(DioException e) {
  final fromBody = _messageFromResponse(e.response);
  if (fromBody != null) return fromBody;

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'The request timed out. Check your connection and try again.';
    case DioExceptionType.badResponse:
      final code = e.response?.statusCode;
      return code != null
          ? 'The server returned an error (HTTP $code).'
          : 'The server returned an invalid response.';
    case DioExceptionType.cancel:
      return 'The request was cancelled.';
    case DioExceptionType.connectionError:
      return 'Could not reach the server. Check your internet connection.';
    case DioExceptionType.badCertificate:
      return 'Could not verify the server certificate.';
    case DioExceptionType.unknown:
      final err = e.error;
      if (err is SocketException) {
        return 'Network error: ${err.message.isEmpty ? 'unreachable host' : err.message}';
      }
      return e.message?.isNotEmpty == true
          ? e.message!
          : 'An unexpected network error occurred.';
  }
}
