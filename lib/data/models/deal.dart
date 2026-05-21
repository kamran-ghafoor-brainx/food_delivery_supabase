class DealModel {
  final String id;
  final String? restaurantId;
  final String title;
  final String? description;
  final String? imageUrl;
  final String discountType;
  final double discountValue;
  final double? minOrderAmount;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final bool isActive;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DealModel({
    required this.id,
    this.restaurantId,
    required this.title,
    this.description,
    this.imageUrl,
    required this.discountType,
    required this.discountValue,
    this.minOrderAmount,
    this.validFrom,
    this.validUntil,
    this.isActive = true,
    this.sortOrder = 0,
    this.createdAt,
    this.updatedAt,
  });

  String get discountLabel {
    if (discountType == 'percentage') {
      return '${discountValue.toInt()}% OFF';
    }
    return 'Rs ${discountValue.toInt()} OFF';
  }

  factory DealModel.fromJson(Map<String, dynamic> json) {
    return DealModel(
      id: json['id']?.toString() ?? '',
      restaurantId: json['restaurant_id']?.toString(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      imageUrl: json['image_url']?.toString(),
      discountType: json['discount_type']?.toString() ?? 'percentage',
      discountValue: (json['discount_value'] is num) ? (json['discount_value'] as num).toDouble() : 0,
      minOrderAmount: json['min_order_amount'] != null ? (json['min_order_amount'] is num ? (json['min_order_amount'] as num).toDouble() : null) : null,
      validFrom: json['valid_from'] != null ? DateTime.tryParse(json['valid_from'].toString()) : null,
      validUntil: json['valid_until'] != null ? DateTime.tryParse(json['valid_until'].toString()) : null,
      isActive: json['is_active'] == true,
      sortOrder: json['sort_order'] is int ? json['sort_order'] as int : 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }
}
