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


/*
class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: kPrimaryColor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRouter.kCustomerCheckout); // اللي هتعمله دلوقتي
        },
        label: const Text("Checkout"),
        icon: const Icon(Icons.shopping_bag),
        backgroundColor: Colors.green,
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<CartCubit>().refreshCart(),
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const CustomLoadingIndicator();
            } else if (state is CartFailure) {
              print("${state.errMessage}");
              return const CustomErrorWidget(
                errMessage: "There is No NetWork Connection",
              );
            } else if (state is CartSuccess) {
              final data = state.cartItemsModel.items!;
              print("Inside CartView ${data}");
              if (data.length > 0 || data.isNotEmpty) {
                return  ListView.separated(
                  itemBuilder: (context, index) => StaggeredAnimation(
                    index: index,
                    child: CartItem(cartItemsModel: data[index]),
                  ),
                  itemCount: data.length,
                  separatorBuilder: (context, index) => Divider(),
                );
              } else {
                return const CustomErrorWidget(errMessage: "No data available");
              }
            } else {
              return const CustomErrorWidget(errMessage: "No data available");
            }
          },
        ),
      ),
    );
  }
}
*/



/*

import 'package:drop_z_ecommerce_app/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:drop_z_ecommerce_app/features/cart/presentation/views/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CartFailure) {
          print("${state.errMessage}");
          return Center(child: Text(state.errMessage));
        } else if (state is CartSuccess) {
          final data = state.cartItemsModel;
          print("Inside CartView $data");

          return ListView.separated(
            itemCount: data.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = data[index];

              return Dismissible(
                key: ValueKey(item.cartItemId),
                direction: DismissDirection.horizontal,

                // ✅ الخلفية لما تعمل Swipe من اليسار لليمين (add to wishlist)
                background: Container(
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Add to Wishlist",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),

                // ✅ الخلفية لما تعمل Swipe من اليمين لليسار (delete)
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Delete",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.delete, color: Colors.white),
                    ],
                  ),
                ),

                // ✅ تحديد السلوك على حسب الاتجاه
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    // Swipe left → Add to Wishlist
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added to Wishlist 💚'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    // تقدر هنا تضيف دالة فعلية للإضافة للمفضلة
                    return false; // ما تمسحوش من الليست
                  } else {
                    // Swipe right → Delete
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete item?'),
                        content: const Text(
                            'Are you sure you want to remove this item from the cart?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (shouldDelete == true) {
                      context.read<CartCubit>().deleteItem(item.cartItemId!);
                      return true;
                    }
                    return false;
                  }
                },

                child: CartItem(cartItemsModel: item),
              );
            },
          );
        } else {
          return const Center(child: Text("No data available"));
        }
      },
    );
  }
}

 
 */
