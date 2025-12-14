import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/core/utils/repo_request.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/model/add_review_request.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/model/get_all_reviews/get_all_reviews.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/repos/products_review_repo.dart';

class ProductsReviewRepoImp extends ProductsReviewRepo {
  ProductsReviewRepoImp(this.apiService);
  final ApiService apiService;

  @override
  Future<Either<Failure, List<GetAllReviews>>> getAllProductReviews(
    String slug,
  ) => RepoRequest.call<List<GetAllReviews>>(
    request: () => apiService.get(endPoint: "/products/$slug/reviews"),
    parser: (data) =>
        (data as List).map((item) => GetAllReviews.fromJson(item)).toList(),
  );

  @override
  Future<Either<Failure, GetAllReviews>> addProductReview(
    String slug,
    AddReviewRequest addReviewRequest,
  ) => RepoRequest.call<GetAllReviews>(
    request: () => apiService.post(
      endPoint: "/products/$slug/reviews",
      data: addReviewRequest.toJson(),
    ),
    parser: (data) => GetAllReviews.fromJson(data),
  );

  @override
  Future<Either<Failure, GetAllReviews>> editProductReview(
    int reviewId,
    AddReviewRequest addReviewRequest,
  ) => RepoRequest.call<GetAllReviews>(
    request: () => apiService.patch(
      endPoint: "/reviews/$reviewId",
      data: addReviewRequest.toJson(),
    ),
    parser: (data) => GetAllReviews.fromJson(data),
  );

  @override
  Future<Either<Failure, String>> deleteProductReview(int reviewId) =>
      RepoRequest.call<String>(
        request: () => apiService.delete(endPoint: "/reviews/$reviewId"),
        parser: (response) {
          if (response.statusCode == 204) {
            return "Product deleted successfully";
          }

          return response.data?["message"] ?? "Deleted successfully";
        },
      );
}
