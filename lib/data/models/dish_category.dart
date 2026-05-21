class DishCategoryModel {
  final String id;
  final String restaurantId;
  final String name;
  final int sortOrder;
  final DateTime? createdAt;

  DishCategoryModel({
    required this.id,
    required this.restaurantId,
    required this.name,
    this.sortOrder = 0,
    this.createdAt,
  });

  factory DishCategoryModel.fromJson(Map<String, dynamic> json) {
    return DishCategoryModel(
      id: json['id']?.toString() ?? '',
      restaurantId: json['restaurant_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      sortOrder: json['sort_order'] is int ? json['sort_order'] as int : 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }
}
