import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/network_cubit/network_cubit.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/manager/address_cubit/address_cubit.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/views/widgets/address_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddressView extends StatefulWidget {
  const AddressView({super.key});

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  bool _showFab = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkCubit, NetworkState>(
      listener: (context, state) {
        if (state is NetworkConnected) {
          context.read<AddressCubit>().getAllAddresses();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Address")),
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is UserScrollNotification) {
              final direction = scrollNotification.direction;
              if (direction == ScrollDirection.forward) {
                // Scroll up
                if (!_showFab) setState(() => _showFab = true);
              } else if (direction == ScrollDirection.reverse) {
                // Scroll down
                if (_showFab) setState(() => _showFab = false);
              }
            }
            return false;
          },
          child: AddressViewBody(),
        ),
        floatingActionButton: AnimatedSlide(
          duration: const Duration(milliseconds: 200),
          offset: _showFab ? Offset.zero : const Offset(0, 2),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _showFab ? 1 : 0,
            child: FloatingActionButton.extended(
              onPressed: () {
                context.push(AppRouter.kCustomerAddAddress);
              },
              label: const Text("Address"),
              icon: const Icon(Icons.location_on_outlined),
              // backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
      ),
    );
  }
}




/*
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
*/