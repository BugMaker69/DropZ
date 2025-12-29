import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/features/orders/data/model/order_model.dart';

import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/repo_request.dart';
import 'orders_repo.dart';

class OrdersRepoImpl implements OrdersRepo {
  final ApiService apiService;

  OrdersRepoImpl(this.apiService);

  @override
  Future<Either<Failure, List<OrderModel>>> getOrders() {
    return RepoRequest.call(
      request: () => apiService.get(endPoint: '/orders/'),
      parser: (data) {
        return (data as List).map((e) => OrderModel.fromJson(e)).toList();
      },
    );
  }
}
