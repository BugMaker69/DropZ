import 'package:cached_network_image/cached_network_image.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
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
            CachedNetworkImage(
              width: 150,
              height: 150,
              imageUrl:
                  "http://10.0.2.2:8000/${cartItemsModel.product?.image}" ?? "",
              fit: BoxFit.scaleDown,
              errorWidget: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 48, color: Colors.grey),
              placeholder: (context, url) =>
                  const Center(child: CustomLoadingIndicator()),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    "${cartItemsModel.product?.title}",
                    style: Styles.textStyle16Medium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${cartItemsModel.product?.seller}",
                    style: Styles.textStyle16Medium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "\$${cartItemsModel.product?.price}",
                    style: TextStyle(color: Color(0xff009336)),
                  ),
                  SizedBox(height: 8),

                  Text(
                    "Total Price \$${cartItemsModel.itemSubtotal}",
                    style: TextStyle(color: Color(0xff009336)),
                  ),
                  SizedBox(height: 8),
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
                  SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.read<CartCubit>().deleteItemFromCart(
                            cartItemsModel.cartItemId!,
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
