import 'package:drop_z_ecommerce_app/core/utils/cubit_handler.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_request_model.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_response_model.dart';
import 'package:drop_z_ecommerce_app/features/address/data/repos/address_repo.dart';
import 'package:drop_z_ecommerce_app/features/address/domain/entities/address_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_address_state.dart';

class AddAddressCubit extends Cubit<AddAddressState> {
  final AddressRepo repo;
  AddAddressCubit(this.repo) : super(AddAddressInitial());

  Future<void> addAddress(AddressEntity req) async {
    CubitHandler.run<void>(
      cubit: this,
      call: () => repo.addAddress(req),
      onSuccess: (newAddress) {
        emit(AddAddressSuccess());
      },
      loadingState: () => emit(AddAddressLoading()),
      failureState: (msg) => emit(AddAddressFailure(msg)),
    );
  }
}
