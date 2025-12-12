import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_request.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_response/address_response.dart';
import 'package:drop_z_ecommerce_app/features/address/data/repos/address_repo.dart';

class AddressRepoImp extends AddressRepo {
  ApiService apiService;

  AddressRepoImp(this.apiService);

  @override
  Future<Either<Failure, List<AddressResponse>>> getAllAddresses() async {
    try {
      var data = await apiService.get(endPoint: "/addresses/");

      final List<AddressResponse> allAddresses = (data as List)
          .map((item) => AddressResponse.fromJson(item))
          .toList();

      return right(allAddresses);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AddressResponse>> addAddress(
    AddressRequest addAddress,
  ) async {
    try {
      var data = await apiService.post(
        endPoint: "/addresses/",
        data: addAddress.toJson(),
      );

      AddressResponse addeddAddress = AddressResponse.fromJson(data);
      return right(addeddAddress);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteAddress(int id) async {
    try {
      var data = await apiService.delete(endPoint: "/addresses/$id/");

      String deletedAddress = "Address Deleted Succesfully";
      return right(deletedAddress);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AddressResponse>> updateAddress(
    int id,
    AddressRequest addAddress,
  ) async {
    try {
      var data = await apiService.patch(
        endPoint: "/addresses/$id/",
        data: addAddress.toJson(),
      );

      AddressResponse updateAddress = AddressResponse.fromJson(data);
      return right(updateAddress);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
