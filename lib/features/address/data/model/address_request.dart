import 'package:equatable/equatable.dart';

class AddressRequest extends Equatable {
  final String? street;
  final String? city;
  final String? governorate;
  final String? postalCode;
  final bool? isDefault;
  final String? country;

  const AddressRequest({
    this.street,
    this.city,
    this.governorate,
    this.postalCode,
    this.isDefault,
    this.country,
  });

  factory AddressRequest.fromJson(Map<String, dynamic> json) {
    return AddressRequest(
      street: json['street'] as String?,
      city: json['city'] as String?,
      governorate: json['governorate'] as String?,
      postalCode: json['postal_code'] as String?,
      isDefault: json['is_default'] as bool?,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'street': street,
    'city': city,
    'governorate': governorate,
    'postal_code': postalCode,
    'is_default': isDefault,
    'country': country,
  };

  @override
  List<Object?> get props {
    return [street, city, governorate, postalCode, isDefault, country];
  }
}
