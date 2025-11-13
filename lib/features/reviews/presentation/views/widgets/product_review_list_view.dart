import 'package:drop_z_ecommerce_app/features/reviews/presentation/manager/products_review_cubit/products_review_cubit.dart';
import 'package:drop_z_ecommerce_app/features/reviews/presentation/views/widgets/edit_review_bottom_sheet.dart';
import 'package:drop_z_ecommerce_app/features/reviews/presentation/views/widgets/product_review_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductReviewListView extends StatelessWidget {
  // final List<GetAllReviews> getAllReviews;
  final String slug;
  const ProductReviewListView({
    super.key,
    // required this.getAllReviews,
    required this.slug,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsReviewCubit, ProductsReviewState>(
      builder: (context, state) {
        if (state is ProductsReviewLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProductsReviewSuccess) {
          final reviews = state.getAllReviews;
          if (reviews!.isEmpty) {
            return const Center(child: Text("لا توجد تقييمات بعد"));
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            // padding: const EdgeInsets.only(bottom: 120),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              return ProductReviewItem(
                getReview: reviews[index],
                slug: slug,
                onEdit: () {
                  final cubit = context
                      .read<ProductsReviewCubit>(); // خد الـ cubit من هنا

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    backgroundColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (_) => BlocProvider.value(
                      value: cubit, // مرر الـ cubit هنا
                      child: EditReviewBottomSheet(
                        review: reviews[index],
                        slug: slug,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
        return const Center(child: Text("حدث خطأ، حاول مرة أخرى"));
      },
    );

    //  getAllReviews.length > 0
    //     ? ListView.builder(
    //         padding: const EdgeInsets.all(16),
    //         itemBuilder: (context, index) =>
    //             ProductReviewItem(getReview: getAllReviews[index]),
    //         // separatorBuilder: (context, index) => SizedBox(width: 30),
    //         // scrollDirection: Axis.horizontal,
    //         itemCount: getAllReviews.length,
    //       )
    //     : Center(child: Text("No Reviews Yet"));
  }
}
