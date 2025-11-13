import 'package:equatable/equatable.dart';

class LoginFailureResponse extends Equatable {
  final String? detail;

  const LoginFailureResponse({this.detail});

  factory LoginFailureResponse.fromJson(Map<String, dynamic> json) {
    return LoginFailureResponse(detail: json['detail'] as String?);
  }

  Map<String, dynamic> toJson() => {'detail': detail};

  @override
  List<Object?> get props => [detail];
}
