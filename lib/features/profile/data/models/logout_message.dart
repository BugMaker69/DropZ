import 'package:equatable/equatable.dart';

class LogoutMessage extends Equatable {
  final String? message;

  const LogoutMessage({this.message});

  factory LogoutMessage.fromJson(Map<String, dynamic> json) =>
      LogoutMessage(message: json['message'] as String?);

  Map<String, dynamic> toJson() => {'message': message};

  @override
  List<Object?> get props => [message];
}
