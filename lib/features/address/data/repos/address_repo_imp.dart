import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/core/utils/repo_request.dart';
import 'package:drop_z_ecommerce_app/features/address/data/mappers/address_mapper.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_request_model.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_response_model.dart';
import 'package:drop_z_ecommerce_app/features/address/data/repos/address_repo.dart';
import 'package:drop_z_ecommerce_app/features/address/domain/entities/address_entity.dart';

class AddressRepoImp extends AddressRepo {
  final ApiService apiService;
  AddressRepoImp(this.apiService);

  @override
  Future<Either<Failure, List<AddressEntity>>> getAllAddresses() {
    return RepoRequest.call(
      request: () => apiService.get(endPoint: "/addresses/"),
      parser: (data) => (data as List)
          .map((e) => AddressResponseModel.fromJson(e))
          .toList()
          .map(AddressMapper.toEntity)
          .toList(),
    );
  }

  @override
  Future<Either<Failure, void>> addAddress(AddressEntity req) {
    return RepoRequest.call(
      request: () => apiService.post(
        endPoint: "/addresses/",
        data: AddressMapper.toRequestModel(req).toJson(),
      ),
      parser: (data) => data,
    );
  }

  @override
  Future<Either<Failure, void>> updateAddress(int id, AddressEntity req) {
    return RepoRequest.call(
      request: () => apiService.patch(
        endPoint: "/addresses/$id/",
        data: AddressMapper.toRequestModel(req).toJson(),
      ),
      parser: (data) => data,
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
