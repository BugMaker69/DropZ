import 'package:bloc/bloc.dart';
import 'package:drop_z_ecommerce_app/core/utils/cubit_handler.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/model/add_review_request.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/model/get_all_reviews/get_all_reviews.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/repos/products_review_repo.dart';
import 'package:equatable/equatable.dart';

part 'products_review_state.dart';

class ProductsReviewCubit extends Cubit<ProductsReviewState> {
  ProductsReviewCubit(this.productsReviewRepo) : super(ProductsReviewInitial());

  final ProductsReviewRepo productsReviewRepo;
  String? currentSlug;

  Future<void> getAllProductReviews(String slug) async =>
      await CubitHandler.run<List<GetAllReviews>>(
        cubit: this,
        loadingState: () => emit(ProductsReviewLoading()),
        call: () => productsReviewRepo.getAllProductReviews(slug),
        onSuccess: (data) => emit(ProductsReviewSuccess(getAllReviews: data)),
        failureState: (msg) => emit(ProductsReviewFailure(msg)),
      );

  Future<void> addProductItemReview(
    String slug,
    AddReviewRequest addReviewRequest,
  ) async => await CubitHandler.run<GetAllReviews>(
    cubit: this,
    loadingState: () => emit(ProductsReviewLoading()),
    call: () => productsReviewRepo.addProductReview(slug, addReviewRequest),
    onSuccess: (_) async => await getAllProductReviews(slug),
    failureState: (msg) => emit(ProductsReviewFailure(msg)),
  );

  Future<void> updateProductItemReview(
    int reviewId,
    AddReviewRequest addReviewRequest,
  ) async => await CubitHandler.run<GetAllReviews>(
    cubit: this,
    loadingState: () => emit(ProductsReviewLoading()),
    call: () =>
        productsReviewRepo.editProductReview(reviewId, addReviewRequest),
    onSuccess: (_) async {
      if (currentSlug != null) {
        await getAllProductReviews(currentSlug!);
      }
    },
    failureState: (msg) => emit(ProductsReviewFailure(msg)),
  );

  Future<void> deleteProductItemReview(int id) async =>
      await CubitHandler.run<String>(
        cubit: this,
        loadingState: () => emit(ProductsReviewLoading()),
        call: () => productsReviewRepo.deleteProductReview(id),
        onSuccess: (message) async {
          if (currentSlug != null) {
            await getAllProductReviews(currentSlug!);
          }
          emit(DeleteProductReviewSuccess(message));
        },
        failureState: (msg) => emit(ProductsReviewFailure(msg)),
      );
}
