import 'package:equatable/equatable.dart';

import 'product.dart';

class CartItemsModel extends Equatable {
  final int? cartItemId;
  final Product? product;
  final int? quantity;
  final double? itemSubtotal;
  final String? status;
  final String? message;

  const CartItemsModel({
    this.cartItemId,
    this.product,
    this.quantity,
    this.itemSubtotal,
    this.status,
    this.message,
  });

  factory CartItemsModel.fromJson(Map<String, dynamic> json) {
    return CartItemsModel(
      cartItemId: json['cart_item_id'] as int?,
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int?,
      itemSubtotal: json['item_subtotal'] as double?,
      status: json['status'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'cart_item_id': cartItemId,
    'product': product?.toJson(),
    'quantity': quantity,
    'item_subtotal': itemSubtotal,
    'status': status,
    'message': message,
  };

  @override
  List<Object?> get props {
    return [cartItemId, product, quantity, itemSubtotal, status, message];
  }
}
