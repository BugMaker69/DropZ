import 'package:drop_z_ecommerce_app/core/utils/service_locator.dart';
import 'package:drop_z_ecommerce_app/features/address/data/repos/address_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/manager/address_cubit/address_cubit.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/views/widgets/address_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressViewBody extends StatelessWidget {
  const AddressViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddressCubit(getIt.get<AddressRepoImp>())..getAllAddresses(),
      child: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, state) {
          if (state is AddressLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AddressFailure) {
            return Center(child: Text('Error: ${state.errMessage}'));
          }
          if (state is AddressSuccess) {
            final addresses = state.allAddresses;
            if (addresses!.isEmpty) {
              return const Center(child: Text("There is No Addresses Yet"));
            }

            return Column(
              children: [
                Expanded(child: AddressItemList(getAlladdresses: addresses)),
              ],
            );
          }
          return Text("There Is No data");
        },
      ),
    );
  }
}
