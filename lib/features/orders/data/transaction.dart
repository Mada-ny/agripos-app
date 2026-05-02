import '../../farmers/data/farmer.dart';
import '../../products/data/product.dart';

class TransactionItem {
  final int id;
  final Product product;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  const TransactionItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) =>
      TransactionItem(
        id: json['id'] as int,
        product: Product.fromJson(json['product'] as Map<String, dynamic>),
        quantity: json['quantity'] as int,
        unitPrice: double.parse(json['unit_price'] as String),
        subtotal: (json['subtotal'] as num).toDouble(),
      );
}

class Transaction {
  final int id;
  final Farmer farmer;
  final double totalFcfa;
  final String paymentMethod;
  final double? interestRate;
  final double? creditedAmount;
  final List<TransactionItem> items;
  final DateTime createdAt;

  const Transaction({
    required this.id,
    required this.farmer,
    required this.totalFcfa,
    required this.paymentMethod,
    this.interestRate,
    this.creditedAmount,
    required this.items,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'] as int,
    farmer: Farmer.fromJson(json['farmer'] as Map<String, dynamic>),
    totalFcfa: double.parse(json['total_fcfa'] as String),
    paymentMethod: json['payment_method'] as String,
    interestRate: json['interest_rate'] != null
        ? double.parse(json['interest_rate'] as String)
        : null,
    creditedAmount: json['credited_amount'] != null
        ? double.parse(json['credited_amount'] as String)
        : null,
    items: (json['items'] as List)
        .map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}
