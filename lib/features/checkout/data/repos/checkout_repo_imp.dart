// lib/features/cart/data/repos/checkout_repo_imp.dart
import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/core/utils/repo_request.dart';
import 'package:drop_z_ecommerce_app/features/checkout/data/repos/checkout_repo.dart';

class CheckoutRepoImp implements CheckoutRepo {
  final ApiService apiService;

  CheckoutRepoImp(this.apiService);

  @override
  Future<Either<Failure, int>> createOrder(
    List<Map<String, dynamic>> items,
    int addressId,
  ) async {
    return RepoRequest.call(
      request: () => apiService.post(
        endPoint: "/orders/",
        data: {"items": items, "address_id": addressId},
      ),
      parser: (data) => data["id"] as int,
    );
  }

  @override
  Future<Either<Failure, int>> createCheckoutOrder(
    int cartId,
    int addressId,
  ) async {
    return RepoRequest.call(
      request: () => apiService.post(
        endPoint: "/orders/checkout/",
        data: {"cart_id": cartId, "shipping_address_id": addressId},
      ),
      parser: (data) => data["id"] as int,
    );
  }
}
