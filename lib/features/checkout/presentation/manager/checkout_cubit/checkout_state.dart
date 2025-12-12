// lib/features/cart/logic/checkout_state.dart
import 'package:equatable/equatable.dart';

sealed class CheckoutState extends Equatable {
  const CheckoutState();
  @override
  List<Object> get props => [];
}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutFailure extends CheckoutState {
  final String errMessage;
  const CheckoutFailure(this.errMessage);
}

final class CheckoutSuccess extends CheckoutState {
  final int orderId;
  const CheckoutSuccess(this.orderId);
}

final class CheckoutAddressChanged extends CheckoutState {
  final int id;
  const CheckoutAddressChanged(this.id);
}
