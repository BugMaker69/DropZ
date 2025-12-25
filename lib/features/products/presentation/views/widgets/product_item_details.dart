import 'package:cached_network_image/cached_network_image.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/styles.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_cached_network_image.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_snakebar_message.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/add_item_to_cart_request.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/cart_items_model/cart_items_model.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/edit_quantity.dart';
import 'package:drop_z_ecommerce_app/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/result.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/manager/products_cubit/products_cubit.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/model/add_product_to_wish_list_request.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/presentation/manager/wish_list_cubit/wish_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class ProductItemDetails extends StatelessWidget {
  ProductItemDetails({super.key, required this.filteredProduct, this.id});

  Result filteredProduct;
  final int? id;

  @override
  Widget build(BuildContext context) {
    // final quantityNotifier = ValueNotifier<int>(1); // 👈 تبدأ بـ 1

    final cartCubit = context.read<CartCubit>();

    CartItemsModel? existingCartItem;

    if (cartCubit.state is CartSuccess) {
      final cartItems = (cartCubit.state as CartSuccess).cartItemsModel;
      try {
        existingCartItem = cartItems.items!.firstWhere(
          (item) => item.product!.id == filteredProduct.id,
        );
      } catch (e) {
        existingCartItem = null; // 👈 لو مش موجود
      }
    } else {
      existingCartItem = null;
    }

    // ✅ نبدأ بالكمية الصح
    final quantityNotifier = ValueNotifier<int>(
      existingCartItem != null ? existingCartItem.quantity! : 1,
    );

    // ✅ نحاول نجيب المنتج لو موجود في الكارت
    // final existingCartItem = cartCubit.state is CartSuccess
    //     ? (cartCubit.state as CartSuccess).cartItemsModel.firstWhere(
    //         (item) => item.product!.id == filteredProduct.id,
    //         orElse: () => null,
    //       )
    //     : null;

    if (id != null &&
        (filteredProduct.id!.isNaN ||
            filteredProduct.id == 0 ||
            filteredProduct.id! < 0)) {
      final productCubit = context.read<ProductsCubit>();

      Result? productById;

      if (productCubit.state is AddProductSuccess) {
        final productItem =
            (productCubit.state as AddProductSuccess).result.results;
        // productById = productItem;
        try {
          productById = productItem!.firstWhere((item) => item.id == id);
          filteredProduct = productById;
        } catch (e) {
          productById = null; // 👈 لو مش موجود
        }
      } else {
        productById = null;
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: AlignmentGeometry.bottomRight,
                    child: IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        final link =
                            "http://localhost:3000/product/${filteredProduct.id}";
                        print(link);
                        Share.share(link);
                      },
                    ),
                  ),
                  Center(
                    child: Hero(
                      tag: 'product-hero-${filteredProduct.id}', // نفس الـ tag
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CustomCachedNetworkImage(
                          height: 300,
                          image: filteredProduct.image,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),

              Text(
                "${filteredProduct.title}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              FittedBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RatingBarIndicator(
                      rating: filteredProduct.averageRating!.toDouble(),
                      itemBuilder: (context, index) =>
                          const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 40.0, // حجم النجمة
                      direction: Axis.horizontal,
                    ),
                    Text(
                      "(${filteredProduct.reviewCount} Reviews)",
                      style: Styles.textStyle16Medium.copyWith(
                        color: Color(0xff7F7F7F),
                      ),
                    ),
                    Text(
                      (filteredProduct.stockQuantity! >= 0)
                          ? "InStock"
                          : "OutStock",
                      style: Styles.textStyle16Medium.copyWith(
                        color: (filteredProduct.stockQuantity! >= 0)
                            ? Color(0xff009336)
                            : Colors.red,
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Text(
                "\$${filteredProduct.price}",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Text(
                "${filteredProduct.description}",
                style: TextStyle(color: Colors.grey),
              ),

              const Divider(height: 30),

              const SizedBox(height: 20),

              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ValueListenableBuilder<int>(
                      valueListenable: quantityNotifier,
                      builder: (context, quantity, child) {
                        return IncrementDecrementButtonWidget(
                          quantity: quantity,
                          onIncrement: () {
                            if (quantityNotifier.value <
                                filteredProduct.stockQuantity!) {
                              quantityNotifier.value++;
                              if (existingCartItem != null) {
                                context
                                    .read<CartCubit>()
                                    .changeItemQuantityInCart(
                                      EditQuantity(
                                        quantity: quantityNotifier.value,
                                      ),
                                      existingCartItem.cartItemId!,
                                    );
                              }
                            } else {
                              CustomSnakeBar(
                                context,
                                "You reached the maximum available stock.",
                              );
                            }
                          },
                          onDecrement: () {
                            if (quantityNotifier.value > 1) {
                              quantityNotifier.value--;
                              existingCartItem != null
                                  ? context
                                        .read<CartCubit>()
                                        .changeItemQuantityInCart(
                                          EditQuantity(
                                            quantity: quantityNotifier.value,
                                          ),
                                          existingCartItem.cartItemId!,
                                        )
                                  : null;
                            }
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff083947),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        await context.read<CartCubit>().addItemToCart(
                          AddItemToCartRequest(
                            productId: filteredProduct.id,
                            quantity: quantityNotifier.value,
                          ),
                        );
                        if (!context.mounted) return;
                        GoRouter.of(context).push(AppRouter.kCustomerCheckout);
                      },
                      child: Text(
                        "Buy Now",
                        style: Styles.textStyle16Regular.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () async {
                      final cubit = context.read<WishListCubit>();
                      if (filteredProduct.isInWishlist!) {
                        await cubit.removeWishListItem(filteredProduct.id!);
                      }
                      await cubit.addWishListItem(
                        AddProductToWishListRequest(
                          productId: filteredProduct.id,
                        ),
                      );
                    },
                    icon: const Icon(Icons.favorite_border),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "SubTotal: ",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  ValueListenableBuilder<int>(
                    valueListenable: quantityNotifier,
                    builder: (context, quantity, _) {
                      final price =
                          double.tryParse(filteredProduct.price ?? "0") ?? 0;
                      final subtotal = price * quantity;
                      return Text(
                        "\$${subtotal.toStringAsFixed(2)}",
                        // " \$${existingCartItem != null ? existingCartItem.itemSubtotal : filteredProduct.price}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).push(
                        AppRouter.kProductReviewsView,
                        extra: {
                          'slug': filteredProduct.slug,
                          'productId': filteredProduct.id,
                        },
                      );
                    },
                    child: Text("Add Review", style: Styles.textStyle16Medium),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ====== Free Delivery ======
              _buildInfoCard(
                icon: Icons.local_shipping_outlined,
                title: "Free Delivery",
                subtitle: "Enter your postal code for Delivery Availability",
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                icon: Icons.refresh,
                title: "Return Delivery",
                subtitle: "Free 30 Days Delivery Returns. Details",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Color(0xff083947)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IncrementDecrementButtonWidget extends StatelessWidget {
  const IncrementDecrementButtonWidget({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // زرار ناقص
          InkWell(
            onTap: onDecrement,
            child: Container(
              width: 50,
              height: 45,
              alignment: Alignment.center,
              child: const Text(
                "-",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // الرقم
          Container(
            width: 50,
            height: 45,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey),
                right: BorderSide(color: Colors.grey),
              ),
            ),
            child: Text(
              "$quantity",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // زرار زائد (ملون)
          InkWell(
            onTap: onIncrement,
            child: Container(
              width: 50,
              height: 45,
              decoration: BoxDecoration(
                color: Color(0xff083947),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                "+",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
