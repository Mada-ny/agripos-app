import 'category.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final Category category;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
    price: double.parse(json['price'] as String),
    category: Category.fromJson(json['category'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'category': category.toJson(),
  };
}
