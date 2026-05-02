import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../features/farmers/providers/farmer_account_provider.dart';
import '../../../features/farmers/providers/farmers_provider.dart';
import '../../../shared/utils/format.dart';
import '../providers/repayment_provider.dart';

class RecordRepaymentScreen extends ConsumerStatefulWidget {
  final int farmerId;

  const RecordRepaymentScreen({super.key, required this.farmerId});

  @override
  ConsumerState<RecordRepaymentScreen> createState() =>
      _RecordRepaymentScreenState();
}

class _RecordRepaymentScreenState extends ConsumerState<RecordRepaymentScreen> {
  final _rateController = TextEditingController();
  final _weightController = TextEditingController();
  final _rateFocusNode = FocusNode();
  final _weightFocusNode = FocusNode();

  double get _rate => double.tryParse(_rateController.text) ?? 0;
  double get _weight => double.tryParse(_weightController.text) ?? 0;
  double get _totalValue => _rate * _weight;

  @override
  void initState() {
    super.initState();
    _rateFocusNode.addListener(() => setState(() {}));
    _weightFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _rateController.dispose();
    _weightController.dispose();
    _rateFocusNode.dispose();
    _weightFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final farmerAsync = ref.watch(farmerDetailProvider(widget.farmerId));
    final submitState = ref.watch(recordRepaymentNotifierProvider);

    ref.listen(recordRepaymentNotifierProvider, (previous, next) {
      if (previous is AsyncLoading && next is AsyncData) {
        ref.invalidate(farmerDetailProvider(widget.farmerId));
        ref.invalidate(farmerDebtsProvider(widget.farmerId));
        ref.read(farmerListVersionProvider.notifier).refresh();
        if (context.mounted) context.pop();
      }
    });

    final isLoading = submitState.isLoading;
    final errorMessage = submitState.hasError
        ? (submitState.error is AppException
              ? (submitState.error as AppException).message
              : submitState.error.toString())
        : null;

    return farmerAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFFfaf6ef),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Scaffold(
        backgroundColor: const Color(0xFFfaf6ef),
        appBar: _buildAppBar('', ''),
        body: Center(
          child: Text(
            e.toString(),
            style: const TextStyle(color: Color(0xFFb3321b)),
          ),
        ),
      ),
      data: (farmer) {
        final outstanding = farmer.outstandingDebt.toDouble();
        final canSubmit = !isLoading && _totalValue > 0 && outstanding > 0;

        return Scaffold(
          backgroundColor: const Color(0xFFfaf6ef),
          appBar: _buildAppBar(
            'Record repayment',
            '${farmer.fullName} · ${farmer.identifier}',
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('COMMODITY RATE'),
                      const SizedBox(height: 8),
                      _RateCard(
                        controller: _rateController,
                        focusNode: _rateFocusNode,
                        focused: _rateFocusNode.hasFocus,
                        enabled: !isLoading,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 20),
                      _sectionLabel('TOTAL RECEIVED'),
                      const SizedBox(height: 8),
                      _WeightCard(
                        controller: _weightController,
                        focusNode: _weightFocusNode,
                        focused: _weightFocusNode.hasFocus,
                        enabled: !isLoading,
                        totalValue: _totalValue,
                        onChanged: (_) => setState(() {}),
                      ),
                      if (_totalValue > 0 && outstanding > 0) ...[
                        const SizedBox(height: 20),
                        _sectionLabel('DEBT IMPACT'),
                        const SizedBox(height: 8),
                        _DebtImpactCard(
                          outstanding: outstanding,
                          repaymentValue: _totalValue,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              _BottomBar(
                totalValue: _totalValue,
                errorMessage: errorMessage,
                isLoading: isLoading,
                canSubmit: canSubmit,
                onConfirm: () => ref
                    .read(recordRepaymentNotifierProvider.notifier)
                    .submit(
                      farmerId: widget.farmerId,
                      kgReceived: _weight,
                      commodityRate: _rate,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(String title, String subtitle) {
    return AppBar(
      backgroundColor: const Color(0xFFfaf6ef),
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF231a10), size: 22),
        onPressed: () => context.pop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF231a10),
            ),
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6b5d48)),
            ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Color(0xFFa89a82),
        letterSpacing: 0.5,
      ),
    );
  }
}

// ── Rate input card ───────────────────────────────────────────────────────────

class _RateCard extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool focused;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const _RateCard({
    required this.controller,
    required this.focusNode,
    required this.focused,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _InputCard(
      focused: focused,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'RATE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFa89a82),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: controller,
                  focusNode: focusNode,
                  enabled: enabled,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF231a10),
                    height: 1,
                  ),
                  decoration: const InputDecoration.collapsed(
                    hintText: '0',
                    hintStyle: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFcbbd9f),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'FCFA / kg',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6b5d48),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Weight input card ─────────────────────────────────────────────────────────

class _WeightCard extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool focused;
  final bool enabled;
  final double totalValue;
  final ValueChanged<String> onChanged;

  const _WeightCard({
    required this.controller,
    required this.focusNode,
    required this.focused,
    required this.enabled,
    required this.totalValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _InputCard(
      focused: focused,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WEIGHT',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFa89a82),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: controller,
                      focusNode: focusNode,
                      enabled: enabled,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      onChanged: onChanged,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF231a10),
                        height: 1,
                      ),
                      decoration: const InputDecoration.collapsed(
                        hintText: '0',
                        hintStyle: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFcbbd9f),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'kg',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6b5d48),
                ),
              ),
            ],
          ),
          if (totalValue > 0) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFe3d8c2)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL VALUE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFa89a82),
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  formatFcfa(totalValue),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2d5d3a),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Debt impact card ──────────────────────────────────────────────────────────

class _DebtImpactCard extends StatelessWidget {
  final double outstanding;
  final double repaymentValue;

  const _DebtImpactCard({
    required this.outstanding,
    required this.repaymentValue,
  });

  @override
  Widget build(BuildContext context) {
    final applied = repaymentValue.clamp(0.0, outstanding);
    final remaining = (outstanding - applied).clamp(0.0, double.infinity);
    final progress = (applied / outstanding).clamp(0.0, 1.0);
    final pct = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFe3d8c2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Outstanding',
                style: TextStyle(fontSize: 13, color: Color(0xFF6b5d48)),
              ),
              Text(
                formatFcfa(outstanding),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF231a10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: SizedBox(
              height: 6,
              child: Stack(
                children: [
                  Container(color: const Color(0xFFebe3d4)),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(color: const Color(0xFF2d5d3a)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '− ${formatFcfa(applied)} ($pct%)',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2d5d3a),
                ),
              ),
              Text(
                'Remaining ${formatFcfa(remaining)}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF6b5d48)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Shared card shell ─────────────────────────────────────────────────────────

class _InputCard extends StatelessWidget {
  final bool focused;
  final Widget child;

  const _InputCard({required this.focused, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: focused ? const Color(0xFF2d5d3a) : const Color(0xFFe3d8c2),
          width: focused ? 2 : 1,
        ),
      ),
      child: child,
    );
  }
}

// ── Bottom bar ────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final double totalValue;
  final String? errorMessage;
  final bool isLoading;
  final bool canSubmit;
  final VoidCallback onConfirm;

  const _BottomBar({
    required this.totalValue,
    required this.errorMessage,
    required this.isLoading,
    required this.canSubmit,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: const BoxDecoration(
        color: Color(0xFFfaf6ef),
        border: Border(top: BorderSide(color: Color(0xFFe3d8c2))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (errorMessage != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Color(0xFFb3321b), fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: canSubmit ? onConfirm : null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check, size: 18),
              label: Text(
                totalValue > 0
                    ? 'Confirm · ${formatFcfa(totalValue)}'
                    : 'Confirm',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
