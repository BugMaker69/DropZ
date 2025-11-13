import 'package:equatable/equatable.dart';

import 'user.dart';

class LoginSuccessResponse extends Equatable {
  final String? access;
  final User? user;

  const LoginSuccessResponse({this.access, this.user});

  factory LoginSuccessResponse.fromJson(Map<String, dynamic> json) {
    return LoginSuccessResponse(
      access: json['access'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'access': access, 'user': user?.toJson()};

  @override
  List<Object?> get props => [access, user];
}
