import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String? tokenClass;
  final String? tokenType;
  final String? message;

  const Message({this.tokenClass, this.tokenType, this.message});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    tokenClass: json['token_class'] as String?,
    tokenType: json['token_type'] as String?,
    message: json['message'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'token_class': tokenClass,
    'token_type': tokenType,
    'message': message,
  };

  @override
  List<Object?> get props => [tokenClass, tokenType, message];
}
