part of 'edit_address_cubit.dart';

abstract class EditAddressState {}

class EditAddressInitial extends EditAddressState {}

class EditAddressLoading extends EditAddressState {}

class EditAddressSuccess extends EditAddressState {}

class EditAddressFailure extends EditAddressState {
  final String message;
  EditAddressFailure(this.message);
}
