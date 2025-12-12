import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_response/address_response.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/manager/address_cubit/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddressItem extends StatelessWidget {
  final AddressResponse addressResponse;
  const AddressItem({super.key, required this.addressResponse});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(
          context,
        ).push(AppRouter.kCustomerEditAddress, extra: addressResponse);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Country: "),
                  Text("${addressResponse.country}"),
                  Expanded(
                    child: Align(
                      alignment: AlignmentGeometry.topRight,
                      child: CircleAvatar(
                        backgroundColor: addressResponse.isDefault!
                            ? Colors.green[400]
                            : Colors.red[400],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),
              Row(
                children: [
                  Text("Government: "),
                  Text("${addressResponse.governorate}"),
                ],
              ),
              SizedBox(height: 8),

              Row(children: [Text("City: "), Text("${addressResponse.city}")]),

              SizedBox(height: 8),
              Row(
                children: [Text("Street: "), Text("${addressResponse.street}")],
              ),

              SizedBox(height: 8),
              Row(
                children: [
                  Text("Postal Code: "),
                  Text("${addressResponse.postalCode}"),
                ],
              ),

              SizedBox(height: 8),
              Row(
                children: [
                  Text("Is Default: "),
                  Text(
                    addressResponse.isDefault! ? "Yes" : "No",
                    style: TextStyle(
                      color: addressResponse.isDefault!
                          ? Colors.greenAccent
                          : Colors.redAccent,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: AlignmentGeometry.bottomRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<AddressCubit>().deleteAddress(
                            addressResponse.id!,
                          );
                        },
                        icon: const Icon(Icons.delete, size: 18),
                        label: const Text("حذف"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
