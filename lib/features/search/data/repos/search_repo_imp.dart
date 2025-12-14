import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/core/utils/repo_request.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/product_item_data_model.dart';
import 'package:drop_z_ecommerce_app/features/search/data/repos/search_repo.dart';

class SearchRepoImp extends SearchRepo {
  final ApiService apiService;

  SearchRepoImp(this.apiService);

  @override
  Future<Either<Failure, ProductItemDataModel>> searchProducts(String query) =>
      RepoRequest.call<ProductItemDataModel>(
        request: () =>
            apiService.get(endPoint: "/products/", query: {'search': query}),
        parser: (data) => ProductItemDataModel.fromJson(data),
      );
}
