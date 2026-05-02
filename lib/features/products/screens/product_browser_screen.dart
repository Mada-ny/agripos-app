import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/utils/format.dart';
import '../data/category.dart';
import '../data/product.dart';
import '../providers/cart_provider.dart';
import '../providers/product_providers.dart';

class ProductBrowserScreen extends ConsumerWidget {
  /// null  → view-only catalogue
  /// non-null → order mode for this farmer
  final int? farmerId;

  const ProductBrowserScreen({super.key, this.farmerId});

  bool get isOrderMode => farmerId != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);
    final categoriesAsync = ref.watch(categoryListProvider);
    final selectedId = ref.watch(selectedCategoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFfaf6ef),
      appBar: _buildAppBar(context, ref, selectedId, categoriesAsync),
      // Cart bar lives in a Stack overlay — keeps it outside the Scaffold's
      // bottomNavigationBar slot so it never triggers a body relayout.
      body: Stack(
        children: [
          _buildBody(context, ref, productsAsync, categoriesAsync, selectedId),
          if (isOrderMode)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _CartBar(farmerId: farmerId!),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    int? selectedId,
    AsyncValue<List<Category>> categoriesAsync,
  ) {
    String title = 'Products';
    if (selectedId != null) {
      final cats = categoriesAsync.valueOrNull ?? [];
      final found = _findCategory(cats, selectedId);
      if (found != null) {
        final parent = found.isRoot ? null : _findParent(cats, found.parentId!);
        title = parent?.name ?? found.name;
      }
    }

    return AppBar(
      backgroundColor: const Color(0xFFfaf6ef),
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF231a10), size: 22),
        onPressed: () => context.pop(),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF231a10),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Color(0xFF231a10)),
          onPressed: () {},
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFe3d8c2)),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Product>> productsAsync,
    AsyncValue<List<Category>> categoriesAsync,
    int? selectedId,
  ) {
    return Column(
      children: [
        // Category tabs
        categoriesAsync.when(
          loading: () => const SizedBox(height: 48),
          error: (_, _) => const SizedBox.shrink(),
          data: (categories) =>
              _CategoryTabs(categories: categories, selectedId: selectedId),
        ),
        // Product list
        Expanded(
          child: productsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    e.toString(),
                    style: const TextStyle(color: Color(0xFF6b5d48)),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => ref.invalidate(productListProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (products) {
              final categories = categoriesAsync.valueOrNull ?? [];
              final filtered = _filterProducts(
                products,
                categories,
                selectedId,
              );

              if (filtered.isEmpty) {
                return const Center(
                  child: Text(
                    'No products in this category.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6b5d48)),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Color(0xFFe3d8c2),
                ),
                itemBuilder: (context, i) => _ProductTile(
                  product: filtered[i],
                  isOrderMode: isOrderMode,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Product> _filterProducts(
    List<Product> products,
    List<Category> categories,
    int? selectedId,
  ) {
    if (selectedId == null) return products;
    final category = _findCategory(categories, selectedId);
    if (category == null) return products;
    // If selected category has children, include all subcategory products
    if (category.children.isNotEmpty) {
      final ids = {selectedId, ...category.children.map((c) => c.id)};
      return products.where((p) => ids.contains(p.category.id)).toList();
    }
    return products.where((p) => p.category.id == selectedId).toList();
  }

  Category? _findCategory(List<Category> categories, int id) {
    for (final c in categories) {
      if (c.id == id) return c;
      final found = _findCategory(c.children, id);
      if (found != null) return found;
    }
    return null;
  }

  Category? _findParent(List<Category> categories, int parentId) {
    for (final c in categories) {
      if (c.id == parentId) return c;
    }
    return null;
  }
}

// ── Category tabs ─────────────────────────────────────────────────────────────

class _CategoryTabs extends ConsumerWidget {
  final List<Category> categories;
  final int? selectedId;

  const _CategoryTabs({required this.categories, required this.selectedId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Build flat list: root categories first, then subcategories of selected root
    final roots = categories.where((c) => c.isRoot).toList();
    Category? selectedRoot;
    if (selectedId != null) {
      for (final r in roots) {
        if (r.id == selectedId || r.children.any((c) => c.id == selectedId)) {
          selectedRoot = r;
          break;
        }
      }
    }

    final chips = <_ChipData>[
      _ChipData(id: null, label: 'All'),
      ...roots.map((c) => _ChipData(id: c.id, label: c.name)),
    ];

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFe3d8c2))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Root category row
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: chips.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final chip = chips[i];
                final active = chip.id == null
                    ? selectedId == null
                    : (chip.id == selectedId || chip.id == selectedRoot?.id);
                return Center(
                  child: _Chip(
                    label: chip.label,
                    active: active,
                    onTap: () => ref
                        .read(selectedCategoryProvider.notifier)
                        .select(chip.id),
                  ),
                );
              },
            ),
          ),
          // Subcategory row (only when a root with children is selected)
          if (selectedRoot != null && selectedRoot.children.isNotEmpty) ...[
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: selectedRoot.children.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final sub = selectedRoot!.children[i];
                  final active = sub.id == selectedId;
                  return Center(
                    child: _Chip(
                      label: sub.name,
                      active: active,
                      small: true,
                      onTap: () => ref
                          .read(selectedCategoryProvider.notifier)
                          .select(active ? selectedRoot!.id : sub.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChipData {
  final int? id;
  final String label;
  const _ChipData({required this.id, required this.label});
}

class _Chip extends StatelessWidget {
  final String label;
  final bool active;
  final bool small;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.active,
    required this.onTap,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: small ? 12 : 14,
          vertical: small ? 5 : 7,
        ),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF2d5d3a) : Colors.transparent,
          border: Border.all(
            color: active ? const Color(0xFF2d5d3a) : const Color(0xFFe3d8c2),
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: small ? 12 : 13,
            fontWeight: FontWeight.w500,
            color: active ? Colors.white : const Color(0xFF6b5d48),
          ),
        ),
      ),
    );
  }
}

// ── Product tile ──────────────────────────────────────────────────────────────

// Tile is StatelessWidget — only _CartControl watches cartProvider,
// so a cart update rebuilds only the small button, not the full tile row.
class _ProductTile extends StatelessWidget {
  final Product product;
  final bool isOrderMode;

  const _ProductTile({required this.product, required this.isOrderMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFf3ede2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 22,
              color: Color(0xFF6b5d48),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF231a10),
                  ),
                ),
                if (product.description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    product.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6b5d48),
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  formatFcfa(product.price),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFc97a2b),
                  ),
                ),
              ],
            ),
          ),
          if (isOrderMode) ...[
            const SizedBox(width: 12),
            _CartControl(product: product),
          ],
        ],
      ),
    );
  }
}

// Only this widget watches cartProvider — rebuilds are scoped to the button.
class _CartControl extends ConsumerWidget {
  final Product product;
  const _CartControl({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qty = ref.watch(
      cartProvider.select((m) => m[product.id]?.quantity ?? 0),
    );
    if (qty == 0) {
      return _AddButton(
        onTap: () => ref.read(cartProvider.notifier).add(product),
      );
    }
    return _Stepper(
      qty: qty,
      onAdd: () => ref.read(cartProvider.notifier).add(product),
      onRemove: () => ref.read(cartProvider.notifier).decrement(product.id),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF2d5d3a),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 20),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final int qty;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _Stepper({
    required this.qty,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onRemove,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFe3d8c2)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.remove, size: 16, color: Color(0xFF231a10)),
          ),
        ),
        SizedBox(
          width: 32,
          child: Text(
            '$qty',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF231a10),
            ),
          ),
        ),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF2d5d3a),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add, size: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// ── Cart bar ──────────────────────────────────────────────────────────────────

class _CartBar extends ConsumerWidget {
  final int farmerId;
  const _CartBar({required this.farmerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    if (cart.isEmpty) return const SizedBox(height: 0, width: double.infinity);

    final totalItems = cart.values.fold(0, (s, item) => s + item.quantity);
    final totalPrice = cart.values.fold(0.0, (s, item) => s + item.subtotal);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFe3d8c2))),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$totalItems item${totalItems == 1 ? '' : 's'} in cart',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6b5d48),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatFcfa(totalPrice),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFc97a2b),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () =>
                context.push('/orders/checkout?farmer_id=$farmerId'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(120, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: const Text(
              'Checkout',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
