import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/model/add_review_request.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/model/get_all_reviews/get_all_reviews.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/repos/products_review_repo.dart';

class ProductsReviewRepoImp extends ProductsReviewRepo {
  ProductsReviewRepoImp(this.apiService);
  final ApiService apiService;

  @override
  Future<Either<Failure, List<GetAllReviews>>> getAllProductReviews(
    String slug,
  ) async {
    try {
      var result = await apiService.get(endPoint: "/products/$slug/reviews");

      print("DAta Products + ${result}");

      final List<GetAllReviews> getAllReviews = (result as List)
          .map((item) => GetAllReviews.fromJson(item))
          .toList();

      return right(getAllReviews);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetAllReviews>> addProductReview(
    String slug,
    AddReviewRequest addReviewRequest,
  ) async {
    try {
      var result = await apiService.post(
        endPoint: "/products/$slug/reviews",
        data: addReviewRequest.toJson(),
      );

      print("DAta Products + ${result}");

      final GetAllReviews getReview = GetAllReviews.fromJson(result);

      return right(getReview);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetAllReviews>> editProductReview(
    int reviewId,
    AddReviewRequest addReviewRequest,
  ) async {
    try {
      var result = await apiService.patch(
        endPoint: "/reviews/$reviewId",
        data: addReviewRequest.toJson(),
      );

      print("DAta Products + ${result}");

      final GetAllReviews getReview = GetAllReviews.fromJson(result);

      return right(getReview);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteProductReview(int reviewId) async {
    try {
      var result = await apiService.delete(endPoint: "/reviews/$reviewId");

      print("DAta Products + ${result}");
      if (result.statusCode == 204) {
        return const Right("Product deleted successfully");
      }

      return right(result.data?["message"] ?? "Deleted successfully");
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
