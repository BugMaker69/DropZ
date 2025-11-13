import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/model/add_review_request.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/model/get_all_reviews/get_all_reviews.dart';

abstract class ProductsReviewRepo {
  Future<Either<Failure, List<GetAllReviews>>> getAllProductReviews(
    String slug,
  );

  Future<Either<Failure, GetAllReviews>> addProductReview(
    String slug,
    AddReviewRequest addReviewRequest,
  );

  Future<Either<Failure, GetAllReviews>> editProductReview(
    int reviewId,
    AddReviewRequest addReviewRequest,
  );

  Future<Either<Failure, String>> deleteProductReview(int reviewId);
}
