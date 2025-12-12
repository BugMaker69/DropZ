import 'package:bloc/bloc.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_request.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_response/address_response.dart';
import 'package:drop_z_ecommerce_app/features/address/data/repos/address_repo.dart';
import 'package:equatable/equatable.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit(this.addressRepo) : super(AddressInitial());

  final AddressRepo addressRepo;

  Future<void> getAllAddresses() async {
    emit(AddressLoading());
    var result = await addressRepo.getAllAddresses();

    print("getAllAddresses Cubit ${result}");
    result.fold(
      (failure) {
        emit(AddressFailure(failure.errMessage));
      },
      (allAddresses) {
        emit(AddressSuccess(allAddresses));
      },
    );
  }

  Future<void> addAddress(AddressRequest addAddress) async {
    emit(AddressLoading());
    var result = await addressRepo.addAddress(addAddress);

    print("addAddress Cubit ${result}");
    result.fold(
      (failure) {
        emit(AddressFailure(failure.errMessage));
      },
      (address) async {
        emit(AddAddressSuccess(address));
        await getAllAddresses();
      },
    );
  }

  Future<void> updateAddress(int id, AddressRequest addAddress) async {
    emit(AddressLoading());
    var result = await addressRepo.updateAddress(id, addAddress);

    print("updateAddress Cubit ${result}");
    result.fold(
      (failure) {
        emit(AddressFailure(failure.errMessage));
      },
      (address) async {
        emit(AddAddressSuccess(address));
        await getAllAddresses();
      },
    );
  }

  Future<void> deleteAddress(int id) async {
    emit(AddressLoading());
    var result = await addressRepo.deleteAddress(id);

    print("deleteAddress Cubit ${result}");
    result.fold(
      (failure) {
        emit(AddressFailure(failure.errMessage));
      },
      (address) async {
        emit(DeleteAddressSuccess(address));
        await getAllAddresses();
      },
    );
  }
}
