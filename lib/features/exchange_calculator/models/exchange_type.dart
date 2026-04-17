enum ExchangeType {
  cryptoToFiat,
  fiatToCrypto;

  int get value => switch (this) {
    ExchangeType.cryptoToFiat => 0,
    ExchangeType.fiatToCrypto => 1,
  };
}
