import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/product_item_data_model.dart';
import 'package:drop_z_ecommerce_app/features/search/data/repos/search_repo.dart';

class SearchRepoImp extends SearchRepo {
  final ApiService apiService;

  SearchRepoImp(this.apiService);

  @override
  Future<Either<Failure, ProductItemDataModel>> searchProducts(
    String query,
  ) async {
    try {
      final data = await apiService.get(
        endPoint: "/products/",
        query: {'search': query},
      );

      final productData = ProductItemDataModel.fromJson(data);
      return right(productData);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
