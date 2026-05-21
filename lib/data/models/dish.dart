class DishModel {
  final String id;
  final String restaurantId;
  final String? categoryId;
  final String name;
  final String? description;
  final String? imageUrl;
  final double price;
  final double? discountedPrice;
  final bool isVegetarian;
  final bool isBestseller;
  final int sortOrder;
  final bool isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DishModel({
    required this.id,
    required this.restaurantId,
    this.categoryId,
    required this.name,
    this.description,
    this.imageUrl,
    required this.price,
    this.discountedPrice,
    this.isVegetarian = false,
    this.isBestseller = false,
    this.sortOrder = 0,
    this.isAvailable = true,
    this.createdAt,
    this.updatedAt,
  });

  double get displayPrice => discountedPrice ?? price;
  bool get hasDiscount => discountedPrice != null && discountedPrice! < price;

  factory DishModel.fromJson(Map<String, dynamic> json) {
    return DishModel(
      id: json['id']?.toString() ?? '',
      restaurantId: json['restaurant_id']?.toString() ?? '',
      categoryId: json['category_id']?.toString(),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      imageUrl: json['image_url']?.toString(),
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0,
      discountedPrice: json['discounted_price'] != null && json['discounted_price'] is num ? (json['discounted_price'] as num).toDouble() : null,
      isVegetarian: json['is_vegetarian'] == true,
      isBestseller: json['is_bestseller'] == true,
      sortOrder: json['sort_order'] is int ? json['sort_order'] as int : 0,
      isAvailable: json['is_available'] != false,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }
}
