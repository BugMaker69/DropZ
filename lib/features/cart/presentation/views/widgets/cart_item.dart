import 'package:cached_network_image/cached_network_image.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_cached_network_image.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/cart_items_model/cart_items_model.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/edit_quantity.dart';
import 'package:drop_z_ecommerce_app/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/widgets/product_item_details.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/model/add_product_to_wish_list_request.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/presentation/manager/wish_list_cubit/wish_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.cartItemsModel});
  final CartItemsModel cartItemsModel;

  @override
  Widget build(BuildContext context) {
    final quantityNotifier = ValueNotifier<int>(cartItemsModel.quantity!);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomCachedNetworkImage(
              width: 150,
              height: 150,
              image:
                  "https://uncondemnable-brianna-hazelly.ngrok-free.dev/${cartItemsModel.product?.image}" ??
                  "",

              // "http://10.0.2.2:8000/${cartItemsModel.product?.image}" ?? "",
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "${cartItemsModel.product?.title}",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${cartItemsModel.product?.seller}",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${cartItemsModel.product?.price}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "Total Price \$${cartItemsModel.itemSubtotal}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder(
                    valueListenable: quantityNotifier,
                    builder: (context, quantity, child) {
                      return IncrementDecrementButtonWidget(
                        quantity: quantity,
                        onIncrement: () async {
                          quantityNotifier.value++;
                          await context
                              .read<CartCubit>()
                              .changeItemQuantityInCart(
                                EditQuantity(quantity: quantityNotifier.value),
                                cartItemsModel.cartItemId!,
                              );
                          // cartItemsModel.quantity = quantityNotifier.value;
                        },
                        onDecrement: () async {
                          if (quantityNotifier.value > 1) {
                            quantityNotifier.value--;
                            await context
                                .read<CartCubit>()
                                .changeItemQuantityInCart(
                                  EditQuantity(
                                    quantity: quantityNotifier.value,
                                  ),
                                  cartItemsModel.cartItemId!,
                                );
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.read<CartCubit>().deleteItemFromCart(
                            cartItemsModel.cartItemId!,
                          );
                        },
                        child: Text(
                          "Delete",
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<WishListCubit>().addWishListItem(
                              AddProductToWishListRequest(
                                productId: cartItemsModel.product!.id!,
                              ),
                            );
                            context.read<CartCubit>().deleteItemFromCart(
                              cartItemsModel.cartItemId!,
                            );
                          },
                          child: Text(
                            "Add To WishList",
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onInverseSurface,
                                ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
