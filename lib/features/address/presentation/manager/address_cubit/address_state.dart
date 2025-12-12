part of 'address_cubit.dart';

sealed class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

final class AddressInitial extends AddressState {}

final class AddressLoading extends AddressState {}

final class AddressFailure extends AddressState {
  final String errMessage;

  const AddressFailure(this.errMessage);
}

final class AddressSuccess extends AddressState {
  final List<AddressResponse> allAddresses;

  const AddressSuccess(this.allAddresses);
}

final class AddAddressSuccess extends AddressState {
  final AddressResponse addresses;

  const AddAddressSuccess(this.addresses);
}

final class DeleteAddressSuccess extends AddressState {
  final String deletedAddress;

  const DeleteAddressSuccess(this.deletedAddress);
}
