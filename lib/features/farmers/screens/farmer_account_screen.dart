import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/utils/format.dart';
import '../data/debt.dart';
import '../data/farmer.dart';
import '../providers/farmer_account_provider.dart';

class FarmerAccountScreen extends ConsumerWidget {
  final int farmerId;

  const FarmerAccountScreen({super.key, required this.farmerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmerAsync = ref.watch(farmerDetailProvider(farmerId));
    final debtsAsync = ref.watch(farmerDebtsProvider(farmerId));

    return farmerAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFFfaf6ef),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Scaffold(
        backgroundColor: Color(0xFFfaf6ef),
        appBar: _lightAppBar(title: 'Account', subtitle: ''),
        body: Center(
          child: Text(
            e.toString(),
            style: const TextStyle(color: Color(0xFFb3321b)),
          ),
        ),
      ),
      data: (farmer) => Scaffold(
        backgroundColor: const Color(0xFFfaf6ef),
        appBar: _lightAppBar(
          title: 'Account',
          subtitle: farmer.fullName,
          context: context,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroCard(farmer: farmer),
              _ActionButtons(farmer: farmer),
              _CreditCards(farmer: farmer),
              const SizedBox(height: 8),
              _DebtsSection(debtsAsync: debtsAsync),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _lightAppBar({
    required String title,
    required String subtitle,
    BuildContext? context,
  }) {
    return AppBar(
      backgroundColor: const Color(0xFFfaf6ef),
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      leading: context != null
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF231a10),
                size: 22,
              ),
              onPressed: () => context.pop(),
            )
          : null,
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
      actions: [
        IconButton(
          icon: const Icon(Icons.more_horiz, color: Color(0xFF231a10)),
          onPressed: () {},
        ),
      ],
    );
  }
}

// ── Hero card ─────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  final Farmer farmer;

  const _HeroCard({required this.farmer});

  static const _avatarColors = [
    Color(0xFFE8A87C),
    Color(0xFF8DB5A5),
    Color(0xFFE8D080),
    Color(0xFFB8A0C8),
    Color(0xFFA8C090),
    Color(0xFFD4956A),
    Color(0xFF90B0C8),
  ];

  @override
  Widget build(BuildContext context) {
    final avatarColor = _avatarColors[farmer.id % _avatarColors.length];
    final progress = farmer.creditLimit > 0
        ? (farmer.outstandingDebt / farmer.creditLimit).clamp(0.0, 1.0)
        : 0.0;
    final usedPct = (progress * 100).round();

    return Container(
      width: double.infinity,
      color: const Color(0xFF2d5d3a),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Farmer identity row
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: avatarColor,
                child: Text(
                  farmer.initials,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF231a10),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    farmer.fullName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    farmer.identifier,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Total outstanding label
          Text(
            'TOTAL OUTSTANDING',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.6),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),

          // Large amount
          Text(
            formatFcfa(farmer.outstandingDebt.toDouble()),
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SizedBox(
              height: 4,
              child: Stack(
                children: [
                  Container(color: Colors.white.withValues(alpha: 0.2)),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(color: const Color(0xFFc97a2b)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Credit usage row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$usedPct% of credit limit',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              Text(
                '${formatFcfa(farmer.availableCredit.toDouble())} available',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Action buttons ────────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final Farmer farmer;

  const _ActionButtons({required this.farmer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () =>
                  context.push('/repayments?farmer_id=${farmer.id}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2d5d3a),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.zero,
              ),
              icon: const Icon(Icons.grain, size: 18),
              label: const Text(
                'Record repayment',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.push('/products?farmer_id=${farmer.id}'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF231a10),
                minimumSize: const Size.fromHeight(48),
                side: const BorderSide(color: Color(0xFFe3d8c2), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.zero,
              ),
              icon: const Icon(Icons.shopping_basket_outlined, size: 18),
              label: const Text(
                'New order',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Credit cards ──────────────────────────────────────────────────────────────

class _CreditCards extends StatelessWidget {
  final Farmer farmer;

  const _CreditCards({required this.farmer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _CreditCard(
              label: 'CREDIT LIMIT',
              amount: farmer.creditLimit,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _CreditCard(
              label: 'AVAILABLE',
              amount: farmer.availableCredit.toDouble(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditCard extends StatelessWidget {
  final String label;
  final double amount;

  const _CreditCard({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFe3d8c2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFFa89a82),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formatFcfa(amount),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF231a10),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Debts section ─────────────────────────────────────────────────────────────

class _DebtsSection extends StatelessWidget {
  final AsyncValue<List<Debt>> debtsAsync;

  const _DebtsSection({required this.debtsAsync});

  @override
  Widget build(BuildContext context) {
    return debtsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          e.toString(),
          style: const TextStyle(color: Color(0xFFb3321b), fontSize: 13),
        ),
      ),
      data: (debts) {
        if (debts.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Text(
                'OPEN ORDERS (${debts.length})',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFa89a82),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFe3d8c2)),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: debts.length,
                separatorBuilder: (_, _) => const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Color(0xFFe3d8c2),
                ),
                itemBuilder: (context, i) => _DebtTile(debt: debts[i]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DebtTile extends StatelessWidget {
  final Debt debt;

  const _DebtTile({required this.debt});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM d, yyyy').format(debt.createdAt.toLocal());
    final isPartial = debt.remainingAmount < debt.amountFcfa;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFf3ede2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 18,
              color: Color(0xFF6b5d48),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ORD-${debt.transactionId}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF231a10),
                  ),
                ),
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6b5d48),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatFcfa(debt.remainingAmount),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFb3321b),
                ),
              ),
              if (isPartial)
                Text(
                  'of ${formatFcfa(debt.amountFcfa)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFa89a82),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
