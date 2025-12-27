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
  final List<AddressEntity> allAddresses;

  const AddressSuccess(this.allAddresses);
}
