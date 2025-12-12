import 'package:equatable/equatable.dart';

class ChangePasswordResponse extends Equatable {
  final String? message;

  const ChangePasswordResponse({this.message});

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(message: json['message'] as String?);
  }

  Map<String, dynamic> toJson() => {'message': message};

  @override
  List<Object?> get props => [message];
}
