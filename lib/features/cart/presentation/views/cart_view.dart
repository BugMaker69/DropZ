import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:drop_z_ecommerce_app/features/cart/presentation/views/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<CartCubit>().refreshCart(),
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CustomLoadingIndicator());
          } else if (state is CartFailure) {
            print("${state.errMessage}");
            return Center(child: Text(state.errMessage));
          } else if (state is CartSuccess) {
            final data = state.cartItemsModel;
            print("Inside CartView ${data}");
            return ListView.separated(
              itemBuilder: (context, index) =>
                  CartItem(cartItemsModel: data[index]),
              itemCount: data.length,
              separatorBuilder: (context, index) => Divider(),
            );
          } else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}

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
