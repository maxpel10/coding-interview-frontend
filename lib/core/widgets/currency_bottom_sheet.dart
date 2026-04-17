import 'package:exchange_calculator/features/exchange_calculator/models/currency.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

Future<T?> showCurrencyBottomSheet<T>({
  required BuildContext context,
  required String title,
  required List<Currency> options,
  required T selected,
  required T Function(Currency option) optionKey,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _CurrencySheetBody<T>(
        title: title,
        options: options,
        selected: selected,
        optionKey: optionKey,
      );
    },
  );
}

class _CurrencySheetBody<T> extends StatefulWidget {
  const _CurrencySheetBody({
    required this.title,
    required this.options,
    required this.selected,
    required this.optionKey,
  });

  final String title;
  final List<Currency> options;
  final T selected;
  final T Function(Currency option) optionKey;

  @override
  State<_CurrencySheetBody<T>> createState() => _CurrencySheetBodyState<T>();
}

class _CurrencySheetBodyState<T> extends State<_CurrencySheetBody<T>> {
  late T _current;

  @override
  void initState() {
    super.initState();
    _current = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = context.exchangeTheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusSheet),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderSubtle,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.lg,
                  bottom: AppSpacing.md,
                ),
                child: Text(
                  widget.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.xs,
                    AppSpacing.xl,
                    AppSpacing.xxl,
                  ),
                  itemCount: widget.options.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  itemBuilder: (context, index) {
                    final option = widget.options[index];
                    final key = widget.optionKey(option);
                    final selected = _current == key;
                    return InkWell(
                      onTap: () {
                        setState(() => _current = key);
                        Navigator.of(context).pop<T>(key);
                      },
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xs,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _FlagIcon(assetPath: option.assetPath),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option.displayValue,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: AppColors.textPrimary,
                                      letterSpacing: -0.15,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    option.sheetSubtitle,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.textMuted,
                                      fontSize: 11.5,
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            _RadioRing(
                              selected: selected,
                              stroke: ext.radioStroke,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FlagIcon extends StatelessWidget {
  const _FlagIcon({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    const width = 40.0;
    const height = 28.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) =>
            _flagPlaceholder(width: width, height: height),
      ),
    );
  }
}

Widget _flagPlaceholder({required double width, required double height}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.decorativeTeal.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(6),
    ),
  );
}

class _RadioRing extends StatelessWidget {
  const _RadioRing({required this.selected, required this.stroke});

  final bool selected;
  final Color stroke;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primary : stroke,
          width: selected ? 2 : 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}
