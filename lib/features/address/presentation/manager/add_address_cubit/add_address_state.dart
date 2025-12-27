part of 'add_address_cubit.dart';

abstract class AddAddressState {}

class AddAddressInitial extends AddAddressState {}

class AddAddressLoading extends AddAddressState {}

class AddAddressSuccess extends AddAddressState {}

class AddAddressFailure extends AddAddressState {
  final String message;
  AddAddressFailure(this.message);
}
