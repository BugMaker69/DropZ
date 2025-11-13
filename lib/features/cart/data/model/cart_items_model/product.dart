import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int? id;
  final String? seller;
  final bool? isInWishlist;
  final double? averageRating;
  final int? reviewCount;
  final String? title;
  final String? slug;
  final String? description;
  final String? image;
  final String? price;
  final int? stockQuantity;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? category;

  const Product({
    this.id,
    this.seller,
    this.isInWishlist,
    this.averageRating,
    this.reviewCount,
    this.title,
    this.slug,
    this.description,
    this.image,
    this.price,
    this.stockQuantity,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int?,
    seller: json['seller'] as String?,
    isInWishlist: json['is_in_wishlist'] as bool?,
    averageRating: json['average_rating'] as double?,
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
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
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

  @override
  List<Object?> get props {
    return [
      id,
      seller,
      isInWishlist,
      averageRating,
      reviewCount,
      title,
      slug,
      description,
      image,
      price,
      stockQuantity,
      isActive,
      createdAt,
      updatedAt,
      category,
    ];
  }
}
