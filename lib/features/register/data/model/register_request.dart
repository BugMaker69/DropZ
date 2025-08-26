import 'package:equatable/equatable.dart';

class RegisterRequest extends Equatable {
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? firstName;
  final String? lastName;
  final String? role;

  const RegisterRequest({
    this.email,
    this.password,
    this.confirmPassword,
    this.firstName,
    this.lastName,
    this.role,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      RegisterRequest(
        email: json['email'] as String?,
        password: json['password'] as String?,
        confirmPassword: json['confirm_password'] as String?,
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        role: json['role'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'confirm_password': confirmPassword,
    'first_name': firstName,
    'last_name': lastName,
    'role': role,
  };

  @override
  List<Object?> get props {
    return [email, password, confirmPassword, firstName, lastName, role];
  }
}
