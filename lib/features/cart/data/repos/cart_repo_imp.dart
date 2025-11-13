import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/add_item_to_cart_request.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/add_item_to_cart_response.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/cart_items_model/cart_items_model.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/delete_item_response.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/edit_quantity.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/repos/cart_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepoImp extends CartRepo {
  ApiService apiService;
  SharedPreferences preferences;
  List<CartItemsModel>? _cachedCartItems;
  CartRepoImp(this.apiService, this.preferences);

  @override
  Future<Either<Failure, List<CartItemsModel>>> getCartItems() async {
    // if (_cachedCartItems != null) {
    //   return Right(_cachedCartItems!);
    // }
    try {
      var data = await apiService.get(
        endPoint: "/cart/items",
        token: preferences.getString("accessToken"),
      );

      print("getCartItems Repo ${data}");

      // CartItemsModel cartItemsModel = CartItemsModel.fromJson(data);
      // final List<CartItemsModel> cartItemsModel = (data as List)
      //     .map((item) => CartItemsModel.fromJson(item))
      //     .toList();
      final List<CartItemsModel> cartItemsModel = (data as List)
          .map((item) => CartItemsModel.fromJson(item as Map<String, dynamic>))
          .toList();
      _cachedCartItems = cartItemsModel;
      print("getCartItems Repo CartItemsModel ${cartItemsModel}");

      return right(cartItemsModel);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AddItemToCartResponse>> addItemToCart(
    AddItemToCartRequest additem,
  ) async {
    try {
      var data = await apiService.post(
        token: preferences.getString("accessToken"),
        endPoint: "/cart/additem",
        data: additem.toJson(),
      );

      AddItemToCartResponse addItemToCartResponse =
          AddItemToCartResponse.fromJson(data);
      return right(addItemToCartResponse);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EditQuantity>> changeItemQuantityInCart(
    EditQuantity changeQuantity,
    int itemIdInCart,
  ) async {
    try {
      var data = await apiService.patch(
        token: preferences.getString("accessToken"),
        endPoint: "/cart/update/$itemIdInCart",
        data: changeQuantity.toJson(),
      );

      EditQuantity editQuantity = EditQuantity.fromJson(data);

      return right(editQuantity);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DeleteItemResponse>> deleteItemFromCart(
    int cartItemId,
  ) async {
    try {
      var data = await apiService.delete(
        endPoint: "/cart/delete/$cartItemId",
        token: preferences.getString("accessToken"),
      );

      DeleteItemResponse deleteItemResponse = DeleteItemResponse.fromJson(data);
      return right(deleteItemResponse);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  Future<void> clearCacheAndReload() async {
    _cachedCartItems = null;
  }
}
