import 'package:drop_z_ecommerce_app/features/cart/data/model/cart_items_model.dart';
import 'package:drop_z_ecommerce_app/features/cart/domain/entities/cart_entity.dart';
import 'package:drop_z_ecommerce_app/features/cart/domain/entities/cart_items_entity.dart';

class CartModel extends CartEntity {
  const CartModel({super.cartId, super.items});

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    cartId: json['cart_id'] as int?,
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => CartItemModel.fromJson(e) as CartItemEntity)
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'cart_id': cartId,
    'items': items?.map((e) => (e as CartItemModel).toJson()).toList(),
  };
}
