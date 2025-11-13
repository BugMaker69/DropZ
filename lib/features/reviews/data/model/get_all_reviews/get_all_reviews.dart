import 'package:equatable/equatable.dart';

import 'user.dart';

class GetAllReviews extends Equatable {
  final int? id;
  final int? product;
  final User? user;
  final int? rating;
  final String? comment;
  final DateTime? createdAt;

  const GetAllReviews({
    this.id,
    this.product,
    this.user,
    this.rating,
    this.comment,
    this.createdAt,
  });

  factory GetAllReviews.fromJson(Map<String, dynamic> json) => GetAllReviews(
    id: json['id'] as int?,
    product: json['product'] as int?,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    rating: json['rating'] as int?,
    comment: json['comment'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'product': product,
    'user': user?.toJson(),
    'rating': rating,
    'comment': comment,
    'created_at': createdAt?.toIso8601String(),
  };

  @override
  List<Object?> get props {
    return [id, product, user, rating, comment, createdAt];
  }
}
