import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/utils/format.dart';
import '../data/farmer.dart';
import '../providers/farmers_provider.dart';

class FarmerSearchScreen extends ConsumerStatefulWidget {
  const FarmerSearchScreen({super.key});

  @override
  ConsumerState<FarmerSearchScreen> createState() => _FarmerSearchScreenState();
}

class _FarmerSearchScreenState extends ConsumerState<FarmerSearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    setState(() => _query = value.trim().toLowerCase());
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  List<Farmer> _filter(List<Farmer> farmers) {
    if (_query.isEmpty) return farmers;
    return farmers.where((f) {
      return f.fullName.toLowerCase().contains(_query) ||
          f.identifier.toLowerCase().contains(_query) ||
          f.phone.contains(_query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final farmersAsync = ref.watch(farmerListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFfaf6ef),
      appBar: _buildAppBar(farmersAsync),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: _SearchBar(
              controller: _searchController,
              hasText: _query.isNotEmpty,
              onChanged: _onTextChanged,
              onClear: _clearSearch,
            ),
          ),
          const SizedBox(height: 16),
          farmersAsync.when(
            loading: () => const Expanded(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, st) => Expanded(
              child: _ErrorView(
                message: e.toString(),
                onRetry: () => ref.invalidate(farmerListProvider),
              ),
            ),
            data: (farmers) {
              final filtered = _filter(farmers);
              return Expanded(
                child: _FarmerList(
                  farmers: filtered,
                  totalCount: farmers.length,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/farmers/new'),
        backgroundColor: const Color(0xFF2d5d3a),
        foregroundColor: Colors.white,
        elevation: 2,
        child: const Icon(Icons.add),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AsyncValue<List<Farmer>> farmersAsync) {
    final total = farmersAsync.valueOrNull?.length;
    final subtitle = total != null ? '$total active accounts' : 'Loading…';

    return AppBar(
      backgroundColor: const Color(0xFFfaf6ef),
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Farmers',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF231a10),
            ),
          ),
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

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool hasText;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.hasText,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search by name, ID or phone…',
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: hasText
            ? IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: onClear,
              )
            : null,
      ),
    );
  }
}

// ── Farmer list ───────────────────────────────────────────────────────────────

class _FarmerList extends StatelessWidget {
  final List<Farmer> farmers;
  final int totalCount;

  const _FarmerList({required this.farmers, required this.totalCount});

  @override
  Widget build(BuildContext context) {
    if (farmers.isEmpty) {
      return const Center(
        child: Text(
          'No farmer found',
          style: TextStyle(fontSize: 14, color: Color(0xFF6b5d48)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ALL FARMERS (${farmers.length})',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFa89a82),
                  letterSpacing: 0.5,
                ),
              ),
              Row(
                children: const [
                  Text(
                    'A-Z',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6b5d48),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: Color(0xFF6b5d48),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: farmers.length,
            separatorBuilder: (_, _) => const Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: Color(0xFFe3d8c2),
            ),
            itemBuilder: (context, i) => _FarmerTile(farmer: farmers[i]),
          ),
        ),
      ],
    );
  }
}

// ── Farmer tile ───────────────────────────────────────────────────────────────

class _FarmerTile extends StatelessWidget {
  final Farmer farmer;

  const _FarmerTile({required this.farmer});

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

    return InkWell(
      onTap: () => context.push('/farmers/${farmer.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 22,
              backgroundColor: avatarColor,
              child: Text(
                farmer.initials,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF231a10),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Name + identifier
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
                  const SizedBox(height: 2),
                  Text(
                    '${farmer.identifier} · ${farmer.phone}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6b5d48),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Debt indicator
            if (farmer.hasDebt)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'OWES',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFa89a82),
                    ),
                  ),
                  Text(
                    formatFcfa(farmer.outstandingDebt.toDouble()),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFb3321b),
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              )
            else
              _ClearBadge(),
          ],
        ),
      ),
    );
  }
}

class _ClearBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFdde8d8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, size: 12, color: Color(0xFF2d5d3a)),
          SizedBox(width: 4),
          Text(
            'Clear',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2d5d3a),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_outlined,
              size: 48,
              color: Color(0xFFa89a82),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6b5d48)),
            ),
            const SizedBox(height: 20),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
