import 'package:bloc/bloc.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/add_item_to_cart_request.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/add_item_to_cart_response.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/cart_items_model/cart_items_model.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/cart_items_model/cart_model.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/delete_item_response.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/edit_quantity.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/repos/cart_repo.dart';
import 'package:equatable/equatable.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this.cartRepo) : super(CartInitial());

  final CartRepo cartRepo;
  // List<CartItemsModel>? _cartItems;

  Future<void> getCartItems() async {
    // if (_cartItems != null) {
    //   emit(CartSuccess(_cartItems!));
    //   return;
    // }
    emit(CartLoading());
    var result = await cartRepo.getCartItems();

    print("getCartItems Cubit ${result}");
    result.fold(
      (failure) {
        emit(CartFailure(failure.errMessage));
      },
      (cartItemsModel) {
        // _cartItems = cartItemsModel;
        emit(CartSuccess(cartItemsModel));
      },
    );
  }

  Future<void> refreshCart() async {
    await cartRepo.clearCacheAndReload(); // مسح الـ Cache
    await getCartItems(); // تحميل البيانات من جديد
  }

  Future<void> addItemToCart(AddItemToCartRequest addItemToCart) async {
    emit(CartLoading());
    var result = await cartRepo.addItemToCart(addItemToCart);

    result.fold(
      (failure) {
        emit(CartFailure(failure.errMessage));
      },
      (addItemToCart) async {
        emit(AddItemToCartSuccess(addItemToCart));
        // _cartItems = null;
        await getCartItems();
      },
    );
  }

  Future<void> changeItemQuantityInCart(
    EditQuantity changeQuantity,
    int itemIdInCart,
  ) async {
    emit(CartLoading());
    var result = await cartRepo.changeItemQuantityInCart(
      changeQuantity,
      itemIdInCart,
    );

    result.fold(
      (failure) {
        emit(CartFailure(failure.errMessage));
      },
      (quantityUpdated) async {
        await getCartItems();
      },
      // (quantityUpdated) {
      //   emit(CartQuantityUpdated(quantityUpdated));
      // },
    );
  }

  Future<void> deleteItemFromCart(int cartItemId) async {
    emit(CartLoading());
    var result = await cartRepo.deleteItemFromCart(cartItemId);

    result.fold(
      (failure) {
        emit(CartFailure(failure.errMessage));
      },
      (deleteItemFromCart) async {
        emit(DeleteItemFromCartSuccess(deleteItemFromCart));
        // _cartItems = null;
        await getCartItems();
      },
    );
  }
}
