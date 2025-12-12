import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_request.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_response/address_response.dart';

abstract class AddressRepo {
  Future<Either<Failure, List<AddressResponse>>> getAllAddresses();
  Future<Either<Failure, AddressResponse>> addAddress(
    AddressRequest addAddress,
  );
  Future<Either<Failure, AddressResponse>> updateAddress(
    int id,
    AddressRequest addAddress,
  );
  Future<Either<Failure, String>> deleteAddress(int id); //! return 204
}
