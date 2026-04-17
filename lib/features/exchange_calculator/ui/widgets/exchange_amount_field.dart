import 'package:exchange_calculator/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExchangeAmountField extends StatefulWidget {
  const ExchangeAmountField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.unitLabel,
    required this.unitColor,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String unitLabel;
  final Color unitColor;
  final ValueChanged<String> onChanged;

  @override
  State<ExchangeAmountField> createState() => _ExchangeAmountFieldState();
}

class _ExchangeAmountFieldState extends State<ExchangeAmountField> {
  static const double _radius = AppSpacing.radiusMd;

  static const InputDecoration _noDecoration = InputDecoration(
    isDense: true,
    filled: false,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    contentPadding: EdgeInsets.zero,
    isCollapsed: true,
  );

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final focused = widget.focusNode.hasFocus;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(
          color: AppColors.primary,
          width: focused ? 1.5 : 1,
        ),
      ),
      child: GestureDetector(
        onTap: () => widget.focusNode.requestFocus(),
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md + 2,
            vertical: AppSpacing.sm + 2,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.unitLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: widget.unitColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  height: 1,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  cursorColor: AppColors.primary,
                  cursorWidth: 1.5,
                  decoration: _noDecoration.copyWith(
                    hintText: '0.00',
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: AppColors.textMuted.withValues(alpha: 0.45),
                    ),
                  ),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.2,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                  onChanged: widget.onChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
