import 'package:exchange_calculator/core/theme/theme.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/currency.dart';
import 'package:exchange_calculator/features/exchange_calculator/ui/widgets/exchange_currency_chip.dart';
import 'package:flutter/material.dart';

class ExchangeCurrencyHeader extends StatelessWidget {
  const ExchangeCurrencyHeader({
    super.key,
    required this.from,
    required this.to,
    required this.onSwap,
    required this.onPickFrom,
    required this.onPickTo,
  });

  final Currency? from;
  final Currency? to;
  final VoidCallback onSwap;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;

  static const double _swapSize = 54;
  static const double _borderTopInset = 8;
  static const double _borderStrokeWidth = 1.5;
  static const double _legendRowHeight = 22;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.cardColor;
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      letterSpacing: 0.75,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
      fontSize: 9.5,
      height: 1,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: _borderTopInset),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSheet),
                  border: Border.all(
                    color: AppColors.primary,
                    width: _borderStrokeWidth,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ExchangeCurrencyChip(
                          currency: from,
                          onTap: onPickFrom,
                        ),
                      ),
                    ),
                    SizedBox(width: _swapSize),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ExchangeCurrencyChip(
                          currency: to,
                          onTap: onPickTo,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: AppColors.primary,
                elevation: 6,
                shadowColor: Colors.black.withValues(alpha: 0.22),
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onSwap,
                  customBorder: const CircleBorder(),
                  child: SizedBox(
                    width: _swapSize,
                    height: _swapSize,
                    child: const Icon(
                      Icons.swap_horiz_rounded,
                      color: AppColors.primaryOn,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: _borderTopInset +
              _borderStrokeWidth / 2 -
              _legendRowHeight / 2 + 0.5,
          height: _legendRowHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: _BorderCaption(
                    surface: surface,
                    text: 'TENGO',
                    style: labelStyle,
                  ),
                ),
              ),
              const SizedBox(width: _swapSize),
              Expanded(
                child: Center(
                  child: _BorderCaption(
                    surface: surface,
                    text: 'QUIERO',
                    style: labelStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BorderCaption extends StatelessWidget {
  const _BorderCaption({
    required this.surface,
    required this.text,
    required this.style,
  });

  final Color surface;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 4,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );
  }
}
