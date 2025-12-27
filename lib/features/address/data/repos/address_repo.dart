import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_request_model.dart';
import 'package:drop_z_ecommerce_app/features/address/domain/entities/address_entity.dart';

abstract class AddressRepo {
  Future<Either<Failure, List<AddressEntity>>> getAllAddresses();
  Future<Either<Failure, void>> addAddress(AddressEntity addAddress);
  Future<Either<Failure, void>> updateAddress(
    int id,
    AddressEntity addAddress,
  );
  Future<Either<Failure, String>> deleteAddress(int id); //! return 204
}
