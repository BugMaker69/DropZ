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

  const ProductsReviewFailure(this.errMessage);
}

final class AddProductsReviewSuccess extends ProductsReviewState {
  final GetAllReviews? getReview;

  const AddProductsReviewSuccess({this.getReview});
}

final class DeleteProductReviewSuccess extends ProductsReviewState {
  final String message;

  const DeleteProductReviewSuccess(this.message);
}
