import 'package:equatable/equatable.dart';

class GetUserDataSuccess extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic profileImage;

  const GetUserDataSuccess({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
    this.profileImage,
  });

  factory GetUserDataSuccess.fromJson(Map<String, dynamic> json) {
    return GetUserDataSuccess(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      profileImage: json['profile_image'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone_number': phoneNumber,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'profile_image': profileImage,
  };

  Map<String, dynamic> toUpdateJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone_number': phoneNumber,
    'profile_image': profileImage,
  };

  @override
  List<Object?> get props {
    return [
      firstName,
      lastName,
      email,
      phoneNumber,
      createdAt,
      updatedAt,
      profileImage,
    ];
  }
}
