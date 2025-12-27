import 'package:drop_z_ecommerce_app/features/cart/domain/entities/cart_items_entity.dart';
import 'package:equatable/equatable.dart';

class CartEntity extends Equatable {
  final int? cartId;
  final List<CartItemEntity>? items;

  const CartEntity({this.cartId, this.items});

  @override
  List<Object?> get props => [cartId, items];
}
