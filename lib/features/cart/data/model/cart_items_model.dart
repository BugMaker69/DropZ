import 'package:drop_z_ecommerce_app/features/cart/data/model/product_model.dart';
import 'package:drop_z_ecommerce_app/features/cart/domain/entities/cart_entity.dart';
import 'package:drop_z_ecommerce_app/features/cart/domain/entities/cart_items_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    super.cartItemId,
    super.product,
    super.quantity,
    super.itemSubtotal,
    super.status,
    super.message,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    cartItemId: json['cart_item_id'] as int?,
    product: json['product'] == null
        ? null
        : ProductModel.fromJson(json['product']),
    quantity: json['quantity'] as int?,
    itemSubtotal: (json['item_subtotal'] as num?)?.toDouble(),
    status: json['status'] as String?,
    message: json['message'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'cart_item_id': cartItemId,
    'product': (product as ProductModel?)?.toJson(),
    'quantity': quantity,
    'item_subtotal': itemSubtotal,
    'status': status,
    'message': message,
  };
}
