import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
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
            Image.network(
              width: 150,
              height: 150,
              wishListitem.product?.image ?? "",
              fit: BoxFit.scaleDown,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 48, color: Colors.grey),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(child: CustomLoadingIndicator());
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    "${wishListitem.product?.title}",
                    style: Styles.textStyle16Medium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${wishListitem.product?.seller}",
                    style: Styles.textStyle16Medium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "\$${wishListitem.product?.price}",
                    style: TextStyle(color: Color(0xff009336)),
                  ),
                  SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.read<WishListCubit>().removeWishListItem(
                            wishListitem.product!.id!,
                          );
                        },
                        child: Text(
                          "Delete",
                          style: Styles.textStyle16Medium.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      ElevatedButton(
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
                          style: Styles.textStyle16Medium,
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
