import 'package:exchange_calculator/core/formatting/ui_amount_format.dart';
import 'package:exchange_calculator/core/theme/theme.dart';
import 'package:exchange_calculator/core/widgets/currency_bottom_sheet.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/currency.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/currency_id.dart';
import 'package:exchange_calculator/features/exchange_calculator/models/currency_list_notifier_state.dart';
import 'package:exchange_calculator/features/exchange_calculator/notifiers/crypto_currency_list_notifier.dart';
import 'package:exchange_calculator/features/exchange_calculator/notifiers/exchange_notifier.dart';
import 'package:exchange_calculator/features/exchange_calculator/notifiers/fiat_currency_list_notifier.dart';
import 'package:exchange_calculator/features/exchange_calculator/ui/widgets/exchange_amount_field.dart';
import 'package:exchange_calculator/features/exchange_calculator/ui/widgets/exchange_currency_header.dart';
import 'package:exchange_calculator/features/exchange_calculator/ui/widgets/exchange_detail_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExchangePage extends ConsumerStatefulWidget {
  const ExchangePage({super.key});

  @override
  ConsumerState<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends ConsumerState<ExchangePage> {
  late final TextEditingController _amountController;
  final _amountFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    final initial = ref.read(exchangeNotifier).amount;
    _amountController = TextEditingController(
      text: UiAmountFormat.format(initial),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(exchangeNotifier.notifier).calculate();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(exchangeNotifier);
    final fiatListState = ref.watch(fiatCurrencyListNotifier);
    final cryptoListState = ref.watch(cryptoCurrencyListNotifier);

    final from = state.fromCurrency;
    final to = state.toCurrency;
    final toLabel = to?.displayValue ?? '';
    final currencyListErrorLine = _currencyListErrorLine(
      fiatListState,
      cryptoListState,
    );
    final showExchangeDetails = state.amount > 0;

    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -80,
            top: 120,
            child: IgnorePointer(
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.38),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.lg,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.black.withValues(alpha: 0.07),
                    surfaceTintColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (state.isRateLoading && showExchangeDetails)
                          const LinearProgressIndicator(
                            minHeight: 3,
                            backgroundColor: Color(0xFFFFE8B8),
                            color: AppColors.primary,
                          ),
                        if (currencyListErrorLine != null)
                          _InlineErrorBanner(message: currencyListErrorLine),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.xl,
                            AppSpacing.xl,
                            AppSpacing.xl,
                            AppSpacing.lg,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ExchangeCurrencyHeader(
                                from: from,
                                to: to,
                                onSwap: () => ref
                                    .read(exchangeNotifier.notifier)
                                    .swapCurrencies(),
                                onPickFrom: () => _pickCurrencyForSide(
                                  context,
                                  current: from,
                                  cryptoListState: cryptoListState,
                                  fiatListState: fiatListState,
                                  ifUnknownAssumeCrypto: true,
                                  onSelected: (c) => ref
                                      .read(exchangeNotifier.notifier)
                                      .setFrom(c),
                                ),
                                onPickTo: () => _pickCurrencyForSide(
                                  context,
                                  current: to,
                                  cryptoListState: cryptoListState,
                                  fiatListState: fiatListState,
                                  ifUnknownAssumeCrypto: false,
                                  onSelected: (c) => ref
                                      .read(exchangeNotifier.notifier)
                                      .setTo(c),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              ExchangeAmountField(
                                controller: _amountController,
                                focusNode: _amountFocus,
                                unitLabel:
                                    from?.displayValue ?? from?.symbol ?? '—',
                                unitColor:
                                    context.exchangeTheme.inputUnitForeground,
                                onChanged: (raw) {
                                  final v = UiAmountFormat.tryParse(raw);
                                  ref
                                      .read(exchangeNotifier.notifier)
                                      .setAmount(v ?? 0);
                                },
                              ),
                              if (showExchangeDetails) ...[
                                const SizedBox(height: AppSpacing.xl + 4),
                                ExchangeDetailRow(
                                  label: 'Tasa estimada',
                                  value: state.isRateLoading
                                      ? 'Cargando…'
                                      : state.rateError != null
                                      ? 'No disponible'
                                      : '≈ ${UiAmountFormat.format(state.rate)} $toLabel',
                                  muted:
                                      state.isRateLoading ||
                                      state.rateError != null,
                                  onInfoTap: state.rateError != null
                                      ? () =>
                                            _showRateUnavailableDialog(context)
                                      : null,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                ExchangeDetailRow(
                                  label: 'Recibirás',
                                  value: state.isRateLoading
                                      ? 'Cargando…'
                                      : state.rateError != null
                                      ? 'No disponible'
                                      : '≈ ${UiAmountFormat.format(state.result)} $toLabel',
                                  muted:
                                      state.isRateLoading ||
                                      state.rateError != null,
                                  onInfoTap: state.rateError != null
                                      ? () =>
                                            _showRateUnavailableDialog(context)
                                      : null,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                const ExchangeDetailRow(
                                  label: 'Tiempo estimado',
                                  value: '≈ 10 Min',
                                ),
                                const SizedBox(height: AppSpacing.xl + 8),
                              ] else
                                const SizedBox(height: AppSpacing.lg),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed:
                                      showExchangeDetails &&
                                          !state.isRateLoading &&
                                          state.rateError == null
                                      ? () {}
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 4,
                                    shadowColor: AppColors.primary.withValues(
                                      alpha: 0.4,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    'Cambiar',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRateUnavailableDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.32),
      builder: (ctx) {
        return Dialog(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 10,
          shadowColor: Colors.black.withValues(alpha: 0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sin cotización',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        height: 1.25,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'No se encontró una orden de compra o venta de '
                      'referencia para ejecutar esta operación. '
                      'Puedes intentar con un monto distinto.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.45,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),
                Align(
                  alignment: Alignment.center,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.primaryOn,
                      elevation: 2,
                      shadowColor: AppColors.primary.withValues(alpha: 0.35),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.sm,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSm,
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(
                      'Entendido',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryOn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _currencyListErrorLine(
    CurrencyListNotifierState fiat,
    CurrencyListNotifierState crypto,
  ) {
    final parts = <String>[];
    if (fiat.loadError != null) {
      parts.add('Fiat: ${fiat.loadError}');
    }
    if (crypto.loadError != null) {
      parts.add('Cripto: ${crypto.loadError}');
    }
    if (parts.isEmpty) return null;
    return parts.join(' · ');
  }


  Future<void> _pickCurrencyForSide(
    BuildContext context, {
    required Currency? current,
    required CurrencyListNotifierState cryptoListState,
    required CurrencyListNotifierState fiatListState,
    required bool ifUnknownAssumeCrypto,
    required void Function(Currency) onSelected,
  }) async {
    final useCrypto = current?.id.isCrypto ?? ifUnknownAssumeCrypto;
    final listState = useCrypto ? cryptoListState : fiatListState;
    final title = useCrypto ? 'CRYPTO' : 'FIAT';

    final options = listState.currencies;
    if (options.isEmpty) {
      if (context.mounted && listState.loadError != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(listState.loadError!)));
      }
      return;
    }
    final id = await showCurrencyBottomSheet<CurrencyId>(
      context: context,
      title: title,
      options: options,
      selected: current?.id ?? options.first.id,
      optionKey: (c) => c.id,
    );
    if (!context.mounted || id == null) return;
    final c = options.firstWhere((e) => e.id == id);
    onSelected(c);
  }
}

class _InlineErrorBanner extends StatelessWidget {
  const _InlineErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.errorContainer.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 18,
                color: scheme.onErrorContainer,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onErrorContainer,
                    height: 1.35,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
