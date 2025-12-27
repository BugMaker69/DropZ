import 'package:drop_z_ecommerce_app/features/cart/domain/entities/product_entity.dart';
import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final int? cartItemId;
  final ProductEntity? product;
  final int? quantity;
  final double? itemSubtotal;
  final String? status;
  final String? message;

  const CartItemEntity({
    this.cartItemId,
    this.product,
    this.quantity,
    this.itemSubtotal,
    this.status,
    this.message,
  });

  @override
  List<Object?> get props => [
    cartItemId,
    product,
    quantity,
    itemSubtotal,
    status,
    message,
  ];
}
