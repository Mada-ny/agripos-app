import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/product.dart';

part 'cart_provider.g.dart';

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  double get subtotal => product.price * quantity;
}

// keepAlive so cart persists across product browser → checkout navigation.
@Riverpod(keepAlive: true)
class Cart extends _$Cart {
  @override
  Map<int, CartItem> build() => {};

  void add(Product product) {
    final existing = state[product.id];
    state = {
      ...state,
      product.id: CartItem(
        product: product,
        quantity: (existing?.quantity ?? 0) + 1,
      ),
    };
  }

  void decrement(int productId) {
    final existing = state[productId];
    if (existing == null) return;
    if (existing.quantity <= 1) {
      state = {...state}..remove(productId);
    } else {
      state = {
        ...state,
        productId: CartItem(
          product: existing.product,
          quantity: existing.quantity - 1,
        ),
      };
    }
  }

  void remove(int productId) {
    state = {...state}..remove(productId);
  }

  void clear() => state = {};

  int quantityOf(int productId) => state[productId]?.quantity ?? 0;

  int get totalItems =>
      state.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      state.values.fold(0, (sum, item) => sum + item.subtotal);
}
