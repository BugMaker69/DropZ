// import 'package:equatable/equatable.dart';

// class UpdateUserData extends Equatable {
//   final String? firstName;
//   final String? lastName;
//   final String? email;
//   final String? phoneNumber;

//   const UpdateUserData({
//     this.firstName,
//     this.lastName,
//     this.email,
//     this.phoneNumber,
//   });

//   factory UpdateUserData.fromJson(Map<String, dynamic> json) {
//     return UpdateUserData(
//       firstName: json['first_name'] as String?,
//       lastName: json['last_name'] as String?,
//       email: json['email'] as String?,
//       phoneNumber: json['phone_number'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'first_name': firstName,
//     'last_name': lastName,
//     'email': email,
//     'phone_number': phoneNumber,
//   };

//   @override
//   List<Object?> get props => [firstName, lastName, email, phoneNumber];
// }
