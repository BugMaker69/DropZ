import 'package:drop_z_ecommerce_app/features/cart/data/model/cart_items_model/cart_items_model.dart';
import 'package:equatable/equatable.dart';

class CartModel extends Equatable {
  final int? cartId;
  final List<CartItemsModel>? items;

  const CartModel({this.cartId, this.items});

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    cartId: json['cart_id'] as int?,
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => CartItemsModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'cart_id': cartId,
    'items': items?.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [cartId, items];
}
