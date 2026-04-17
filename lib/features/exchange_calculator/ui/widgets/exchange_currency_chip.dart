import 'package:exchange_calculator/core/theme/theme.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/currency.dart';
import 'package:flutter/material.dart';

class ExchangeCurrencyChip extends StatelessWidget {
  const ExchangeCurrencyChip({
    super.key,
    required this.currency,
    required this.onTap,
  });

  final Currency? currency;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: AppSpacing.xs,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LeadingIcon(assetPath: currency?.assetPath),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                currency?.displayValue ?? '—',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: -0.15,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 17,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({this.assetPath});

  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    const size = 22.0;
    if (assetPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          assetPath!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _placeholder(size),
        ),
      );
    }
    return _placeholder(size);
  }

  Widget _placeholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.decorativeTeal.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
