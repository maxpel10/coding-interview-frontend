import 'package:dio/dio.dart';
import 'package:exchange_calculator/core/notifiers/dio_notifier.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/recommendations_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'recommendations_service.g.dart';

final recommendationsServiceProvider = Provider(
  (ref) => RecommendationsService(ref.watch(dioNotifier)),
);

@RestApi()
abstract class RecommendationsService {
  factory RecommendationsService(Dio dio, {String baseUrl}) = _RecommendationsService;

  @GET('/orderbook/public/recommendations')
  Future<RecommendationsResponse> getRecommendations({
    @Query('type') required int type,
    @Query('cryptoCurrencyId') required String cryptoCurrencyId,
    @Query('fiatCurrencyId') required String fiatCurrencyId,
    @Query('amount') required num amount,
    @Query('amountCurrencyId') required String amountCurrencyId,
  });
}
