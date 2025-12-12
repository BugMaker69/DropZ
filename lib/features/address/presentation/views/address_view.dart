import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_response/address_response.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/views/widgets/address_item.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/views/widgets/address_view_body.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddressView extends StatelessWidget {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Address"), backgroundColor: kPrimaryColor),
      body: AddressViewBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRouter.kCustomerAddAddress); // اللي هتعمله دلوقتي
        },
        label: const Text("Address"),
        icon: const Icon(Icons.location_on_outlined),
        backgroundColor: Colors.green,
      ),
    );
  }
}
