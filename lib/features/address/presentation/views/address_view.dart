import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/network_cubit/network_cubit.dart';
import 'package:drop_z_ecommerce_app/core/utils/service_locator.dart';
import 'package:drop_z_ecommerce_app/features/address/data/repos/address_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/manager/address_cubit/address_cubit.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/views/widgets/address_view_body.dart';
import 'package:drop_z_ecommerce_app/l10n/app_localizations.dart';
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
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) =>
          AddressCubit(getIt.get<AddressRepoImp>())..getAllAddresses(),
      child: BlocListener<NetworkCubit, NetworkState>(
        listener: (context, state) {
          if (state is NetworkConnected) {
            context.read<AddressCubit>().getAllAddresses();
          }
        },
        child: Scaffold(
          appBar: AppBar(title: Text("${localizations.address}")),
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
                label: Text("${localizations.address}"),
                icon: const Icon(Icons.location_on_outlined),
                // backgroundColor: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
