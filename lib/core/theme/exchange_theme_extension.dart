import 'package:flutter/material.dart';

import 'app_colors.dart';

@immutable
class ExchangeThemeExtension extends ThemeExtension<ExchangeThemeExtension> {
  const ExchangeThemeExtension({
    required this.background,
    required this.decorativeTeal,
    required this.decorativeGold,
    required this.inputUnitForeground,
    required this.radioStroke,
  });

  final Color background;
  final Color decorativeTeal;
  final Color decorativeGold;
  final Color inputUnitForeground;
  final Color radioStroke;

  static const ExchangeThemeExtension light = ExchangeThemeExtension(
    background: AppColors.background,
    decorativeTeal: AppColors.decorativeTeal,
    decorativeGold: AppColors.decorativeGold,
    inputUnitForeground: AppColors.inputUnit,
    radioStroke: AppColors.radioStroke,
  );

  @override
  ExchangeThemeExtension copyWith({
    Color? background,
    Color? decorativeTeal,
    Color? decorativeGold,
    Color? inputUnitForeground,
    Color? radioStroke,
  }) {
    return ExchangeThemeExtension(
      background: background ?? this.background,
      decorativeTeal: decorativeTeal ?? this.decorativeTeal,
      decorativeGold: decorativeGold ?? this.decorativeGold,
      inputUnitForeground:
          inputUnitForeground ?? this.inputUnitForeground,
      radioStroke: radioStroke ?? this.radioStroke,
    );
  }

  @override
  ExchangeThemeExtension lerp(
    ThemeExtension<ExchangeThemeExtension>? other,
    double t,
  ) {
    if (other is! ExchangeThemeExtension) return this;
    return ExchangeThemeExtension(
      background: Color.lerp(background, other.background, t)!,
      decorativeTeal: Color.lerp(decorativeTeal, other.decorativeTeal, t)!,
      decorativeGold: Color.lerp(decorativeGold, other.decorativeGold, t)!,
      inputUnitForeground: Color.lerp(
            inputUnitForeground,
            other.inputUnitForeground,
            t,
          )!,
      radioStroke: Color.lerp(radioStroke, other.radioStroke, t)!,
    );
  }
}

extension ExchangeThemeExtensionX on BuildContext {
  ExchangeThemeExtension get exchangeTheme =>
      Theme.of(this).extension<ExchangeThemeExtension>()!;
}
