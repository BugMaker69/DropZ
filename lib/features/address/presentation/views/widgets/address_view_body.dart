import 'package:drop_z_ecommerce_app/core/utils/service_locator.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_error_widget.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/features/address/data/repos/address_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/manager/address_cubit/address_cubit.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/views/widgets/address_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressViewBody extends StatelessWidget {
  const AddressViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        if (state is AddressLoading) {
          return CustomLoadingIndicator();
        }
        if (state is AddressFailure) {
          return CustomErrorWidget(errMessage: 'Error: ${state.errMessage}');
        }
        if (state is AddressSuccess) {
          final addresses = state.allAddresses;
          if (addresses.isEmpty) {
            return CustomErrorWidget(errMessage: "There is No Addresses Yet");
          }

          return Column(
            children: [
              Expanded(child: AddressItemList(getAlladdresses: addresses)),
            ],
          );
        }
        return CustomErrorWidget(errMessage: "There Is No data");
      },
    );
  }
}
