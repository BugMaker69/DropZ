// lib/features/home/widgets/staggered_product_item.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/add_item_to_cart_request.dart';
import 'package:drop_z_ecommerce_app/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/result.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/model/add_product_to_wish_list_request.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/presentation/manager/wish_list_cubit/wish_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';

class StaggeredProductItem extends StatelessWidget {
  final Result product;
  final double height;

  const StaggeredProductItem({
    super.key,
    required this.product,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<CartCubit>()),
        BlocProvider.value(value: context.read<WishListCubit>()),
      ],
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final isInCart = state is CartSuccess
              ? state.cartItemsModel.items!.any(
                  (i) => i.product!.id == product.id,
                )
              : false;

          return BlocBuilder<WishListCubit, WishListState>(
            builder: (context, state) {
              final isInWishList = state is WishListSuccess
                  ? (state.wishListDataResponse.items ?? []).any(
                      (i) => i.product?.id == product.id,
                    )
                  : false;

              return GestureDetector(
                onTap: () =>
                    context.push(AppRouter.kProductDetailsView, extra: product),
                child: Container(
                  width: double.infinity,
                  height: height,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // الصورة
                        Hero(
                          tag: 'product-hero-${product.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl: product.image ?? "",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorWidget: (_, __, ___) => const Icon(
                                Icons.broken_image,
                                size: 40,
                                color: Colors.grey,
                              ),
                              placeholder: (context, url) =>
                                  const Center(child: CustomLoadingIndicator()),
                            ),
                          ),
                        ),

                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                ],
                                stops: const [0.5, 1.0],
                              ),
                            ),
                          ),
                        ),

                        // الأيقونات
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Column(
                            children: [
                              _buildIconButton(
                                context,
                                icon: isInWishList
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isInWishList ? Colors.red : Colors.black,
                                onTap: () {
                                  if (isInWishList) {
                                    context
                                        .read<WishListCubit>()
                                        .removeWishListItem(product.id!);
                                  } else {
                                    context
                                        .read<WishListCubit>()
                                        .addWishListItem(
                                          AddProductToWishListRequest(
                                            productId: product.id,
                                          ),
                                        );
                                  }
                                },
                              ),
                              const SizedBox(height: 8),
                              _buildIconButton(
                                context,
                                icon: isInCart
                                    ? Icons.shopping_cart_rounded
                                    : Icons.shopping_cart_outlined,
                                color: isInCart ? Colors.green : Colors.black,
                                onTap: () {
                                  if (isInCart) {
                                    final item =
                                        (context.read<CartCubit>().state
                                                as CartSuccess)
                                            .cartItemsModel
                                            .items!
                                            .firstWhere(
                                              (i) =>
                                                  i.product!.id == product.id,
                                            );
                                    context
                                        .read<CartCubit>()
                                        .deleteItemFromCart(item.cartItemId!);
                                  } else {
                                    context.read<CartCubit>().addItemToCart(
                                      AddItemToCartRequest(
                                        productId: product.id,
                                        quantity: 1,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        // النص تحت
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(16),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title ?? "",
                                  style: Styles.textStyle16Medium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "\$${product.price}",
                                  style: const TextStyle(
                                    color: Color(0xff009336),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    RatingBar.builder(
                                      initialRating: product.averageRating!
                                          .toDouble(),
                                      itemSize: 16,
                                      itemCount: 5,
                                      itemBuilder: (_, __) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (_) {},
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "(${product.reviewCount})",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xff7F7F7F),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}
