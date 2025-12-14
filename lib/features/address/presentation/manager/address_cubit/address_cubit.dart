import 'package:bloc/bloc.dart';
import 'package:drop_z_ecommerce_app/core/utils/cubit_handler.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_request.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_response/address_response.dart';
import 'package:drop_z_ecommerce_app/features/address/data/repos/address_repo.dart';
import 'package:equatable/equatable.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRepo repo;
  AddressCubit(this.repo) : super(AddressInitial());

  Future<void> getAllAddresses() async {
    if (isClosed) return;

    CubitHandler.run<List<AddressResponse>>(
      cubit: this,
      call: () => repo.getAllAddresses(),
      onSuccess: (data) {
        if (!isClosed) emit(AddressSuccess(data));
      },
      loadingState: () {
        if (!isClosed) emit(AddressLoading());
      },
      failureState: (msg) {
        if (!isClosed) emit(AddressFailure(msg));
      },
    );
  }

  Future<void> addAddress(AddressRequest req) async {
    CubitHandler.run<AddressResponse>(
      cubit: this,
      call: () => repo.addAddress(req),
      onSuccess: (newAddress) {
        // لو ال state الحالي هو AddressSuccess
        if (state is AddressSuccess) {
          final currentAddresses = List<AddressResponse>.from(
            (state as AddressSuccess).allAddresses,
          );
          currentAddresses.add(newAddress);
          emit(AddressSuccess(currentAddresses)); // تحديث الـ state محليًا
        } else {
          // الحالة الأولى لو مش موجودة
          emit(AddressSuccess([newAddress]));
        }
      },
      loadingState: () => emit(AddressLoading()),
      failureState: (msg) => emit(AddressFailure(msg)),
    );
  }

  Future<void> updateAddress(int id, AddressRequest req) async {
    CubitHandler.run<AddressResponse>(
      cubit: this,
      call: () => repo.updateAddress(id, req),
      onSuccess: (updatedAddress) {
        if (state is AddressSuccess) {
          final currentAddresses = List<AddressResponse>.from(
            (state as AddressSuccess).allAddresses,
          );
          final index = currentAddresses.indexWhere((a) => a.id == id);
          if (index != -1) currentAddresses[index] = updatedAddress;
          emit(AddressSuccess(currentAddresses));
        }
      },
      loadingState: () => emit(AddressLoading()),
      failureState: (msg) => emit(AddressFailure(msg)),
    );
  }

  Future<void> deleteAddress(int id) async {
    CubitHandler.run<String>(
      cubit: this,
      call: () => repo.deleteAddress(id),
      onSuccess: (_) {
        if (state is AddressSuccess) {
          // إنشاء نسخة جديدة من الـ list بدل mutate
          final updatedAddresses = (state as AddressSuccess).allAddresses
              .where((a) => a.id != id)
              .toList();

          emit(AddressSuccess(updatedAddresses));
        } else {
          // لو مش AddressSuccess، يمكن اعطاء قائمة فارغة
          emit(AddressSuccess([]));
        }
      },
      loadingState: () => emit(AddressLoading()),
      failureState: (msg) => emit(AddressFailure(msg)),
    );
  }
}
