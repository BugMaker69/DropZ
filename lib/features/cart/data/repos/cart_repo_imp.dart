import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/core/utils/repo_request.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/add_item_to_cart_request.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/add_item_to_cart_response.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/cart_items_model/cart_model.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/delete_item_response.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/edit_quantity.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/repos/cart_repo.dart';

class CartRepoImp extends CartRepo {
  final ApiService apiService;

  CartRepoImp(this.apiService);

  @override
  Future<Either<Failure, CartModel>> getCartItems() async {
    return RepoRequest.call(
      request: () => apiService.get(endPoint: "/cart/items"),
      parser: (data) {
        if (data is! Map<String, dynamic>) {
          throw ServerFailure("Invalid response format");
        }
        final cartModel = CartModel.fromJson(data);
        return CartModel(
          cartId: cartModel.cartId,
          items: cartModel.items ?? [],
        );
      },
    );
  }

  @override
  Future<Either<Failure, AddItemToCartResponse>> addItemToCart(
    AddItemToCartRequest addItem,
  ) async {
    return RepoRequest.call(
      request: () =>
          apiService.post(endPoint: "/cart/additem", data: addItem.toJson()),
      parser: (data) => AddItemToCartResponse.fromJson(data),
    );
  }

  @override
  Future<Either<Failure, EditQuantity>> changeItemQuantityInCart(
    EditQuantity changeQuantity,
    int itemIdInCart,
  ) async {
    return RepoRequest.call(
      request: () => apiService.patch(
        endPoint: "/cart/update/$itemIdInCart",
        data: changeQuantity.toJson(),
      ),
      parser: (data) => EditQuantity.fromJson(data),
    );
  }

  @override
  Future<Either<Failure, DeleteItemResponse>> deleteItemFromCart(
    int cartItemId,
  ) async {
    return RepoRequest.call(
      request: () => apiService.delete(endPoint: "/cart/delete/$cartItemId"),
      parser: (data) => DeleteItemResponse.fromJson(data),
    );
  }

  @override
  Future<void> clearCacheAndReload() async {
    // إذا حابب تضيف Cache
  }
}
