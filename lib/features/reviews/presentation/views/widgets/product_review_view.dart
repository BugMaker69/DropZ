import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/utils/service_locator.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/repos/products_review_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/reviews/presentation/manager/products_review_cubit/products_review_cubit.dart';
import 'package:drop_z_ecommerce_app/features/reviews/presentation/views/widgets/add_product_review_section.dart';
import 'package:drop_z_ecommerce_app/features/reviews/presentation/views/widgets/product_review_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductReviewView extends StatelessWidget {
  // final List<GetAllReviews> getAllReviews;
  final int productId;
  final String slug;
  const ProductReviewView({
    super.key,
    // required this.getAllReviews,
    required this.productId,
    required this.slug,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductsReviewCubit(getIt.get<ProductsReviewRepoImp>())
            ..getAllProductReviews(slug),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Stack(
            children: [
              // القايمة
              ProductReviewListView(slug: slug),

              Align(
                alignment: Alignment.bottomCenter,
                child: AddReviewSection(slug: slug),
              ),

              // الـ TextField في الأسفل
              // AddReviewSection(
              //   productId: productId,
              //   slug: slug,
              //   allReviews: getAllReviews,
              // ),
            ],
          ),
          backgroundColor: kPrimaryColor,
        ),
      ),
    );
  }
}
