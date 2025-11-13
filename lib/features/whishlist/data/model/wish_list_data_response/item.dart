import 'package:equatable/equatable.dart';

import 'product.dart';

class Item extends Equatable {
  final int? id;
  final Product? product;
  final DateTime? addedAt;

  const Item({this.id, this.product, this.addedAt});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json['id'] as int?,
    product: json['product'] == null
        ? null
        : Product.fromJson(json['product'] as Map<String, dynamic>),
    addedAt: json['added_at'] == null
        ? null
        : DateTime.parse(json['added_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'product': product?.toJson(),
    'added_at': addedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, product, addedAt];
}
