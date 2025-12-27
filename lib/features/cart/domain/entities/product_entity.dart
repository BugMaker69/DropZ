import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
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

  const ProductEntity({
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

  @override
  List<Object?> get props => [
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
