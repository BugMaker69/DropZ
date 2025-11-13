import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/model/add_product_to_wish_list_request.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/model/add_remove_product_to_wish_list_response.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/model/wish_list_data_response/wish_list_data_response.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/repos/whishlist_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WhishlistRepoImp extends WhishlistRepo {
  ApiService apiService;
  SharedPreferences preferences;
  WishListDataResponse? _cachedWishlist;
  WhishlistRepoImp(this.apiService, this.preferences);

  @override
  Future<Either<Failure, AddRemoveProductToWishListResponse>> addWishListItem(
    AddProductToWishListRequest addProductToWishListRequest,
  ) async {
    try {
      var data = await apiService.post(
        endPoint: "/wishlist/add/",
        token: preferences.getString("accessToken"),
        data: addProductToWishListRequest.toJson(),
      );

      AddRemoveProductToWishListResponse addRemoveProductToWishListResponse =
          AddRemoveProductToWishListResponse.fromJson(data);

      return right(addRemoveProductToWishListResponse);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WishListDataResponse>> getAllWishList() async {
    // if (_cachedWishlist != null) {
    //   return Right(_cachedWishlist!);
    // }
    try {
      var data = await apiService.get(
        endPoint: "/wishlist/",
        token: preferences.getString("accessToken"),
      );
      WishListDataResponse wishListDataResponse = WishListDataResponse.fromJson(
        data,
      );
      _cachedWishlist = wishListDataResponse;
      return right(wishListDataResponse);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AddRemoveProductToWishListResponse>>
  removeWishListItem(int id) async {
    try {
      var data = await apiService.delete(
        endPoint: "/wishlist/remove/$id/",
        token: preferences.getString("accessToken"),
      );
      AddRemoveProductToWishListResponse addRemoveProductToWishListResponse =
          AddRemoveProductToWishListResponse.fromJson(data);
      return right(addRemoveProductToWishListResponse);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  Future<void> clearCacheAndReload() async {
    _cachedWishlist = null;
  }
}
