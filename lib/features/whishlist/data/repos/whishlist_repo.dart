import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/model/add_product_to_wish_list_request.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/model/add_remove_product_to_wish_list_response.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/model/wish_list_data_response/wish_list_data_response.dart';

abstract class WhishlistRepo {
  Future<Either<Failure, WishListDataResponse>> getAllWishList();
  Future<Either<Failure, AddRemoveProductToWishListResponse>>
  removeWishListItem(int id);
  Future<Either<Failure, AddRemoveProductToWishListResponse>> addWishListItem(
    AddProductToWishListRequest addProductToWishListRequest,
  );
  Future<void> clearCacheAndReload();
}
