import 'package:bloc/bloc.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/model/add_review_request.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/model/get_all_reviews/get_all_reviews.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/repos/products_review_repo.dart';
import 'package:equatable/equatable.dart';

part 'products_review_state.dart';

class ProductsReviewCubit extends Cubit<ProductsReviewState> {
  ProductsReviewCubit(this.productsReviewRepo) : super(ProductsReviewInitial());

  final ProductsReviewRepo productsReviewRepo;

  String? currentSlug;

  Future<void> getAllProductReviews(String slug) async {
    currentSlug = slug;
    emit(ProductsReviewLoading());
    var result = await productsReviewRepo.getAllProductReviews(slug);

    result.fold(
      (failure) {
        emit(ProductsReviewFailure(failure.errMessage));
      },
      (productReviewSuccessResponse) {
        print("Products Success: ${productReviewSuccessResponse} products");
        emit(
          ProductsReviewSuccess(getAllReviews: productReviewSuccessResponse),
        );
        // emit(ProductsSuccess(productSuccessResponse));
      },
    );
  }

  Future<void> addProductItemReview(
    String slug,
    AddReviewRequest addReviewRequest,
  ) async {
    emit(ProductsReviewLoading());

    var result = await productsReviewRepo.addProductReview(
      slug,
      addReviewRequest,
    );

    result.fold((failure) => emit(ProductsReviewFailure(failure.errMessage)), (
      data,
    ) async {
      await getAllProductReviews(slug);
      // emit(addProductsReviewSuccess(getReview: data));
    });
  }

  Future<void> updateProductItemReview(
    int reviewId,
    AddReviewRequest addReviewRequest,
  ) async {
    emit(ProductsReviewLoading());

    var result = await productsReviewRepo.editProductReview(
      reviewId,
      addReviewRequest,
    );

    result.fold((failure) => emit(ProductsReviewFailure(failure.errMessage)), (
      data,
    ) async {
      if (currentSlug != null) {
        await getAllProductReviews(currentSlug!);
      }
      // emit(addProductsReviewSuccess(getReview: data));
    });
  }

  Future<void> deleteProductItemReview(int id) async {
    emit(ProductsReviewLoading());

    var result = await productsReviewRepo.deleteProductReview(id);
    result.fold((failure) => emit(ProductsReviewFailure(failure.errMessage)), (
      message,
    ) async {
      if (currentSlug != null) {
        await getAllProductReviews(currentSlug!);
      }
      emit(DeleteProductReviewSuccess(message));
    });
  }
}
