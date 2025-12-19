import 'package:bloc/bloc.dart';
import 'package:drop_z_ecommerce_app/core/utils/cubit_handler.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/add_item_to_cart_request.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/add_item_to_cart_response.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/cart_items_model/cart_model.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/delete_item_response.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/edit_quantity.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/repos/cart_repo.dart';
import 'package:equatable/equatable.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo cartRepo;

  CartCubit(this.cartRepo) : super(CartInitial());

  Future<void> getCartItems() async {
    await CubitHandler.run<CartModel>(
      cubit: this,
      loadingState: () => emit(CartLoading()),
      failureState: (msg) => emit(CartFailure(msg)),
      call: () => cartRepo.getCartItems(),
      onSuccess: (cartModel) => emit(CartSuccess(cartModel)),
    );
  }

  Future<void> addItemToCart(AddItemToCartRequest addItem) async {
    await CubitHandler.run<AddItemToCartResponse>(
      cubit: this,
      loadingState: () => emit(CartLoading()),
      failureState: (msg) => emit(CartFailure(msg)),
      call: () => cartRepo.addItemToCart(addItem),
      onSuccess: (response) async {
        emit(AddItemToCartSuccess(response));
        await getCartItems();
      },
    );
  }

  Future<void> changeItemQuantityInCart(
    EditQuantity changeQuantity,
    int itemIdInCart,
  ) async {
    await CubitHandler.run<EditQuantity>(
      cubit: this,
      loadingState: () => emit(CartLoading()),
      failureState: (msg) => emit(CartFailure(msg)),
      call: () =>
          cartRepo.changeItemQuantityInCart(changeQuantity, itemIdInCart),
      onSuccess: (data) async {
        await getCartItems();
      },
    );
  }

  Future<void> deleteItemFromCart(int cartItemId) async {
    await CubitHandler.run<DeleteItemResponse>(
      cubit: this,
      loadingState: () => emit(CartLoading()),
      failureState: (msg) => emit(CartFailure(msg)),
      call: () => cartRepo.deleteItemFromCart(cartItemId),
      onSuccess: (response) async {
        emit(DeleteItemFromCartSuccess(response));
        await getCartItems();
      },
    );
  }

  Future<void> refreshCart() async {
    await cartRepo.clearCacheAndReload();
    await getCartItems();
  }

  Future<void> clearCart() async {
    // await cartRepo.clearCacheAndReload();
    emit(CartSuccess(CartModel(items: [])));
  }
}
