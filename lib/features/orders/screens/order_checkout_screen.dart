import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../features/farmers/data/farmer.dart';
import '../../../features/farmers/providers/farmer_account_provider.dart';
import '../../../features/farmers/providers/farmers_provider.dart';
import '../../../features/products/providers/cart_provider.dart';
import '../../../shared/utils/format.dart';
import '../providers/checkout_provider.dart';

class OrderCheckoutScreen extends ConsumerStatefulWidget {
  final int farmerId;
  const OrderCheckoutScreen({super.key, required this.farmerId});

  @override
  ConsumerState<OrderCheckoutScreen> createState() =>
      _OrderCheckoutScreenState();
}

class _OrderCheckoutScreenState extends ConsumerState<OrderCheckoutScreen> {
  String _paymentMethod = 'cash';
  int _interestRate = 10;
  late final int _orderRef;
  late final TextEditingController _customRateController;

  bool get _isCustomRate => _customRateController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _orderRef = Random().nextInt(9000) + 1000;
    _customRateController = TextEditingController();
  }

  @override
  void dispose() {
    _customRateController.dispose();
    super.dispose();
  }

  void _submit(Map<int, CartItem> cart) {
    final items = cart.values
        .map((e) => {'product_id': e.product.id, 'quantity': e.quantity})
        .toList();
    ref
        .read(checkoutNotifierProvider.notifier)
        .submit(
          farmerId: widget.farmerId,
          paymentMethod: _paymentMethod,
          items: items,
          interestRate: _paymentMethod == 'credit' ? _interestRate : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final farmerAsync = ref.watch(farmerDetailProvider(widget.farmerId));
    final cart = ref.watch(cartProvider);
    final submitState = ref.watch(checkoutNotifierProvider);

    ref.listen(checkoutNotifierProvider, (previous, next) {
      if (previous is AsyncLoading && next is AsyncData && next.value != null) {
        ref.read(cartProvider.notifier).clear();
        ref.invalidate(farmerDetailProvider(widget.farmerId));
        ref.invalidate(farmerDebtsProvider(widget.farmerId));
        ref.read(farmerListVersionProvider.notifier).refresh();
        if (context.mounted) {
          context.go('/farmers/${widget.farmerId}');
        }
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
      error: (e, _) => Scaffold(
        backgroundColor: const Color(0xFFfaf6ef),
        appBar: _buildAppBar(),
        body: Center(
          child: Text(
            e.toString(),
            style: const TextStyle(color: Color(0xFFb3321b)),
          ),
        ),
      ),
      data: (farmer) {
        final subtotal = cart.values.fold(0.0, (sum, e) => sum + e.subtotal);
        final interestAmount = _paymentMethod == 'credit'
            ? subtotal * _interestRate / 100
            : 0.0;
        final total = subtotal + interestAmount;
        final canSubmit = !isLoading && cart.isNotEmpty;

        return Scaffold(
          backgroundColor: const Color(0xFFfaf6ef),
          appBar: _buildAppBar(),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FarmerCard(farmer: farmer),
                      const SizedBox(height: 20),
                      _ItemsSection(
                        cart: cart,
                        isLoading: isLoading,
                        onAddProduct: () => context.pop(),
                      ),
                      const SizedBox(height: 20),
                      _TotalsSection(
                        subtotal: subtotal,
                        interestAmount: interestAmount,
                        total: total,
                        paymentMethod: _paymentMethod,
                        interestRate: _interestRate,
                      ),
                      const SizedBox(height: 20),
                      _sectionLabel('PAYMENT METHOD'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _PaymentCard(
                              method: 'cash',
                              label: 'Cash',
                              sublabel: 'Pay now',
                              icon: Icons.wallet_outlined,
                              selected: _paymentMethod == 'cash',
                              onTap: isLoading
                                  ? null
                                  : () =>
                                        setState(() => _paymentMethod = 'cash'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _PaymentCard(
                              method: 'credit',
                              label: 'Credit',
                              sublabel: 'On account',
                              icon: Icons.credit_card_outlined,
                              selected: _paymentMethod == 'credit',
                              onTap: isLoading
                                  ? null
                                  : () => setState(
                                      () => _paymentMethod = 'credit',
                                    ),
                            ),
                          ),
                        ],
                      ),
                      if (_paymentMethod == 'credit') ...[
                        const SizedBox(height: 12),
                        _InterestRateSelector(
                          selectedPreset: _isCustomRate ? null : _interestRate,
                          customController: _customRateController,
                          onSelectPreset: isLoading
                              ? null
                              : (rate) {
                                  _customRateController.clear();
                                  setState(() => _interestRate = rate);
                                },
                          onCustomChange: isLoading
                              ? null
                              : (val) {
                                  final n = int.tryParse(val);
                                  if (n != null && n > 0) {
                                    setState(() => _interestRate = n);
                                  }
                                },
                        ),
                        const SizedBox(height: 12),
                        _CreditImpactCard(
                          currentDebt: farmer.outstandingDebt.toDouble(),
                          creditedAmount: subtotal + interestAmount,
                        ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              _BottomBar(
                total: total,
                isLoading: isLoading,
                errorMessage: errorMessage,
                canSubmit: canSubmit,
                onConfirm: () => _submit(cart),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
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
          const Text(
            'Checkout',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF231a10),
            ),
          ),
          Text(
            'Order draft · ORD-$_orderRef',
            style: const TextStyle(fontSize: 12, color: Color(0xFF6b5d48)),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_horiz, color: Color(0xFF6b5d48)),
          onPressed: () {},
        ),
      ],
    );
  }
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

// ── Farmer card ───────────────────────────────────────────────────────────────

class _FarmerCard extends StatelessWidget {
  final Farmer farmer;

  const _FarmerCard({required this.farmer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFe3d8c2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFdde8d8),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              farmer.initials,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2d5d3a),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  farmer.fullName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF231a10),
                  ),
                ),
                Text(
                  farmer.identifier,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6b5d48),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Items section ─────────────────────────────────────────────────────────────

class _ItemsSection extends ConsumerWidget {
  final Map<int, CartItem> cart;
  final bool isLoading;
  final VoidCallback onAddProduct;

  const _ItemsSection({
    required this.cart,
    required this.isLoading,
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = cart.values.toList();
    final totalItems = cart.values.fold(0, (sum, e) => sum + e.quantity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _sectionLabel('ITEMS ($totalItems)'),
            const Spacer(),
            GestureDetector(
              onTap: onAddProduct,
              child: const Text(
                '+ Add product',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2d5d3a),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFe3d8c2)),
          ),
          constraints: const BoxConstraints(maxHeight: 300),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: ListView.separated(
              shrinkWrap: true,
              physics: items.length > 3
                  ? const ClampingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: Color(0xFFe3d8c2),
              ),
              itemBuilder: (_, i) => _ItemRow(
                item: items[i],
                enabled: !isLoading,
                onAdd: () =>
                    ref.read(cartProvider.notifier).add(items[i].product),
                onDecrement: () => ref
                    .read(cartProvider.notifier)
                    .decrement(items[i].product.id),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  final CartItem item;
  final bool enabled;
  final VoidCallback onAdd;
  final VoidCallback onDecrement;

  const _ItemRow({
    required this.item,
    required this.enabled,
    required this.onAdd,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF231a10),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${formatAmount(item.product.price)} ea.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6b5d48),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _Stepper(
            quantity: item.quantity,
            enabled: enabled,
            onAdd: onAdd,
            onDecrement: onDecrement,
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 90,
            child: Text(
              formatFcfa(item.subtotal),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF231a10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final int quantity;
  final bool enabled;
  final VoidCallback onAdd;
  final VoidCallback onDecrement;

  const _Stepper({
    required this.quantity,
    required this.enabled,
    required this.onAdd,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(icon: Icons.remove, onTap: enabled ? onDecrement : null),
        Container(
          width: 32,
          alignment: Alignment.center,
          child: Text(
            '$quantity',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF231a10),
            ),
          ),
        ),
        _StepButton(
          icon: Icons.add,
          onTap: enabled ? onAdd : null,
          filled: true,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool filled;

  const _StepButton({required this.icon, this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF2d5d3a) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: filled ? const Color(0xFF2d5d3a) : const Color(0xFFe3d8c2),
          ),
        ),
        child: Icon(
          icon,
          size: 14,
          color: filled ? Colors.white : const Color(0xFF231a10),
        ),
      ),
    );
  }
}

// ── Totals section ────────────────────────────────────────────────────────────

class _TotalsSection extends StatelessWidget {
  final double subtotal;
  final double interestAmount;
  final double total;
  final String paymentMethod;
  final int interestRate;

  const _TotalsSection({
    required this.subtotal,
    required this.interestAmount,
    required this.total,
    required this.paymentMethod,
    required this.interestRate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TotalsRow(label: 'Subtotal', value: formatAmount(subtotal)),
        if (paymentMethod == 'credit') ...[
          const SizedBox(height: 6),
          _TotalsRow(
            label: 'Interest · $interestRate% (credit)',
            value: '+ ${formatAmount(interestAmount)}',
            accent: true,
          ),
        ],
        const SizedBox(height: 10),
        const Divider(height: 1, color: Color(0xFFe3d8c2)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF231a10),
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: formatAmount(total),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF231a10),
                    ),
                  ),
                  const TextSpan(
                    text: ' FCFA',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6b5d48),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TotalsRow extends StatelessWidget {
  final String label;
  final String value;
  final bool accent;

  const _TotalsRow({
    required this.label,
    required this.value,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = accent ? const Color(0xFFc97a2b) : const Color(0xFF6b5d48);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: color)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ── Payment method cards ──────────────────────────────────────────────────────

class _PaymentCard extends StatelessWidget {
  final String method;
  final String label;
  final String sublabel;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const _PaymentCard({
    required this.method,
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFdde8d8) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF2d5d3a) : const Color(0xFFe3d8c2),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color: selected
                        ? const Color(0xFF2d5d3a)
                        : const Color(0xFF6b5d48),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? const Color(0xFF2d5d3a)
                          : const Color(0xFF231a10),
                    ),
                  ),
                  Text(
                    sublabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6b5d48),
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFF2d5d3a),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 13, color: Colors.white),
              )
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFcbbd9f),
                    width: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Interest rate selector ────────────────────────────────────────────────────

class _InterestRateSelector extends StatelessWidget {
  final int? selectedPreset;
  final TextEditingController customController;
  final ValueChanged<int>? onSelectPreset;
  final ValueChanged<String>? onCustomChange;

  const _InterestRateSelector({
    required this.selectedPreset,
    required this.customController,
    this.onSelectPreset,
    this.onCustomChange,
  });

  static const _presets = [5, 8, 10, 15, 20];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Interest rate',
          style: TextStyle(fontSize: 13, color: Color(0xFF6b5d48)),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ..._presets.map((rate) {
              final isSelected = rate == selectedPreset;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: onSelectPreset != null
                      ? () => onSelectPreset!(rate)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF2d5d3a)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF2d5d3a)
                            : const Color(0xFFe3d8c2),
                      ),
                    ),
                    child: Text(
                      '$rate%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF6b5d48),
                      ),
                    ),
                  ),
                ),
              );
            }),
            Expanded(
              child: Container(
                height: 34,
                decoration: BoxDecoration(
                  color: selectedPreset == null
                      ? const Color(0xFFdde8d8)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: selectedPreset == null
                        ? const Color(0xFF2d5d3a)
                        : const Color(0xFFe3d8c2),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: customController,
                        enabled: onCustomChange != null,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        onChanged: onCustomChange,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF231a10),
                        ),
                        decoration: const InputDecoration.collapsed(
                          hintText: 'custom',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFa89a82),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      '%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6b5d48),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Credit impact card ────────────────────────────────────────────────────────

class _CreditImpactCard extends StatelessWidget {
  final double currentDebt;
  final double creditedAmount;

  const _CreditImpactCard({
    required this.currentDebt,
    required this.creditedAmount,
  });

  @override
  Widget build(BuildContext context) {
    final afterOrder = currentDebt + creditedAmount;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFf6e5cc),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFe8c98a)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'CREDIT IMPACT',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFc97a2b),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 6),
              Icon(Icons.info_outline, size: 14, color: Color(0xFFc97a2b)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current debt',
                style: TextStyle(fontSize: 13, color: Color(0xFF6b5d48)),
              ),
              Text(
                formatFcfa(currentDebt),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF231a10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'After this order',
                style: TextStyle(fontSize: 13, color: Color(0xFF6b5d48)),
              ),
              Text(
                formatFcfa(afterOrder),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF231a10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Bottom bar ────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final double total;
  final bool isLoading;
  final String? errorMessage;
  final bool canSubmit;
  final VoidCallback onConfirm;

  const _BottomBar({
    required this.total,
    required this.isLoading,
    required this.errorMessage,
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
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Color(0xFFb3321b), fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
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
                'Confirm order · ${formatFcfa(total)}',
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
