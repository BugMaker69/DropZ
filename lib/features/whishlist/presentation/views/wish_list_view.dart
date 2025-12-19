import 'package:drop_z_ecommerce_app/core/utils/network_cubit/network_cubit.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_error_widget.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_loading_indicator.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_snakebar_message.dart';
import 'package:drop_z_ecommerce_app/core/widgets/offline_banner.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/presentation/manager/wish_list_cubit/wish_list_cubit.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/presentation/views/widgets/wish_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishListView extends StatelessWidget {
  const WishListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkCubit, NetworkState>(
      listener: (context, state) {
        if (state is NetworkConnected) {
          context.read<WishListCubit>().refreshWishlist(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Wishlist")),
        body: Column(
          children: [
            const OfflineBanner(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    context.read<WishListCubit>().refreshWishlist(context),
                child: BlocBuilder<WishListCubit, WishListState>(
                  builder: (context, state) {
                    if (state is WishListLoading) {
                      return const CustomLoadingIndicator();
                    }
                    if (state is AddItemToWishListSuccess) {
                      CustomSnakeBar(context, "Added to wishlist!");
                    }
                    if (state is DeleteItemFromWishListSuccess) {
                      CustomSnakeBar(context, "Removed from wishlist!");
                    }
                    if (state is WishListFailure) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomErrorWidget(
                              errMessage: "Error: ${state.errMessage}",
                            ),
                            const SizedBox(height: 16),
                            /*  ElevatedButton(
                              onPressed: () => context
                                  .read<WishListCubit>()
                                  .refreshWishlist(context),
                              child: const Text("Retry"),
                            ),
                          */
                          ],
                        ),
                      );
                    } else if (state is WishListSuccess) {
                      final data = state.wishListDataResponse;
                      if (data.count! > 0) {
                        return ListView.separated(
                          itemBuilder: (context, index) =>
                              WishListItem(wishListitem: data.items![index]),
                          itemCount: data.items!.length,
                          separatorBuilder: (context, index) => Divider(),
                        );
                      } else {
                        return const CustomErrorWidget(
                          errMessage: "Your wishlist is empty",
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
    );
  }
}
