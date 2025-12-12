// lib/features/cart/data/repos/checkout_repo.dart
import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';

abstract class CheckoutRepo {
  Future<Either<Failure, int>> createOrder(
    List<Map<String, dynamic>> items,
    int addressId,
  );
  Future<Either<Failure, int>> createCheckoutOrder(int cartId, int addressId);
}
