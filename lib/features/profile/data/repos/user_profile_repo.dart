import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/get_user_data_success.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/logout_message.dart';

abstract class UserProfileRepo {
  Future<Either<Failure, GetUserDataSuccess>> getUserData(
    // String token
  );
  Future<Either<Failure, LogoutMessage>> logOut(
    // String token, String refreshToken
  );

  Future<Either<Failure, GetUserDataSuccess>> updateUserData(
    // String token,
    GetUserDataSuccess updateUserData,
  );
}
