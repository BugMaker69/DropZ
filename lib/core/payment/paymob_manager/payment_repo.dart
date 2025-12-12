import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/get_user_data_success.dart';

abstract class PaymentRepo {
  Future<Either<Failure, String>> getAuthenticationToken();

  Future<Either<Failure, int>> getOrderId({
    required String authenticationToken,
    required String amount,
    required String currency,
  });

  Future<Either<Failure, String>> getPaymentKey({
    required String authenticationToken,
    required String orderId,
    required String amount,
    required String currency,
    required GetUserDataSuccess userData,
  });

  Future<Either<Failure, GetUserDataSuccess>> getUserData();

  Future<Either<Failure, String>> getFinalPaymentKey({
    required int amount,
    required String currency,
  });
}
