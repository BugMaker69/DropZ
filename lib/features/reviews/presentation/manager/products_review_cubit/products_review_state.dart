part of 'products_review_cubit.dart';

sealed class ProductsReviewState extends Equatable {
  const ProductsReviewState();

  @override
  List<Object> get props => [];
}

final class ProductsReviewInitial extends ProductsReviewState {}

final class ProductsReviewLoading extends ProductsReviewState {}

final class ProductsReviewSuccess extends ProductsReviewState {
  final List<GetAllReviews>? getAllReviews;

  const ProductsReviewSuccess({this.getAllReviews});
}

final class ProductsReviewFailure extends ProductsReviewState {
  final String errMessage;

  ProductsReviewFailure(this.errMessage);
}

final class addProductsReviewSuccess extends ProductsReviewState {
  final GetAllReviews? getReview;

  const addProductsReviewSuccess({this.getReview});
}

final class DeleteProductReviewSuccess extends ProductsReviewState {
  final String message;

  DeleteProductReviewSuccess(this.message);
}
