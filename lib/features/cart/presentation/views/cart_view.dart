import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/network_cubit/network_cubit.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_error_widget.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/core/widgets/offline_banner.dart';
import 'package:drop_z_ecommerce_app/core/widgets/staggered_animation.dart';
import 'package:drop_z_ecommerce_app/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:drop_z_ecommerce_app/features/cart/presentation/views/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CartView extends StatelessWidget {
  CartView({super.key});

  final ValueNotifier<bool> showFAB = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkCubit, NetworkState>(
      listener: (context, state) {
        if (state is NetworkConnected) {
          context.read<CartCubit>().refreshCart();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("My Cart")),
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is UserScrollNotification) {
              if (notification.direction == ScrollDirection.forward) {
                showFAB.value = true; // Scroll up -> show
              } else if (notification.direction == ScrollDirection.reverse) {
                showFAB.value = false; // Scroll down -> hide
              }
            }
            return false;
          },
          child: Column(
            children: [
              const OfflineBanner(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => context.read<CartCubit>().refreshCart(),
                  child: BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      if (state is CartLoading) {
                        return const CustomLoadingIndicator();
                      } else if (state is CartFailure) {
                        return CustomErrorWidget(
                          errMessage: "Error: ${state.errMessage}",
                        );
                      } else if (state is CartSuccess) {
                        final data = state.cartItemsModel.items!;
                        if (data.isNotEmpty) {
                          return ListView.separated(
                            itemBuilder: (context, index) => StaggeredAnimation(
                              index: index,
                              child: CartItem(cartItemsModel: data[index]),
                            ),
                            itemCount: data.length,
                            separatorBuilder: (context, index) => Divider(),
                          );
                        } else {
                          return const CustomErrorWidget(
                            errMessage: "No data available",
                          );
                        }
                      } else {
                        return const CustomErrorWidget(
                          errMessage: "No data available",
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: showFAB,
          builder: (context, value, child) {
            return AnimatedSlide(
              duration: const Duration(milliseconds: 200),
              offset: value ? Offset.zero : const Offset(0, 2),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: value ? 1 : 0,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    context.push(AppRouter.kCustomerCheckout);
                  },
                  label: const Text("Checkout"),
                  icon: const Icon(Icons.shopping_bag),
                  // backgroundColor: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

