import 'package:equatable/equatable.dart';
import '../../domain/entities/address_entity.dart';

class AddressRequestModel extends Equatable {
  final String street;
  final String city;
  final String governorate;
  final String postalCode;
  final bool isDefault;
  final String country;

  const AddressRequestModel({
    required this.street,
    required this.city,
    required this.governorate,
    required this.postalCode,
    required this.isDefault,
    required this.country,
  });

  factory AddressRequestModel.fromJson(Map<String, dynamic> json) {
    return AddressRequestModel(
      street: json['street'],
      city: json['city'],
      governorate: json['governorate'],
      postalCode: json['postal_code'],
      isDefault: json['is_default'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'governorate': governorate,
      'postal_code': postalCode,
      'is_default': isDefault,
      'country': country,
    };
  }

  /// 🔁 Entity → Model
  factory AddressRequestModel.fromEntity(AddressEntity entity) {
    return AddressRequestModel(
      street: entity.street,
      city: entity.city,
      governorate: entity.governorate,
      postalCode: entity.postalCode,
      isDefault: entity.isDefault,
      country: entity.country,
    );
  }

  @override
  List<Object> get props => [
    street,
    city,
    governorate,
    postalCode,
    isDefault,
    country,
  ];
}
