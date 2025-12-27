import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final int? id;
  final String street;
  final String city;
  final String governorate;
  final String postalCode;
  final String country;
  final bool isDefault;
  final int? userId;

  const AddressEntity({
    this.id,
    required this.street,
    required this.city,
    required this.governorate,
    required this.postalCode,
    required this.country,
    required this.isDefault,
    this.userId,
  });

  @override
  List<Object> get props => [
    street,
    city,
    governorate,
    postalCode,
    country,
    isDefault,
  ];
}
