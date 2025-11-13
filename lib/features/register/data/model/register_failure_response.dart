import 'package:equatable/equatable.dart';

class RegisterFailureResponse extends Equatable {
  final List<String>? email;
  final List<String>? password;
  final List<String>? confirmPassword;
  final List<String>? firstName;
  final List<String>? lastName;
  final List<String>? role;

  const RegisterFailureResponse({
    this.email,
    this.password,
    this.confirmPassword,
    this.firstName,
    this.lastName,
    this.role,
  });

  factory RegisterFailureResponse.fromJson(Map<String, dynamic> json) {
    return RegisterFailureResponse(
      email: json['email'] as List<String>?,
      password: json['password'] as List<String>?,
      confirmPassword: json['confirm_password'] as List<String>?,
      firstName: json['first_name'] as List<String>?,
      lastName: json['last_name'] as List<String>?,
      role: json['role'] as List<String>?,
    );
  }

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
