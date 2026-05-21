class RestaurantModel {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? logoUrl;
  final String? coverImageUrl;
  final String? address;
  final double? latitude;
  final double? longitude;
  final double rating;
  final int reviewCount;
  final int? estimatedDeliveryMinutes;
  final double deliveryFee;
  final double minOrderAmount;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.logoUrl,
    this.coverImageUrl,
    this.address,
    this.latitude,
    this.longitude,
    this.rating = 0,
    this.reviewCount = 0,
    this.estimatedDeliveryMinutes,
    this.deliveryFee = 0,
    this.minOrderAmount = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString(),
      logoUrl: json['logo_url']?.toString(),
      coverImageUrl: json['cover_image_url']?.toString(),
      address: json['address']?.toString(),
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      rating: _parseDouble(json['rating']) ?? 0,
      reviewCount: _parseInt(json['review_count']) ?? 0,
      estimatedDeliveryMinutes: _parseInt(json['estimated_delivery_minutes']),
      deliveryFee: _parseDouble(json['delivery_fee']) ?? 0,
      minOrderAmount: _parseDouble(json['min_order_amount']) ?? 0,
      isActive: json['is_active'] == true,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }

  static double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }
}
