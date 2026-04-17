import 'package:exchange_calculator/core/theme/theme.dart';
import 'package:flutter/material.dart';

class ExchangeDetailRow extends StatelessWidget {
  const ExchangeDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.muted = false,
    this.onInfoTap,
  });

  final String label;
  final String value;
  final bool muted;

  final VoidCallback? onInfoTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodyMedium?.copyWith(
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w500,
      fontSize: 13,
    );
    final valueStyle = theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 14,
      height: 1.2,
      letterSpacing: -0.15,
      color: muted ? AppColors.textMuted : AppColors.textPrimary,
    );
    final iconColor = muted ? AppColors.textMuted : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Text(label, style: labelStyle)),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: valueStyle,
                  ),
                ),
                if (onInfoTap != null) ...[
                  const SizedBox(width: AppSpacing.xs),
                  InkWell(
                    onTap: onInfoTap,
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: iconColor,  
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
