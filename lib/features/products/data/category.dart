class Category {
  final int id;
  final String name;
  final int? parentId;
  final List<Category> children;

  const Category({
    required this.id,
    required this.name,
    required this.parentId,
    required this.children,
  });

  bool get isRoot => parentId == null;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'] as int,
    name: json['name'] as String,
    parentId: json['parent_id'] as int?,
    children: (json['children'] as List? ?? [])
        .map((c) => Category.fromJson(c as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'parent_id': parentId,
    'children': children.map((c) => c.toJson()).toList(),
  };
}
