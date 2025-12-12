// lib/features/cart/logic/checkout_cubit.dart
import 'package:drop_z_ecommerce_app/core/utils/service_locator.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/cart_items_model/cart_items_model.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/cart_items_model/cart_model.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/repos/cart_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/checkout/data/repos/checkout_repo.dart';
import 'package:drop_z_ecommerce_app/features/checkout/presentation/manager/checkout_cubit/checkout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit(this.checkoutRepo) : super(CheckoutInitial());

  final CheckoutRepo checkoutRepo;

  int? selectedAddressId;

  void setSelectedAddress(int id) {
    selectedAddressId = id;
    emit(CheckoutAddressChanged(id));
  }

  Future<void> createOrder() async {
    if (selectedAddressId == null) {
      emit(CheckoutFailure("Please select an address."));
      return;
    }

    emit(CheckoutLoading());

    final cartItems = (await getIt.get<CartRepoImp>().getCartItems()).fold(
      (f) => <CartItemsModel>[],
      (items) => items.items!,
    );

    final orderItems = cartItems
        .map((item) => {"product": item.product!.id, "quantity": item.quantity})
        .toList();

    final result = await checkoutRepo.createOrder(
      orderItems,
      selectedAddressId!,
    );

    result.fold(
      (failure) => emit(CheckoutFailure(failure.errMessage)),
      (orderId) => emit(CheckoutSuccess(orderId)),
    );
  }

  Future<void> createCheckoutOrder() async {
    if (selectedAddressId == null) {
      emit(CheckoutFailure("Please select an address."));
      return;
    }

    emit(CheckoutLoading());

    final cartItems = (await getIt.get<CartRepoImp>().getCartItems()).fold(
      (f) => <int>[],
      (items) => items.cartId,
    );

    // final orderItems = cartItems
    //     .map((item) => {"product": item.product!.id, "quantity": item.quantity})
    //     .toList();

    final result = await checkoutRepo.createCheckoutOrder(
      cartItems as int,
      selectedAddressId!,
    );

    result.fold(
      (failure) => emit(CheckoutFailure(failure.errMessage)),
      (orderId) => emit(CheckoutSuccess(orderId)),
    );
  }
}
