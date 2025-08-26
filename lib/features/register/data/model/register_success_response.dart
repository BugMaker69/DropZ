import 'package:equatable/equatable.dart';

class RegisterSuccessResponse extends Equatable {
  final String? message;

  const RegisterSuccessResponse({this.message});

  factory RegisterSuccessResponse.fromJson(Map<String, dynamic> json) =>
      RegisterSuccessResponse(message: json['message'] as String?);

  Map<String, dynamic> toJson() => {'message': message};

  @override
  List<Object?> get props => [message];
}
