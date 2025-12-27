import 'package:drop_z_ecommerce_app/features/cart/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    super.id,
    super.seller,
    super.isInWishlist,
    super.averageRating,
    super.reviewCount,
    super.title,
    super.slug,
    super.description,
    super.image,
    super.price,
    super.stockQuantity,
    super.isActive,
    super.createdAt,
    super.updatedAt,
    super.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'] as int?,
    seller: json['seller'] as String?,
    isInWishlist: json['is_in_wishlist'] as bool?,
    averageRating: (json['average_rating'] as num?)?.toDouble(),
    reviewCount: json['review_count'] as int?,
    title: json['title'] as String?,
    slug: json['slug'] as String?,
    description: json['description'] as String?,
    image: json['image'] as String?,
    price: json['price'] as String?,
    stockQuantity: json['stock_quantity'] as int?,
    isActive: json['is_active'] as bool?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at']),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at']),
    category: json['category'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'seller': seller,
    'is_in_wishlist': isInWishlist,
    'average_rating': averageRating,
    'review_count': reviewCount,
    'title': title,
    'slug': slug,
    'description': description,
    'image': image,
    'price': price,
    'stock_quantity': stockQuantity,
    'is_active': isActive,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'category': category,
  };
}
