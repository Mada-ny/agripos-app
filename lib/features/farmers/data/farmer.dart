class Farmer {
  final int id;
  final String identifier;
  final String firstname;
  final String lastname;
  final String phone;
  final double creditLimit;
  final num outstandingDebt;
  final num availableCredit;

  const Farmer({
    required this.id,
    required this.identifier,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.creditLimit,
    required this.outstandingDebt,
    required this.availableCredit,
  });

  String get fullName => '$firstname $lastname';

  String get initials {
    final f = firstname.isNotEmpty ? firstname[0].toUpperCase() : '';
    final l = lastname.isNotEmpty ? lastname[0].toUpperCase() : '';
    return '$f$l';
  }

  bool get hasDebt => outstandingDebt > 0;

  factory Farmer.fromJson(Map<String, dynamic> json) => Farmer(
    id: json['id'] as int,
    identifier: json['identifier'] as String,
    firstname: json['firstname'] as String,
    lastname: json['lastname'] as String,
    phone: json['phone'] as String,
    creditLimit: double.parse(json['credit_limit'] as String),
    outstandingDebt: json['outstanding_debt'] as num,
    availableCredit: json['available_credit'] as num,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'identifier': identifier,
    'firstname': firstname,
    'lastname': lastname,
    'phone': phone,
    'credit_limit': creditLimit,
    'outstanding_debt': outstandingDebt,
    'available_credit': availableCredit,
  };
}
