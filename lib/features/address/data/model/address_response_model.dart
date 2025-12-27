import 'package:equatable/equatable.dart';

class AddressResponseModel extends Equatable {
  final int? id;
  final String? street;
  final String? city;
  final String? governorate;
  final String? postalCode;
  final String? country;
  final bool? isDefault;
  final int? user;

  const AddressResponseModel({
    this.id,
    this.street,
    this.city,
    this.governorate,
    this.postalCode,
    this.country,
    this.isDefault,
    this.user,
  });

  factory AddressResponseModel.fromJson(Map<String, dynamic> json) {
    return AddressResponseModel(
      id: json['id'] as int?,
      street: json['street'] as String?,
      city: json['city'] as String?,
      governorate: json['governorate'] as String?,
      postalCode: json['postal_code'] as String?,
      country: json['country'] as String?,
      isDefault: json['is_default'] as bool?,
      user: json['user'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'street': street,
      'city': city,
      'governorate': governorate,
      'postal_code': postalCode,
      'country': country,
      'is_default': isDefault,
      'user': user,
    };
  }

  @override
  List<Object?> get props => [
    id,
    street,
    city,
    governorate,
    postalCode,
    country,
    isDefault,
    user,
  ];
}
