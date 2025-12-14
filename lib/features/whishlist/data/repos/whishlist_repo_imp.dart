import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/core/utils/repo_request.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/model/add_product_to_wish_list_request.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/model/add_remove_product_to_wish_list_response.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/model/wish_list_data_response/wish_list_data_response.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/repos/whishlist_repo.dart';

class WhishlistRepoImp extends WhishlistRepo {
  final ApiService apiService;

  WishListDataResponse? _cachedWishlist;

  WhishlistRepoImp(this.apiService);

  @override
  Future<Either<Failure, AddRemoveProductToWishListResponse>> addWishListItem(
    AddProductToWishListRequest request,
  ) => RepoRequest.call<AddRemoveProductToWishListResponse>(
    request: () =>
        apiService.post(endPoint: "/wishlist/add/", data: request.toJson()),
    parser: (data) => AddRemoveProductToWishListResponse.fromJson(data),
  );

  @override
  Future<Either<Failure, WishListDataResponse>> getAllWishList() {
    if (_cachedWishlist != null) {
      return Future.value(Right(_cachedWishlist!));
    }

    return RepoRequest.call<WishListDataResponse>(
      request: () => apiService.get(endPoint: "/wishlist/"),
      parser: (data) {
        final wishlist = WishListDataResponse.fromJson(data);
        _cachedWishlist = wishlist;
        return wishlist;
      },
    );
  }

  @override
  Future<Either<Failure, AddRemoveProductToWishListResponse>>
  removeWishListItem(int id) =>
      RepoRequest.call<AddRemoveProductToWishListResponse>(
        request: () => apiService.delete(endPoint: "/wishlist/remove/$id/"),
        parser: (data) => AddRemoveProductToWishListResponse.fromJson(data),
      );

  @override
  Future<void> clearCacheAndReload() async => _cachedWishlist = null;
}
