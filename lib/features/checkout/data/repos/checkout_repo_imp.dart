// lib/features/cart/data/repos/checkout_repo_imp.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/features/checkout/data/repos/checkout_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutRepoImp implements CheckoutRepo {
  final ApiService apiService;

  CheckoutRepoImp(this.apiService);

  @override
  Future<Either<Failure, int>> createOrder(
    List<Map<String, dynamic>> items,
    int addressId,
  ) async {
    try {
      final data = await apiService.post(
        endPoint: "/orders/",
        data: {
          "items": items,
          "address_id": addressId, // 👈 أهم حاجة
        },
      );

      return right(data["id"] as int);
    } catch (e) {
      if (e is DioException) return left(ServerFailure.fromDioError(e));
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> createCheckoutOrder(
    int cartId,
    int addressId,
  ) async {
    try {
      final data = await apiService.post(
        endPoint: "/orders/checkout/",
        data: {"cart_id": cartId, "shipping_address_id": addressId},
      );

      return right(data["id"] as int);
    } catch (e) {
      if (e is DioException) return left(ServerFailure.fromDioError(e));
      return left(ServerFailure(e.toString()));
    }
  }
}
