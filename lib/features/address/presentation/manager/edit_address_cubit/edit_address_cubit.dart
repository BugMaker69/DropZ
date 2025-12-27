import 'package:drop_z_ecommerce_app/core/utils/cubit_handler.dart';
import 'package:drop_z_ecommerce_app/features/address/data/repos/address_repo.dart';
import 'package:drop_z_ecommerce_app/features/address/domain/entities/address_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_address_state.dart';

class EditAddressCubit extends Cubit<EditAddressState> {
  final AddressRepo repo;
  EditAddressCubit(this.repo) : super(EditAddressInitial());

  Future<void> updateAddress(int id, AddressEntity req) async {
    CubitHandler.run<void>(
      cubit: this,
      call: () => repo.updateAddress(id, req),
      onSuccess: (updatedAddress) {
        emit(EditAddressSuccess());
      },
      loadingState: () => emit(EditAddressLoading()),
      failureState: (msg) => emit(EditAddressFailure(msg)),
    );
  }
}
