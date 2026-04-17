enum CurrencyId {
  ves,
  cop,
  pen,
  brl,
  usdt,
}

extension CurrencyIdExtension on CurrencyId {
  String get value => switch (this) {
    CurrencyId.ves => 'VES',
    CurrencyId.cop => 'COP',
    CurrencyId.pen => 'PEN',
    CurrencyId.brl => 'BRL',
    CurrencyId.usdt => 'TATUM-TRON-USDT',
  };

  bool get isCrypto => switch (this) {
    CurrencyId.usdt => true,
    _ => false,
  };
}