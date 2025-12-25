import 'package:cached_network_image/cached_network_image.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_cached_network_image.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/add_item_to_cart_request.dart';
import 'package:drop_z_ecommerce_app/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/model/wish_list_data_response/item.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/presentation/manager/wish_list_cubit/wish_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishListItem extends StatelessWidget {
  const WishListItem({super.key, required this.wishListitem});
  final Item wishListitem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomCachedNetworkImage(
              image: wishListitem.product?.image,
              width: 150,
              height: 150,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    "${wishListitem.product?.title}",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${wishListitem.product?.seller}",
                    style: Theme.of(context).textTheme.titleSmall!,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "\$${wishListitem.product?.price}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.read<WishListCubit>().removeWishListItem(
                            wishListitem.product!.id!,
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
                            context.read<CartCubit>().addItemToCart(
                              AddItemToCartRequest(
                                productId: wishListitem.product!.id!,
                                quantity: 1,
                              ),
                            );
                            context.read<WishListCubit>().removeWishListItem(
                              wishListitem.product!.id!,
                            );
                          },
                          child: Text(
                            "Add To Cart",
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

                      SizedBox(width: 8),
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
