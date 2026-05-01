class Debt {
  final int id;
  final int transactionId;
  final double amountFcfa;
  final double remainingAmount;
  final DateTime createdAt;

  const Debt({
    required this.id,
    required this.transactionId,
    required this.amountFcfa,
    required this.remainingAmount,
    required this.createdAt,
  });

  factory Debt.fromJson(Map<String, dynamic> json) => Debt(
    id: json['id'] as int,
    transactionId: json['transaction_id'] as int,
    amountFcfa: double.parse(json['amount_fcfa'] as String),
    remainingAmount: double.parse(json['remaining_amount'] as String),
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'transaction_id': transactionId,
    'amount_fcfa': amountFcfa,
    'remaining_amount': remainingAmount,
    'created_at': createdAt.toIso8601String(),
  };
}
