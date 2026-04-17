import 'package:intl/intl.dart';

abstract final class UiAmountFormat {
  UiAmountFormat._();

  static String format(
    num value, {
    int fractionDigits = 2,
  }) {
    if (value.isNaN || value.isInfinite) {
      return '—';
    }
    final pattern = StringBuffer('#,##0');
    if (fractionDigits > 0) {
      pattern
        ..write('.')
        ..write('0' * fractionDigits);
    }
    return NumberFormat(pattern.toString(), 'en_US').format(value);
  }

  static num? tryParse(String raw) {
    final s = raw.replaceAll(',', '').replaceAll(' ', '').trim();
    if (s.isEmpty) {
      return null;
    }
    return num.tryParse(s);
  }
}
