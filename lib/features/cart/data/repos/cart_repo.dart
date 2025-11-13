import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/add_item_to_cart_request.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/add_item_to_cart_response.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/cart_items_model/cart_items_model.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/delete_item_response.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/model/edit_quantity.dart';

abstract class CartRepo {
  Future<Either<Failure, List<CartItemsModel>>> getCartItems();
  Future<Either<Failure, AddItemToCartResponse>> addItemToCart(
    AddItemToCartRequest additem,
  );
  Future<Either<Failure, DeleteItemResponse>> deleteItemFromCart(
    int cartItemId,
  );
  Future<Either<Failure, EditQuantity>> changeItemQuantityInCart(
    EditQuantity changeQuantity,
    int itemIdInCart,
  );
  Future<void> clearCacheAndReload();
}
