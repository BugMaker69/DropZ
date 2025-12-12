import 'package:cached_network_image/cached_network_image.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/add_item_to_cart_request.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/cart_items_model/cart_items_model.dart';
import 'package:drop_z_ecommerce_app/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/result.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/manager/products_cubit/products_cubit.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/model/add_product_to_wish_list_request.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/model/wish_list_data_response/item.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/presentation/manager/wish_list_cubit/wish_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
    required this.filteredProduct,
    //  this.height,
  });

  final Result filteredProduct;
  // final double? height;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<CartCubit>()),
        BlocProvider.value(value: context.read<WishListCubit>()),
      ],
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          List<CartItemsModel> cartItems = [];

          if (state is CartSuccess) {
            cartItems = state.cartItemsModel.items!;
          }

          // ✅ check if this product already exists in cart
          bool isInCart = cartItems.any(
            (item) => item.product!.id == filteredProduct.id,
          );
          return BlocBuilder<WishListCubit, WishListState>(
            builder: (context, state) {
              bool isInWishList = false;
              List<Item> wishListItems = [];
              if (state is WishListSuccess) {
                wishListItems = state.wishListDataResponse.items ?? [];
                isInWishList = wishListItems.any(
                  (item) => item.product?.id == filteredProduct.id,
                );
              }
              final categories = context.read<ProductsCubit>().categories!;
              return Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: GestureDetector(
                  onTap: () {
                    //! Seller Edit Product Screen
                    GoRouter.of(context).push(
                      AppRouter.kSellerEditDeleteProductView,
                      extra: {
                        "categories": categories,
                        "product": filteredProduct,
                      },
                    );
                    // GoRouter.of(context).push(
                    //   AppRouter.kProductDetailsView,
                    //   extra: filteredProduct,
                    // );
                  },
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 200,
                        // height: height,
                        height: 190,

                        color: Color(0xffF5F5F5),
                        child: Stack(
                          children: [
                            Hero(
                              tag: 'product-hero-${filteredProduct.id}',
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: AspectRatio(
                                  aspectRatio: 270 / 250,
                                  child: CachedNetworkImage(
                                    imageUrl: filteredProduct.image ?? "",
                                    fit: BoxFit.scaleDown,
                                    errorWidget: (context, error, stackTrace) =>
                                        const Icon(
                                          Icons.broken_image,
                                          size: 48,
                                          color: Colors.grey,
                                        ),
                                    placeholder: (context, url) => const Center(
                                      child: CustomLoadingIndicator(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            /*Align(
                              alignment: AlignmentGeometry.topRight,
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Column(
                                  /*children: [
                                              _AnimatedIconButton(
                                                isActive: isInWishList,
                                                activeIcon: Icons.favorite,
                                                inactiveIcon:
                                                    Icons.favorite_border_outlined,
                                                activeColor: Colors.red,
                                                inactiveColor: Colors.black,
                                                onPressed: () {
                                                  if (isInWishList) {
                                                    final wishListItem = wishListItems
                                                        .firstWhere(
                                                          (item) =>
                                                              item.product!.id! ==
                                                              filteredProduct.id,
                                                        );
                                                    context
                                                        .read<WishListCubit>()
                                                        .removeWishListItem(
                                                          wishListItem.id!,
                                                        );
                                                  } else {
                                                    context
                                                        .read<WishListCubit>()
                                                        .addWishListItem(
                                                          AddProductToWishListRequest(
                                                            productId:
                                                                filteredProduct.id,
                                                          ),
                                                        );
                                                  }
                                                },
                                              ),
                                              _AnimatedIconButton(
                                                isActive: isInCart,
                                                activeIcon: Icons.shopping_cart_rounded,
                                                inactiveIcon:
                                                    Icons.shopping_cart_outlined,
                                                activeColor: kPriceColor,
                                                inactiveColor: Colors.black,
                                                onPressed: () {
                                                  if (isInCart) {
                                                    final cartItem = cartItems
                                                        .firstWhere(
                                                          (item) =>
                                                              item.product!.id ==
                                                              filteredProduct.id,
                                                        );
                                                    context
                                                        .read<CartCubit>()
                                                        .deleteItemFromCart(
                                                          cartItem.cartItemId!,
                                                        );
                                                  } else {
                                                    context
                                                        .read<CartCubit>()
                                                        .addItemToCart(
                                                          AddItemToCartRequest(
                                                            productId:
                                                                filteredProduct.id,
                                                            quantity: 1,
                                                          ),
                                                        );
                                                  }
                                                },
                                              ),
                                            ],
                                            */
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (isInWishList) {
                                          final wishListItem = wishListItems
                                              .firstWhere(
                                                (item) =>
                                                    item.product?.id ==
                                                    filteredProduct.id,
                                              );
                                          context
                                              .read<WishListCubit>()
                                              .removeWishListItem(
                                                filteredProduct.id!,
                                              );
                                        } else {
                                          // إضافة المنتج للـ Wishlist
                                          context
                                              .read<WishListCubit>()
                                              .addWishListItem(
                                                AddProductToWishListRequest(
                                                  productId: filteredProduct.id,
                                                ),
                                                context,
                                              );
                                        }
                                      },
                                      icon: Icon(
                                        isInWishList
                                            ? Icons.favorite
                                            : Icons.favorite_border_outlined,
                                        color: isInWishList
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (isInCart) {
                                          // ✅ لو موجود بالفعل احذفه
                                          final cartItem = cartItems.firstWhere(
                                            (item) =>
                                                item.product!.id ==
                                                filteredProduct.id,
                                          );
                                          context
                                              .read<CartCubit>()
                                              .deleteItemFromCart(
                                                cartItem.cartItemId!,
                                              );
                                        } else {
                                          // ✅ لو مش موجود أضفه
                                          context
                                              .read<CartCubit>()
                                              .addItemToCart(
                                                AddItemToCartRequest(
                                                  productId: filteredProduct.id,
                                                  quantity: 1,
                                                ),
                                              );
                                        }
                                      },
                                      icon: Icon(
                                        isInCart
                                            ? Icons.shopping_cart_rounded
                                            : Icons.shopping_cart_outlined,
                                        color: isInCart
                                            ? Colors
                                                  .green // ✅ لو موجود في الكارت يلون أخضر
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),*/
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "${filteredProduct.title}",
                        style: Styles.textStyle16Medium.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),

                      Text(
                        "\$${filteredProduct.price}",
                        style: TextStyle(color: Color(0xff009336)),
                      ),
                      SizedBox(height: 8),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RatingBar.builder(
                            initialRating: filteredProduct.averageRating!
                                .toDouble(),
                            minRating: 0,
                            itemSize: 20,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemBuilder: (context, _) =>
                                const Icon(Icons.star, color: Colors.amber),
                            onRatingUpdate: (rating) {},
                          ),
                          Text(
                            "${(filteredProduct.reviewCount)}",
                            style: Styles.textStyle16Medium.copyWith(
                              color: Color(0xff7F7F7F),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AnimatedIconButton extends StatefulWidget {
  final bool isActive;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onPressed;

  const _AnimatedIconButton({
    required this.isActive,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.activeColor,
    required this.inactiveColor,
    required this.onPressed,
  });

  @override
  __AnimatedIconButtonState createState() => __AnimatedIconButtonState();
}

class __AnimatedIconButtonState extends State<_AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) => _controller.reverse());
        widget.onPressed();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: IconButton(
          icon: Icon(
            widget.isActive ? widget.activeIcon : widget.inactiveIcon,
            color: widget.isActive ? widget.activeColor : widget.inactiveColor,
          ),
          onPressed: null, // Handled by GestureDetector
        ),
      ),
    );
  }
}
