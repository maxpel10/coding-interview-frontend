import 'package:json_annotation/json_annotation.dart';

part 'recommendations_response.g.dart';

@JsonSerializable()
class RecommendationsResponse {
  const RecommendationsResponse({required this.data});

  final RecommendationsData data;

  factory RecommendationsResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendationsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendationsResponseToJson(this);
}

@JsonSerializable()
class RecommendationsData {
  const RecommendationsData({required this.byPrice});

  final OfferRecommendation byPrice;

  factory RecommendationsData.fromJson(Map<String, dynamic> json) =>
      _$RecommendationsDataFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendationsDataToJson(this);
}

@JsonSerializable()
class OfferRecommendation {
  const OfferRecommendation({required this.fiatToCryptoExchangeRate});

  final String fiatToCryptoExchangeRate;

  factory OfferRecommendation.fromJson(Map<String, dynamic> json) =>
      _$OfferRecommendationFromJson(json);

  Map<String, dynamic> toJson() => _$OfferRecommendationToJson(this);
}
