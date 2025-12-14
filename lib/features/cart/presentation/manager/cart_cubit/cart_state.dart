part of 'cart_cubit.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartFailure extends CartState {
  final String errMessage;

  const CartFailure(this.errMessage);
}

final class CartSuccess extends CartState {
  final CartModel cartItemsModel;
  // final List<CartItemsModel> cartItemsModel;

  const CartSuccess(this.cartItemsModel);
}

final class AddItemToCartSuccess extends CartState {
  final AddItemToCartResponse addItemToCartResponse;

  const AddItemToCartSuccess(this.addItemToCartResponse);
}

final class DeleteItemFromCartSuccess extends CartState {
  final DeleteItemResponse deleteItemResponse;

  const DeleteItemFromCartSuccess(this.deleteItemResponse);
}

final class CartQuantityUpdated extends CartState {
  final EditQuantity editQuantity;

  const CartQuantityUpdated(this.editQuantity);
}
