import 'package:bloc/bloc.dart';
import 'package:drop_z_ecommerce_app/core/utils/cubit_handler.dart';
import 'package:drop_z_ecommerce_app/features/address/data/repos/address_repo.dart';
import 'package:drop_z_ecommerce_app/features/address/domain/entities/address_entity.dart';
import 'package:equatable/equatable.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRepo repo;
  AddressCubit(this.repo) : super(AddressInitial());

  Future<void> getAllAddresses() async {
    if (isClosed) return;

    CubitHandler.run<List<AddressEntity>>(
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

  Future<void> deleteAddress(int id) async {
    CubitHandler.run<String>(
      cubit: this,
      call: () => repo.deleteAddress(id),
      onSuccess: (_) {
        if (state is AddressSuccess) {
          final updatedAddresses = (state as AddressSuccess).allAddresses
              .where((a) => a.id != id)
              .toList();
          emit(AddressSuccess(updatedAddresses));
        }
      },
      loadingState: () => emit(AddressLoading()),
      failureState: (msg) => emit(AddressFailure(msg)),
    );
  }
}
