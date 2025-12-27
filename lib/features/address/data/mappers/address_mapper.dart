import 'package:drop_z_ecommerce_app/features/address/data/model/address_request_model.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_response_model.dart';

import '../../domain/entities/address_entity.dart';

class AddressMapper {
  /// Response Model → Entity
  static AddressEntity toEntity(AddressResponseModel model) {
    return AddressEntity(
      id: model.id ?? 0,
      userId: model.user ?? 0,
      street: model.street ?? '',
      city: model.city ?? '',
      governorate: model.governorate ?? '',
      postalCode: model.postalCode ?? '',
      country: model.country ?? '',
      isDefault: model.isDefault ?? false,
    );
  }

  /// Entity → Request Model
  static AddressRequestModel toRequestModel(AddressEntity entity) {
    return AddressRequestModel(
      street: entity.street,
      city: entity.city,
      governorate: entity.governorate,
      postalCode: entity.postalCode,
      country: entity.country,
      isDefault: entity.isDefault,
    );
  }
}
