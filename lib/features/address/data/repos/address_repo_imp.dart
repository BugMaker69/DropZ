import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/core/utils/repo_request.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_request.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_response/address_response.dart';
import 'package:drop_z_ecommerce_app/features/address/data/repos/address_repo.dart';

class AddressRepoImp extends AddressRepo {
  final ApiService apiService;
  AddressRepoImp(this.apiService);

  @override
  Future<Either<Failure, List<AddressResponse>>> getAllAddresses() {
    return RepoRequest.call(
      request: () => apiService.get(endPoint: "/addresses/"),
      parser: (data) =>
          (data as List).map((e) => AddressResponse.fromJson(e)).toList(),
    );
  }

  @override
  Future<Either<Failure, AddressResponse>> addAddress(AddressRequest req) {
    return RepoRequest.call(
      request: () =>
          apiService.post(endPoint: "/addresses/", data: req.toJson()),
      parser: (data) => AddressResponse.fromJson(data),
    );
  }

  @override
  Future<Either<Failure, AddressResponse>> updateAddress(
    int id,
    AddressRequest req,
  ) {
    return RepoRequest.call(
      request: () =>
          apiService.patch(endPoint: "/addresses/$id/", data: req.toJson()),
      parser: (data) => AddressResponse.fromJson(data),
    );
  }

  @override
  Future<Either<Failure, String>> deleteAddress(int id) {
    return RepoRequest.call(
      request: () => apiService.delete(endPoint: "/addresses/$id/"),
      parser: (_) => "Address Deleted Successfully",
    );
  }
}
